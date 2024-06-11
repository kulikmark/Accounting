//
//  MonthLessonsViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 16.04.2024.
//

import UIKit
import SnapKit

extension MonthLessonsViewController {
    // Метод делегата для обновления уроков
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]]) {
        // Обновляем данные и перезагружаем таблицу
        lessonsForStudent = lessons.flatMap { $0.value }
        tableView?.reloadData()
    }
    
    // Метод делегата для обновления домашнего задания
    func didUpdateHomework(forLessonIndex index: Int, homework: String) {
        // Проверяем, существует ли урок с указанным индексом в массиве
        guard index >= 0, index < temporaryLessons[selectedMonth]?.count ?? 0 else {
            print("Lesson index out of range")
            return
        }
        
        // Обновляем домашнее задание у урока в temporaryLessons
        temporaryLessons[selectedMonth]?[index].homework = homework
        
        // Обновляем данные уроков для студента
        lessonsForStudent = temporaryLessons.flatMap { $0.value }
        
        // Перезагружаем данные в таблице
        tableView?.reloadData()
        
        changesMade = true
    }
    
    func didUpdateAttendance(forLessonIndex index: Int, attended: Bool) {
        // Обновляем домашнее задание у урока в temporaryLessons
        temporaryLessons[selectedMonth]?[index].attended = attended
        
        changesMade = true
    }
}

protocol MonthLessonsDelegate: AnyObject {
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]])
}

class MonthLessonsViewController: UIViewController, UITableViewDelegate, SaveChangesHandling, LessonDetailDelegate {
    
    weak var delegate: MonthLessonsDelegate?
    
    var student: Student?
    
    var changesMade = false
    
    var lessonPrice: String = ""
    var selectedMonth: String = ""
    var selectedYear: String = ""
    
    var selectedSchedules = [(weekday: String, time: String)]()
    
    // Добавим новое свойство для хранения расписания
    var schedule: [String] {
        var scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        scheduleStrings.sort() // Сортируем расписание по дням недели и времени
        return scheduleStrings
    }
    
    var temporaryLessons: [String: [Lesson]] = [:] // Список уроков для отображения
    var lessonsForStudent: [Lesson] = []
    
    let addScheduledLessonsButton = UIButton(type: .system)
    let addLessonButton = UIButton(type: .system)
    
    var tableView: UITableView? // Создаем свойство tableView
    
    private let datePicker = UIDatePicker()
    
    // Словарь для соответствия названий месяцев и их числовых представлений
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
    
    let titleLabel = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Настройка UI
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка UI
        setupUI()
        updateUI()
        
