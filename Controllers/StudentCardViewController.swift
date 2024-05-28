//
//  StudentAddingViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 19.04.2024.
//

import UIKit
import SnapKit

// MARK: - StudentDetailDelegate

protocol StudentDelegate: AnyObject {
    func didCreateStudent(_ newStudent: Student, withImage: UIImage?)
}

// MARK: - StudentDetailViewController

class StudentCardViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: StudentDelegate?
    
    var student: Student?
    var students = [Student]() // Массив объектов типа Student
    
    var paidMonths = [PaidMonth]()
    var schedules = [Schedule]()
    var selectedImage: UIImage?
    
    let studentNameTextField = UITextField()
    let phoneTextField = UITextField()
    let scheduleTextField = UITextField()
    let paidMonthsLabel = UILabel()
    let paidMonthsTableView = UITableView()
    
    let imageButton = UIButton(type: .system)
    let addPaidMonthButton = UIButton(type: .system)
    
    let imagePicker = UIImagePickerController()
    
    var selectedSchedules = [(weekday: String, time: String)]()
    
    var lessonsForNewStudent: [String: [Lesson]] = [:]
    
//    // Добавим новое свойство для хранения расписания
//       var schedule: [String] {
//           var scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
//           scheduleStrings.sort() // Сортируем расписание по дням недели и времени
//           return scheduleStrings
//       }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        paidMonthsTableView.separatorStyle = .singleLine
        paidMonthsTableView.separatorColor = UIColor.lightGray // Установите желаемый цвет разделителя
        paidMonthsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Выполните операции с UITableView здесь
        paidMonthsTableView.reloadData()
        
        print("Массив уроков на экране StudentAddingViewController с экрана MonthLessonsViewController после его закрытия \(String(describing: lessonsForNewStudent))")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        
        view.backgroundColor = .white
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        paidMonthsTableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
       
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        
        // Обновляем состояние isPaid в массиве paidMonths на основе текущего состояния UISwitch
        for (index, cell) in paidMonthsTableView.visibleCells.enumerated() {
            if let paidMonthCell = cell as? PaidMonthCell {
                paidMonths[index].isPaid = paidMonthCell.switchControl.isOn
            }
        }
        
        // Получаем значения из текстовых полей, если они есть, или передаем nil
        let studentName = studentNameTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        // Создаем массив расписаний на основе выбранных дней и времени
        
        for selectedSchedule in selectedSchedules {
            let schedule = Schedule(weekday: selectedSchedule.weekday, time: selectedSchedule.time)
            schedules.append(schedule)
        }
        
        let lessons = lessonsForNewStudent
        
        // Создаем нового ученика с переданными данными и изображением
        let newStudent = Student(name: studentName, phoneNumber: phoneNumber, paidMonths: paidMonths, lessons: lessons, schedule: schedules, image: selectedImage)
        
        print("Новый студент:")
        print("Имя: \(newStudent.name)")
        print("Номер телефона: \(newStudent.phoneNumber)")
        print("Количество уроков: \(newStudent.lessons.count) \(newStudent.lessons)")

        
        // Передаем нового ученика и выбранное изображение через делегата обратно в контроллер списка учеников
        delegate?.didCreateStudent(newStudent, withImage: selectedImage)
        
        
//        print("Уроки lessonsForNewStudent после сохранить \(lessonsForNewStudent)")
        
//        printLessonsForNewStudent()
      
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
    
//    func printLessonsForNewStudent() {
//        print("Уроки для нового студента:")
//        for (index, lesson) in lessonsForNewStudent.enumerated() {
//            print("\(index + 1). \(lesson.date) - \(lesson.attended ? "Присутствовал" : "Отсутствовал")")
//        }
//    }
    
    @objc func selectImage() {
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            // Обработка ситуации, когда фотогалерея недоступна
            print("Фотогалерея недоступна")
        }
    }
    
    @objc func addPaidMonthButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        for month in ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"] {
            alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
                self?.addPaidMonth(month)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    
    // MARK: - Helper Methods
    
