//
//  MonthLessonsViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 16.04.2024.
//

import UIKit
import SnapKit

class MonthLessonsViewController: UIViewController, UITableViewDelegate, SaveChangesHandling, DidUpdateStudentDelegate {
    func didUpdateStudent(_ student: Student) {
        StudentStore.shared.updateStudent(student)
        self.student = student
        tableView?.reloadData()
        // Debug output
           print("Updated student: \(student)")
    }
    
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    weak var delegate: DidUpdateStudentDelegate?
    
    var student: Student!
    
    var changesMade = false
    
    var selectedMonth: Month!
    
    var lessonPrice: Double = 0.0
    var selectedSchedules = [(weekday: String, time: String)]()
    var schedule: [String] {
        var scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        scheduleStrings.sort()
        return scheduleStrings
    }
    var lessonsForStudent: [Lesson] = []
    
    let addScheduledLessonsButton = UIButton(type: .system)
    let addLessonButton = UIButton(type: .system)
    var tableView: UITableView?
    private let datePicker = UIDatePicker()
    let monthDictionary: [String: String] = [
        "January": "01",
        "February": "02",
        "March": "03",
        "April": "04",
        "May": "05",
        "June": "06",
        "July": "07",
        "August": "08",
        "September": "09",
        "October": "10",
        "November": "11",
        "December": "12"
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView?.reloadData()
        
        self.title = "Lessons List"
        // Регистрируем ячейку с использованием стиля .subtitle
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "LessonCell")
        
        // Ensure selectedMonth is set correctly
        print("Selected Month: \(selectedMonth.monthName) \(selectedMonth.monthYear)")
        
        // Заменяем кнопку "Back" на кастомную кнопку
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // Создаем кнопку "Поделиться"
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        // Создаем кнопку "Сохранить"
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        // Устанавливаем обе кнопки в правую часть навигационного бара
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
        checkIfScheduledLessonsAdded()
    }
    
    @objc func saveButtonTapped() {
        // Update lessons in the Month object in monthsArray
        selectedMonth.lessons = lessonsForStudent
        
        // Update student data
        if let index = student.months.firstIndex(where: { $0.monthName == selectedMonth.monthName && $0.monthYear == selectedMonth.monthYear }) {
            student.months[index] = selectedMonth
        }
        
        // Notify delegate about lesson updates
        delegate?.didUpdateStudent(student)
        
        changesMade = false
        navigationController?.popViewController(animated: true)
        
        // Reload table view to reflect changes
        tableView?.reloadData()
        
        // Debug output
           print("Saved lessons for \(selectedMonth.monthName) \(selectedMonth.monthYear):")
           for lesson in selectedMonth.lessons {
               print("\(lesson.date) - \(lesson.attended ? "Present" : "Absent")")
           }
    }
    
    @objc private func backButtonTapped() {
        savingConfirmation()
    }
    
    func checkIfScheduledLessonsAdded() {
        // Проверяем, пуст ли словарь lessonsForStudent для текущего месяца
        if !lessonsForStudent.isEmpty {
            addScheduledLessonsButton.setTitle("Delete all lessons", for: .normal)
            // Добавляем действие для кнопки при её нажатии после добавления уроков
            addScheduledLessonsButton.removeTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
            addScheduledLessonsButton.addTarget(self, action: #selector(deleteAllLessons), for: .touchUpInside)
        } else {
            addScheduledLessonsButton.setTitle("Add lessons according to the schedule", for: .normal)
            // Восстанавливаем действие для кнопки при её нажатии
            addScheduledLessonsButton.removeTarget(self, action: #selector(deleteAllLessons), for: .touchUpInside)
            addScheduledLessonsButton.addTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc func deleteAllLessons() {
        print("Deleting all lessons for \(selectedMonth.monthName) \(selectedMonth.monthYear)")
        // Удаляем все уроки для выбранного месяца из временного хранилища
        lessonsForStudent.removeAll()
        selectedMonth.lessons = lessonsForStudent
        
        tableView?.reloadData()
        // Обновляем состояние кнопки
        checkIfScheduledLessonsAdded()
        changesMade = true
        
        print("lessonsForStudent после удаления: \(lessonsForStudent)")
    }
    
    @objc func addScheduledLessonsButtonTapped() {
        
        print("Adding scheduled lessons for \(selectedMonth.monthName) \(selectedMonth.monthYear)")
        generateLessonsForMonth()
        
        selectedMonth.lessons = lessonsForStudent
        
        tableView?.reloadData()
        changesMade = true
        
        // Проверяем, были ли добавлены уроки согласно расписанию
        checkIfScheduledLessonsAdded()
        
        print("Adding scheduled lessons to selectedMonth.lessons \(selectedMonth.lessons)")
    }
    
    @objc func addLessonButtonTapped() {
        showDatePicker()
        changesMade = true
    }
    
    func showDatePicker() {
        let datePickerSheet = UIAlertController(title: "Lesson date", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePickerSheet.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        datePickerSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        datePickerSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: selectedDate)
            self.addLesson(date: dateString, year: self.selectedMonth.monthYear, month: self.selectedMonth.monthYear, attended: false)
        }))
        tableView?.reloadData()
        present(datePickerSheet, animated: true, completion: nil)
    }
}

