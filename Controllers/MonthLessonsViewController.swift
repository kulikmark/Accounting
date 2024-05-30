//
//  MonthLessonsViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 16.04.2024.
//

import UIKit
import SnapKit

protocol MonthLessonsDelegate: AnyObject {
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]])
}

class MonthLessonsViewController: UIViewController, UITableViewDelegate {
    
    weak var delegate: MonthLessonsDelegate?
    
    var temporaryLessons: [String: [Lesson]] = [:] // Список уроков для отображения
    
    var lessonsForStudent: [Lesson] = []
    
    var student: Student?
    var students = [Student]() // Массив объектов типа Student
    
    var selectedMonth: String = ""
    
    var selectedSchedules = [(weekday: String, time: String)]()
    
    // Добавим новое свойство для хранения расписания
    var schedule: [String] {
        var scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        scheduleStrings.sort() // Сортируем расписание по дням недели и времени
        return scheduleStrings
    }
    
    let addScheduledLessonsButton = UIButton(type: .system)
    let addLessonButton = UIButton(type: .system)
    
    var tableView: UITableView? // Создаем свойство tableView
    
    private let datePicker = UIDatePicker()
    
    // Словарь для соответствия названий месяцев и их числовых представлений
    let monthDictionary: [String: String] = [
        "Январь": "01",
        "Февраль": "02",
        "Март": "03",
        "Апрель": "04",
        "Май": "05",
        "Июнь": "06",
        "Июль": "07",
        "Август": "08",
        "Сентябрь": "09",
        "Октябрь": "10",
        "Ноябрь": "11",
        "Декабрь": "12"
    ]
    
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
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        checkIfScheduledLessonsAdded()
        
        loadLessonsForSelectedMonth()
        