//    func addPaidMonth(_ month: String) {
//        
//        print("Adding month: \(month)")
//        let paidMonth = PaidMonth(month: month, isPaid: false) // По умолчанию месяц не оплачен
//        paidMonths.append(paidMonth)
//        
//        print("Месяц добавился в массив\(paidMonths)")
//        
//        // Вставляем новую строку в таблицу
//        let indexPath = IndexPath(row: paidMonths.count - 1, section: 0)
//        paidMonthsTableView.insertRows(at: [indexPath], with: .automatic)
//        
//        // Обновляем количество строк в секции
//        let sectionIndex = 0
//        let numberOfSections = paidMonthsTableView.numberOfSections
//        if numberOfSections > sectionIndex {
//            let numberOfRows = paidMonthsTableView.numberOfRows(inSection: sectionIndex)
//            if numberOfRows == 0 {
//                paidMonthsTableView.reloadData()
//            }
//        }
//        updateUI()
//    }
    
    func addPaidMonth(_ month: String) {
        print("Adding month: \(month)")
        let paidMonth = PaidMonth(month: month, isPaid: false)
        paidMonths.append(paidMonth)

        print("Месяц добавился в массив\(paidMonths)")

        // Проверяем, есть ли уроки для этого месяца в словаре lessonsForNewStudent
        if lessonsForNewStudent[month] == nil {
            // Если уроки для этого месяца еще не созданы, добавляем пустой массив уроков
            lessonsForNewStudent[month] = []
        }

        // Вставляем новую строку в таблицу и обновляем UI
        let indexPath = IndexPath(row: paidMonths.count - 1, section: 0)
        paidMonthsTableView.insertRows(at: [indexPath], with: .automatic)
        updateUI()
    }
    
    func updateUI() {
        paidMonthsTableView.reloadData()
    }
}

extension StudentCardViewController {
    
    // MARK: - UI Setup
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        // Add Image Button
        view.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
        imageButton.setTitle("Добавить фото", for: .normal)
        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        imageButton.layer.cornerRadius = 125
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = UIColor.blue.cgColor
        imageButton.clipsToBounds = true
        //        imageButton.contentMode = .center
        
        // Student Name
        view.addSubview(studentNameTextField)
        studentNameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        studentNameTextField.borderStyle = .roundedRect
        studentNameTextField.placeholder = "Введите Имя"
        
        // Phone Number
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(studentNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.placeholder = "Введите номер телефона"
        
        // Schedule
        view.addSubview(scheduleTextField)
        scheduleTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        scheduleTextField.borderStyle = .roundedRect
        scheduleTextField.placeholder = "Выберите дни недели и время"
        scheduleTextField.isUserInteractionEnabled = true // Делаем текстовое поле доступным для взаимодействия
        scheduleTextField.adjustsFontSizeToFitWidth = true
        scheduleTextField.minimumFontSize = 10
        // Добавляем жест тапа для отображения контроллера выбора
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSchedule))
        scheduleTextField.addGestureRecognizer(tapGesture)
        
        // Paid Months Label
        view.addSubview(paidMonthsLabel)
        paidMonthsLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        paidMonthsLabel.text = "Оплаченные месяцы:"
        
        // Paid Months Table
        view.addSubview(paidMonthsTableView)
        paidMonthsTableView.snp.makeConstraints { make in
            make.top.equalTo(paidMonthsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        
        // Add Paid Month Button
        view.addSubview(addPaidMonthButton)
        addPaidMonthButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addPaidMonthButton.setTitle("Добавить месяц", for: .normal)
        addPaidMonthButton.layer.cornerRadius = 10
        addPaidMonthButton.setTitleColor(.white, for: .normal)
        addPaidMonthButton.backgroundColor = .systemBlue
        addPaidMonthButton.addTarget(self, action: #selector(addPaidMonthButtonTapped), for: .touchUpInside)
        
        // Настройка таблицы оплаченных месяцев
        paidMonthsTableView.dataSource = self
        paidMonthsTableView.delegate = self
        paidMonthsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
    }
}

extension StudentCardViewController: MonthLessonsDelegate {
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]]) {
        lessonsForNewStudent = lessons
    }
}


// MARK: - StudentAddingViewController

extension StudentCardViewController {
    
    // MARK: - Actions
    
    @objc func selectSchedule() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addScheduleAction = UIAlertAction(title: "Добавить расписание", style: .default) { [weak self] _ in
            self?.showWeekdaysPicker()
        }
        actionSheet.addAction(addScheduleAction)
        