extension MonthLessonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMonth.lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle , reuseIdentifier: "LessonCell")
        guard indexPath.row < selectedMonth.lessons.count else {
            fatalError("Lessons for selected month not found or index out of range")
        }
        // Получаем урок для текущего индекса
        let lesson = selectedMonth.lessons[indexPath.row]
        // Форматирование даты
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        // Получаем дату из строки даты
        guard let lessonDate = dateFormatter.date(from: lesson.date) else {
            fatalError("Failed to convert lesson date to Date.")
        }
        // Получаем название дня недели из даты
        let weekdayString = lessonDate.weekday() // Вызываем метод weekday
        // Создание строки для отображения в ячейке
        let lessonDateString = "\(indexPath.row + 1). \(dateFormatter.string(from: lessonDate))"
        // Установка текста в ячейку в зависимости от того, присутствовал ли студент на уроке
        cell.textLabel?.text = lessonDateString
        cell.detailTextLabel?.text = lesson.attended ? "Was present (\(weekdayString))" : "Was absent (\(weekdayString))"
        // Устанавливаем или снимаем галочку в зависимости от состояния урока
        cell.accessoryType = lesson.attended ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLessonUpdate(_:)), name: .lessonUpdatedNotification, object: nil)
        
        let lesson = selectedMonth.lessons[indexPath.row]
        
        // Создаем экземпляр LessonDetailsViewController
        let lessonDetailVC = LessonDetailsViewController()
        
        // Передаем необходимые данные в LessonDetailsViewController
        lessonDetailVC.student = student
        lessonDetailVC.lesson = lesson
        lessonDetailVC.updatedlessonsForStudent = lessonsForStudent
        lessonDetailVC.homeworksArray = selectedMonth.lessons.map { $0.homework ?? "" }
        
        // Устанавливаем делегата для обратного обновления данных
        lessonDetailVC.delegate = self
        
        // Переходим на экран LessonDetailsViewController
        navigationController?.pushViewController(lessonDetailVC, animated: true)
        
        print("Selected student: \(String(describing: student))")
        print("Selected lesson: \(lesson)")
    }
    
    @objc func handleLessonUpdate(_ notification: Notification) {
            guard let updatedLesson = notification.userInfo?["updatedLesson"] as? Lesson else {
                return
            }
        print("Received lesson update notification for lesson: \(updatedLesson)")
        
            // Обновляем уроки в MonthLessonsViewController
        if let index = selectedMonth.lessons.firstIndex(where: { $0.date == updatedLesson.date }) {
            selectedMonth.lessons[index] = updatedLesson
            lessonsForStudent = selectedMonth.lessons
            }
        
            tableView?.reloadData()
            changesMade = true
            // Debug output
            print("Updated lesson in MonthLessonsViewController")
        }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension Date {
    func weekday(using calendar: Calendar = Calendar(identifier: .gregorian)) -> String {
        let weekdayIndex = calendar.component(.weekday, from: self)
        let dateFormatter = DateFormatter()
        return dateFormatter.shortWeekdaySymbols[weekdayIndex - 1]
    }
}