        print("Массив уроков temporaryLessons после нажатия выбора месяц повторно: \(temporaryLessons)")
    }
    
    @objc func saveButtonTapped() {
        
        let lessonsMassive = temporaryLessons
        
        
        // Передаем нового ученика и выбранное изображение через делегата обратно в контроллер списка учеников
        delegate?.didUpdateStudentLessons(lessonsMassive)
        
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
        
        print("уроки после сохранения уроков \(lessonsMassive)")
    }
    
    func setupUI() {
        // Создаем таблицу для отображения уроков
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self // Добавляем настройку делегата
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LessonCell")
        view.addSubview(tableView)
        
        // Устанавливаем стиль ячейки, чтобы включить detailTextLabel
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // Добавляем таблицу на представление
        view.addSubview(tableView)
        
        // Присваиваем созданную таблицу свойству tableView
        self.tableView = tableView
        
        // Add Scheduled Lessons Button
        view.addSubview(addScheduledLessonsButton)
        addScheduledLessonsButton.snp.makeConstraints { make in
            //            make.bottom.equalTo(addScheduledLessonsButton.snp.top).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addScheduledLessonsButton.setTitle("Добавить уроки согласно расписанию", for: .normal)
        addScheduledLessonsButton.layer.cornerRadius = 10
        addScheduledLessonsButton.setTitleColor(.white, for: .normal)
        addScheduledLessonsButton.backgroundColor = .systemBlue
        addScheduledLessonsButton.addTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
        
        // Add Scheduled Lessons Button
        view.addSubview(addLessonButton)
        addLessonButton.snp.makeConstraints { make in
            make.top.equalTo(addScheduledLessonsButton.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addLessonButton.setTitle("Добавить урок", for: .normal)
        addLessonButton.layer.cornerRadius = 10
        addLessonButton.setTitleColor(.white, for: .normal)
        addLessonButton.backgroundColor = .systemBlue
        addLessonButton.addTarget(self, action: #selector(addLessonsButtonTapped), for: .touchUpInside)
    }
    
    func checkIfScheduledLessonsAdded() {
        // Если temporaryLessonsForNewStudent не пустой, скрываем кнопку и меняем её текст
        if !temporaryLessons.isEmpty {
            addScheduledLessonsButton.setTitle("Удалить все уроки", for: .normal)
            // Добавляем действие для кнопки при её нажатии после добавления уроков
            addScheduledLessonsButton.addTarget(self, action: #selector(deleteAllLessons), for: .touchUpInside)
        }
    }
    
    @objc func addScheduledLessonsButtonTapped() {
        
        if schedule == [] {
            let alertController = UIAlertController(title: "Добавьте расписание на предыдущем экране", message: nil, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
            
            present(alertController, animated: true)
        } else {
            
            generateLessonsForMonth(selectedMonth, schedule: schedule)
            
//            // Сохраняем сгенерированные уроки во временном хранилище
//            temporaryLessonsForNewStudent = temporaryLessons
            
            // Обновляем интерфейс
            tableView?.reloadData()
            
            // Проверяем, были ли добавлены уроки согласно расписанию
            checkIfScheduledLessonsAdded()
            
            print("Массив уроков temporaryLessonsForNewStudent после нажатия addScheduledLessonsButtonTapped: \(temporaryLessons)")
        }
       
    }
    
    
    @objc func addLessonsButtonTapped() {
        showDatePicker()
    }
    
    @objc func deleteAllLessons() {
        // Удаляем все уроки из временного хранилища
        temporaryLessons = [:]
        // Обновляем интерфейс
        tableView?.reloadData()
        // Удаляем предыдущий обработчик действия, если он есть
        addScheduledLessonsButton.addTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
        
        // Показываем кнопку "Добавить уроки согласно расписанию"
        checkIfScheduledLessonsAdded()
        
        addScheduledLessonsButton.setTitle("Добавить уроки согласно расписанию", for: .normal)
    }
    
    func showDatePicker() {
        let datePickerSheet = UIAlertController(title: "Дата урока", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        // Add date picker to action sheet
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        datePickerSheet.view.addSubview(datePicker)
        
        // Add Cancel button
        datePickerSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        // Add Done button
        datePickerSheet.addAction(UIAlertAction(title: "Готово", style: .default, handler: { _ in
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
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
        return temporaryLessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath)
            let cell = UITableViewCell(style: .subtitle , reuseIdentifier: "LessonCell")
    //        let lesson = temporaryLessons[indexPath.row]
            
            // Получаем уроки для выбранного месяца из временного массива
              guard let lessonsForSelectedMonth = temporaryLessons[selectedMonth] else {
                  fatalError("Lessons for selected month not found")
              }
              
              // Получаем урок для текущего индекса
              let lesson = lessonsForSelectedMonth[indexPath.row]
            
            // Форматирование даты
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
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
            cell.detailTextLabel?.text = lesson.attended ? "Присутствовал (\(weekdayString))" : "Отсутствовал (\(weekdayString))"
            
            // Устанавливаем или снимаем галочку в зависимости от состояния урока
            cell.accessoryType = lesson.attended ? .checkmark : .none
            
            
            return cell
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Снимаем выделение ячейки
        
        guard var lessonsForSelectedMonth = temporaryLessons[selectedMonth] else {
            fatalError("Lessons for selected month not found")
        }
        
        var lesson = lessonsForSelectedMonth[indexPath.row]
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            lesson.attended = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            lesson.attended = true
        }
        
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
        dateFormatter.locale = Locale(identifier: "ru_RU")
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
//        guard let student = student else {
//            print("Error: Student is nil")
//            return
//        }
//        
//        // Проверяем, есть ли уроки для выбранного месяца во временном массиве
//        if let lessonsForSelectedMonth = temporaryLessons[selectedMonth] {
//            // Если уроки уже добавлены для выбранного месяца, присваиваем их во временный словарь
//            temporaryLessons[selectedMonth] = lessonsForSelectedMonth
//        } else {
//            // Если уроки еще не добавлены для выбранного месяца, создаем пустой массив уроков для него
//            temporaryLessons[selectedMonth] = []
//        }
//        
//        // Перезагружаем таблицу для отображения уроков
//        tableView?.reloadData()
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
    func generateLessonsForMonth(_ month: String, schedule: [String]) {
        print("Generating lessons for month: \(month)")
        print("Schedule: \(schedule)")
        
        let calendar = Calendar.current
        guard let monthNumber = monthDictionary[month] else {
            print("Failed to get month number for \(month)")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yyyy" // Измененный формат даты
        
        temporaryLessons.removeAll()
        
        guard let date = dateFormatter.date(from: "01.\(monthNumber).2024") else { // Измененный формат даты
            print("Failed to convert month to date.")
            return
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            print("Failed to get range of days in month.")
            return
        }
        
        for day in range.lowerBound..<range.upperBound {
            let dateString = "\(day).\(monthNumber).2024" // Измененный формат даты
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