        if !selectedSchedules.isEmpty {
            let deleteAction = UIAlertAction(title: "Удалить расписание", style: .destructive) { [weak self] _ in
                self?.showDeleteScheduleAlert()
            }
            actionSheet.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

     func showWeekdaysPicker() {
        let weekdaysPickerController = UIAlertController(title: "Выберите день недели", message: nil, preferredStyle: .actionSheet)
        
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        
        for weekday in weekdays {
            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
                self?.showTimesPicker(for: weekday)
            }
            weekdaysPickerController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        weekdaysPickerController.addAction(cancelAction)
        
        present(weekdaysPickerController, animated: true, completion: nil)
    }
    
    func showTimesPicker(for weekday: String) {
        // Создаем экземпляр UIDatePicker с типом .time
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        
        // Создаем UIAlertController
        let timesPickerController = UIAlertController(title: "Выберите время для \(weekday)", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        // Добавляем UIDatePicker в UIAlertController
        timesPickerController.view.addSubview(timePicker)
        
        // Создаем действия для выбора времени и отмены
        let selectAction = UIAlertAction(title: "Выбрать", style: .default) { [weak self] _ in
            let selectedTime = self?.formatTime(timePicker.date)
            self?.selectedSchedules.append((weekday: weekday, time: selectedTime ?? ""))
            self?.updateScheduleTextField()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        // Добавляем действия в UIAlertController
        timesPickerController.addAction(selectAction)
        timesPickerController.addAction(cancelAction)
        
        // Показываем UIAlertController
        present(timesPickerController, animated: true, completion: nil)
    }

    // MARK: - Helper Methods

     func updateScheduleTextField() {
        let scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        let scheduleString = scheduleStrings.joined(separator: ", ")
        scheduleTextField.text = scheduleString
    }
    
     func showDeleteScheduleAlert() {
        let alert = UIAlertController(title: "Выберите день недели и время для удаления", message: nil, preferredStyle: .actionSheet)
        
        for schedule in selectedSchedules {
            let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
                self?.removeSchedule(schedule)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

     func removeSchedule(_ schedule: (weekday: String, time: String)) {
        if let index = selectedSchedules.firstIndex(where: { $0 == schedule }) {
            selectedSchedules.remove(at: index)
            updateScheduleTextField()
        }
    }
    
    // Метод для форматирования выбранного времени
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

// MARK: - imagePickerController

extension StudentCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            selectedImage = pickedImage.squareImage() // Обрезаем изображение до квадратного формата
            
            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImage Extension

extension UIImage {
    func squareImage() -> UIImage? {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        let smallerSide = min(originalWidth, originalHeight)
        let cropRect = CGRect(x: (originalWidth - smallerSide) / 2, y: (originalHeight - smallerSide) / 2, width: smallerSide, height: smallerSide)
        
        if let croppedImage = self.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return nil
    }
}




// MARK: - StudentAddingViewController TableView

extension StudentCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paidMonths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath) as! PaidMonthCell
        
        let paidMonth = paidMonths[indexPath.row]
        cell.textLabel?.text = paidMonth.month
        cell.switchControl.isOn = paidMonth.isPaid // Установка состояния UISwitch
        
        // Обработка изменений состояния UISwitch
        cell.switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // Установка стиля выделения ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonth = paidMonths[indexPath.row].month
        
        // Получаем текущее значение isPaid для выбранного месяца
            let isMonthPaid = paidMonths[indexPath.row].isPaid
        
        if student == nil {
            // Создаем новый объект Student, передавая необходимые параметры
            student = Student(name: studentNameTextField.text ?? "", phoneNumber: phoneTextField.text ?? "", paidMonths: [PaidMonth(month: selectedMonth, isPaid: isMonthPaid)], lessons: [:], schedule: [], image: nil)
        }
        
        // Создаем новый контроллер для отображения уроков выбранного месяца
        let monthLessonsVC = MonthLessonsViewController()
        
        // Передаем объект Student в MonthLessonsViewController
        monthLessonsVC.student = student
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.selectedSchedules = selectedSchedules
        monthLessonsVC.temporaryLessons = lessonsForNewStudent
        monthLessonsVC.delegate = self
        
        print("Navigating to MonthLessonsViewController")
        
        // Переходим к контроллеру с уроками выбранного месяца
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
   }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           let alertController = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить этот месяц?", preferredStyle: .alert)
           
           let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
               self?.deleteMonth(at: indexPath)
           }
           alertController.addAction(deleteAction)
           
           present(alertController, animated: true, completion: nil)
       }
   }

   func deleteMonth(at indexPath: IndexPath) {
       paidMonths.remove(at: indexPath.row)
       paidMonthsTableView.deleteRows(at: [indexPath], with: .fade)
   }

    
    // MARK: - Switch Value Changed for PaidMonth
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? PaidMonthCell,
              let indexPath = paidMonthsTableView.indexPath(for: cell) else {
            return
        }
        
        // Обновляем состояние в массиве данных
        paidMonths[indexPath.row].isPaid = sender.isOn
        
        // Отладочный вывод
        print("Switch value changed at index \(indexPath.row). New value isPaid: \(sender.isOn)")
        
        // Обновляем отображение ячейки
        paidMonthsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