        // Регистрируем ячейку с использованием стиля .subtitle
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "LessonCell")
        
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
        loadLessonsForSelectedMonth()
    }
    
    @objc func shareButtonTapped() {
        let message = createShareMessage()
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        
        // Настройка для iPad
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.barButtonItem = self.navigationItem.rightBarButtonItems?.last
               popoverController.sourceView = self.view // для безопасности, хотя barButtonItem должно быть достаточно
           }
        
        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    func createShareMessage() -> String {
        guard let student = student else { return "" }
        let studentType = student.type
        let name = studentType == .schoolchild ? student.parentName : student.name
        let lessonCount = temporaryLessons[selectedMonth]?.count ?? 0
        let paidMonth = selectedMonth
        let lessonPrice = student.lessonPrice.price
        let currency = student.lessonPrice.currency
        let totalSum = (Double(lessonPrice) ?? 0.0) * Double(lessonCount)

        return "Hello, \(name)! There are \(lessonCount) lessons in \(paidMonth) = \(totalSum) \(currency)."
    }
    
    @objc func saveButtonTapped() {
        // Проверяем и сохраняем уроки для текущего месяца
        guard let lessonsForCurrentMonth = temporaryLessons[selectedMonth] else {
            return
        }
        
        // Обновляем данные студента
        if student?.lessons[selectedMonth] == nil {
            student?.lessons[selectedMonth] = []
        }
        student?.lessons[selectedMonth] = lessonsForCurrentMonth
        
        // Передаем обновленные данные через делегата
        delegate?.didUpdateStudentLessons(temporaryLessons)
        
        changesMade = false
        
        // Выводим состояние temporaryLessons после сохранения изменений
            print("temporaryLessons after tapping save button on MonthLessonsViewController\(temporaryLessons)")
        
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        savingConfirmation()
    }
    
    func checkIfScheduledLessonsAdded() {
        // Проверяем, пуст ли словарь temporaryLessons для текущего месяца
        if let lessonsForSelectedMonth = temporaryLessons[selectedMonth], !lessonsForSelectedMonth.isEmpty {
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
    
    
    @objc func addScheduledLessonsButtonTapped() {
        print("Adding scheduled lessons for \(selectedMonth) \(selectedYear)")
        // Выводим текущее состояние словаря temporaryLessons перед добавлением уроков
        print("temporaryLessons before adding scheduled lessons: \(temporaryLessons)")
        
        guard !selectedYear.isEmpty else {
            print("Selected year is empty")
            return
        }
        
        generateLessonsForMonth(selectedYear, month: selectedMonth, schedule: schedule)
        
        // Обновляем интерфейс
        tableView?.reloadData()
        
        // Проверяем, были ли добавлены уроки согласно расписанию
        checkIfScheduledLessonsAdded()
        
        changesMade = true
        
        // Выводим состояние словаря temporaryLessons после добавления уроков
        print("temporaryLessons after adding scheduled lessons: \(temporaryLessons)")
    }

    
    @objc func addLessonButtonTapped() {
        showDatePicker()
        changesMade = true
    }
    
    @objc func deleteAllLessons() {
        print("Deleting all lessons for \(selectedMonth) \(selectedYear)")
        
        // Удаляем все уроки для выбранного месяца из временного хранилища
        temporaryLessons[selectedMonth] = []
        // Обновляем интерфейс
        tableView?.reloadData()
        // Удаляем предыдущий обработчик действия, если он есть
        addScheduledLessonsButton.addTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
        
        // Показываем кнопку "Добавить уроки согласно расписанию"
        checkIfScheduledLessonsAdded()
        
        changesMade = true
        
        print("selectedMonth \(selectedMonth)")
        print("temporaryLessons после удаления: \(temporaryLessons)")
    }
    
    func showDatePicker() {
        let datePickerSheet = UIAlertController(title: "Lesson date", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        // Add date picker to action sheet
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        //        datePicker.locale = Locale(identifier: "ru_RU")
        datePickerSheet.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        
        // Add Cancel button
        datePickerSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add Done button
        datePickerSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            //            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: selectedDate)
            self.addLesson(date: dateString, attended: false)
        }))
        
        tableView?.reloadData()
        
        
        // Present action sheet
        present(datePickerSheet, animated: true, completion: nil)
    }
    
}


extension MonthLessonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temporaryLessons[selectedMonth]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle , reuseIdentifier: "LessonCell")
        
        // Safeguard: Ensure lessonsForSelectedMonth is not empty and index is within bounds
        guard let lessonsForSelectedMonth = temporaryLessons[selectedMonth], indexPath.row < lessonsForSelectedMonth.count else {
            fatalError("Lessons for selected month not found or index out of range")
        }
        
        // Получаем урок для текущего индекса
        let lesson = lessonsForSelectedMonth[indexPath.row]
        
        // Форматирование даты
        let dateFormatter = DateFormatter()
        //            dateFormatter.locale = Locale(identifier: "ru_RU")
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
        tableView.deselectRow(at: indexPath, animated: true) // Снимаем выделение ячейки
        
        guard var lessonsForSelectedMonth = temporaryLessons[selectedMonth] else {
            fatalError("Lessons for selected month not found")
        }
        
        let lesson = lessonsForSelectedMonth[indexPath.row]
        
        // Create the lesson detail view controller
        let lessonDetailVC = LessonDetailsViewController()
        lessonDetailVC.student = student
        lessonDetailVC.temporaryLessons = temporaryLessons
        lessonDetailVC.lesson = lesson
        lessonDetailVC.lessonIndex = indexPath.row // Pass the lesson index
        lessonDetailVC.delegate = self
        
        // Передаем временный массив домашнего задания
        lessonDetailVC.homeworksArray = lessonsForSelectedMonth.map { $0.homework ?? "" }
        
        // Переходим к контроллеру с уроками выбранного месяца
        navigationController?.pushViewController(lessonDetailVC, animated: true)
        
        //        changesMade = true
        
        // Обновляем значение урока в массиве для выбранного месяца
        lessonsForSelectedMonth[indexPath.row] = lesson
        
        // Обновляем словарь уроков для выбранного месяца
        temporaryLessons[selectedMonth] = lessonsForSelectedMonth
        
        // Обновляем ячейку, чтобы показать галочку
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension Date {
    func weekday(using calendar: Calendar = Calendar(identifier: .gregorian)) -> String {
        let weekdayIndex = calendar.component(.weekday, from: self)
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.shortWeekdaySymbols[weekdayIndex - 1]
    }
}