extension Notification.Name {
    static let lessonUpdatedNotification = Notification.Name("LessonUpdatedNotification")
}

// MARK: - Lesson Management

extension MonthLessonsViewController {
    
    func addLesson(date: String, year: String, month: String, attended: Bool) {
        print("Adding lesson for date: \(date)")
        let lesson = Lesson(date: date, attended: attended)
        selectedMonth.lessons.append(lesson)
        lessonsForStudent = selectedMonth.lessons
        delegate?.didUpdateStudent(student)
        updateUI()
    }
    
    func updateUI() {
        guard let lessonTableView = self.tableView else { return }
        lessonTableView.reloadData()
    }
    
    func generateLessonsForMonth() {
        guard let monthName = selectedMonth?.monthName, let monthYear = selectedMonth?.monthYear else {
            print("Month or year is not set.")
            return
        }
        
        print("Generating lessons for month: \(monthName), year: \(monthYear)")
        
        let calendar = Calendar.current
        guard let monthNumber = monthDictionary[monthName] else {
            print("Failed to get month number for \(monthName)")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        selectedMonth.lessons.removeAll() // Очищаем уроки только для выбранного месяца
        
        guard let date = dateFormatter.date(from: "01.\(monthNumber).\(monthYear)") else {
            print("Failed to convert month to date with string: 01.\(monthNumber).\(monthYear)")
            return
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            print("Failed to get range of days in month for date: \(date)")
            return
        }
        
        for day in range.lowerBound..<range.upperBound {
            let dateString = String(format: "%02d.%02d.%@", day, Int(monthNumber)!, monthYear)
            if let currentDate = dateFormatter.date(from: dateString) {
                let weekday = calendar.component(.weekday, from: currentDate)
                let weekdayString = dateFormatter.shortWeekdaySymbols[weekday - 1].lowercased()
                
                for scheduleEntry in selectedSchedules {
                    let scheduleWeekday = scheduleEntry.0.lowercased()
                    if scheduleWeekday == weekdayString {
                        addLesson(date: dateString, year: monthYear, month: monthName, attended: false)
                    }
                }
            } else {
                print("Failed to convert dateString to date: \(dateString)")
            }
        }
    }
}

// MARK: - createShareMessage & shareButtonTapped

extension MonthLessonsViewController {
    
    func createShareMessage() -> String {
        guard let student = student else { return "" }
        let studentType = student.type
        let name = studentType == .schoolchild ? student.parentName : student.name
        let lessonsForSelectedMonth = lessonsForStudent
        let lessonCount = lessonsForSelectedMonth.count
        let lessonPrice: Double
        let currency: String
        if let month = student.months.first(where: { $0.monthName == student.month.monthName && $0.monthYear == student.month.monthYear }) {
            lessonPrice = month.lessonPrice.price
            currency = month.lessonPrice.currency
        } else {
            lessonPrice = student.lessonPrice.price
            currency = student.lessonPrice.currency
        }
        let totalSum = lessonPrice * Double(lessonCount)
        return "Hello, \(name)! There are \(lessonCount) lessons in \(selectedMonth.monthName) \(selectedMonth.monthYear) = \(totalSum) \(currency)."
    }
    
    @objc func shareButtonTapped() {
        let message = createShareMessage()
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        // Настройка для iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItems?.last
            popoverController.sourceView = self.view // для безопасности, хотя barButtonItem должно быть достаточно
        }
        present(activityViewController, animated: true, completion: nil)
    }
}