extension MonthLessonsViewController {
    
    // MARK: - Lesson Management
    
    func addLesson(date: String, attended: Bool) {
        print("Adding lesson for date: \(date)")
        let lesson = Lesson(date: date, attended: attended)
        
        // Получаем массив уроков для выбранного месяца из временного массива
        var lessonsForSelectedMonth = temporaryLessons[selectedMonth] ?? []
        
        // Добавляем новый урок
        lessonsForSelectedMonth.append(lesson)
        
        // Обновляем словарь уроков для выбранного месяца во временном массиве
        temporaryLessons[selectedMonth] = lessonsForSelectedMonth
        
        // Update the UI
        updateUI()
    }

    func loadLessonsForSelectedMonth() {
        // Инициализируем временные уроки для выбранного месяца
        if let lessonsForCurrentMonth = student?.lessons[selectedMonth] {
            temporaryLessons[selectedMonth] = lessonsForCurrentMonth
        } else {
            temporaryLessons[selectedMonth] = []
        }
        
        // Перезагружаем таблицу для отображения уроков
        tableView?.reloadData()
        
        print("temporaryLessons after loadLessonsForSelectedMonth on MonthLessonsViewController\(temporaryLessons)")
    }
    
    func editLesson(at index: Int, newDate: String, newAttended: Bool) {
        guard let student = student else {
            print("Error: Student is nil")
            return
        }
        
        // Проверяем, есть ли выбранный месяц в словаре уроков
        guard let lessonsForSelectedMonth = student.lessons[selectedMonth] else {
            print("No lessons found for selected month")
            return
        }
        
        // Проверяем, находится ли индекс в пределах массива уроков для выбранного месяца
        guard lessonsForSelectedMonth.indices.contains(index) else {
            print("Invalid index")
            return
        }
        
        // Создаем обновленный урок
        let updatedLesson = Lesson(date: newDate, attended: newAttended)
        
        // Обновляем урок в массиве для выбранного месяца
        student.lessons[selectedMonth]?[index] = updatedLesson
        
        // Обновляем интерфейс
        updateUI()
    }
    
    func deleteLesson(at index: Int) {
        guard let student = student else {
            print("Error: Student is nil")
            return
        }
        
        // Проверяем, есть ли выбранный месяц в словаре уроков
        guard let lessonsForSelectedMonth = student.lessons[selectedMonth] else {
            print("No lessons found for selected month")
            return
        }
        
        // Проверяем, находится ли индекс в пределах массива уроков для выбранного месяца
        guard lessonsForSelectedMonth.indices.contains(index) else {
            print("Invalid index")
            return
        }
        
        // Удаляем урок из массива для выбранного месяца
        student.lessons[selectedMonth]?.remove(at: index)
        
        // Обновляем интерфейс
        updateUI()
    }
    
    // MARK: - UI Update
    
    func updateUI() {
        guard let lessonTableView = self.tableView else { return }
        lessonTableView.reloadData()
    }
}

extension MonthLessonsViewController {
    func generateLessonsForMonth(_ year: String, month: String, schedule: [String]) {
        print("Generating lessons for month: \(month), year: \(year)")
        print("Schedule: \(schedule)")
        
        let calendar = Calendar.current
        guard let monthNumber = monthDictionary[month] else {
            print("Failed to get month number for \(month)")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if temporaryLessons[month] == nil {
            temporaryLessons[month] = []
        }
        
        guard let date = dateFormatter.date(from: "01.\(monthNumber).\(year)") else {
            print("Failed to convert month to date with string: 01.\(monthNumber).\(year)")
            return
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            print("Failed to get range of days in month for date: \(date)")
            return
        }
        
        for day in range.lowerBound..<range.upperBound {
            let dateString = String(format: "%02d.%02d.%@", day, Int(monthNumber)!, year)
            if let currentDate = dateFormatter.date(from: dateString) {
                let weekday = calendar.component(.weekday, from: currentDate)
                let weekdayString = dateFormatter.shortWeekdaySymbols[weekday - 1].lowercased()
                
                for scheduleEntry in schedule {
                    let components = scheduleEntry.components(separatedBy: " ")
                    let scheduleWeekday = components[0].lowercased()
                    if scheduleWeekday == weekdayString {
                        addLesson(date: dateString, attended: false)
                    }
                }
            } else {
                print("Failed to convert dateString to date: \(dateString)")
            }
        }
    }
}
