////
////  ViewController.swift
////  Accounting
////
////  Created by Марк Кулик on 13.04.2024.
////
//
//import UIKit
//import SnapKit
//
//// MARK: - StudentDetailDelegate
//
//protocol StudentDetailDelegate: AnyObject {
//    func didEditStudent(_ updatedStudent: Student, withImage: UIImage?)
//}
//
//// MARK: - StudentDetailViewController
//
//class StudentDetailViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    weak var delegate: StudentDetailDelegate?
//    
//    var student: Student?
//
//    var paidMonths = [PaidMonth]()
//   
//    var selectedImage: UIImage?
//    
//    let studentNameLabel = UILabel()
//    let studentNameTextField = UITextField()
//    let phoneLabel = UILabel()
//    let phoneTextField = UITextField()
//
//    let scheduleLabel = UILabel()
//    let scheduleTextField = UITextField()
//    let paidMonthsLabel = UILabel()
//    let paidMonthsTableView = UITableView()
//    
//    let imageButton = UIButton(type: .system)
//    let addPaidMonthButton = UIButton(type: .system)
//    
//    let imagePicker = UIImagePickerController()
//    
//    var selectedSchedules = [(weekday: String, time: String)]()
//    
//    var lessonsForStudent: [String: [Lesson]] = [:]
//    
//    // MARK: - View Lifecycle
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        paidMonthsTableView.separatorStyle = .singleLine
//        paidMonthsTableView.separatorColor = UIColor.lightGray // Установите желаемый цвет разделителя
//        paidMonthsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        
//        // Выполните операции с UITableView здесь
//        paidMonthsTableView.reloadData()
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        updateUI()
//        view.backgroundColor = .white
//        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonTapped))
//        navigationItem.rightBarButtonItem = closeButton
//        
//        if let studentImage = student?.imageForCell {
//            imageButton.setImage(studentImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        
//        paidMonthsTableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
//    }
//    // MARK: - Actions
//    
//    @objc func closeButtonTapped() {
//        
//        // Проверяем, что у студента есть ID
//        guard let studentID = student?.id else { return }
//        
//        // Проверяем, есть ли выбранное изображение
//        if let image = selectedImage {
//            // Если есть, устанавливаем его в качестве изображения кнопки
//            imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        
//        // Обновляем состояние isPaid в массиве paidMonths на основе текущего состояния UISwitch
//        for (index, cell) in paidMonthsTableView.visibleCells.enumerated() {
//            if let paidMonthCell = cell as? PaidMonthCell {
//                paidMonths[index].isPaid = paidMonthCell.switchControl.isOn
//            }
//        }
//        
//        // Получаем новые значения из текстовых полей
//        let updatedStudent = Student(
//            id: studentID,
//            name: studentNameTextField.text ?? "",
//            phoneNumber: phoneTextField.text ?? "",
//            paidMonths: paidMonths,
//            lessons: lessonsForStudent,
//            
//            schedule: student?.schedule ?? [],
//            image: selectedImage ?? student?.imageForCell
//        )
//        
//        // Передаем обновленного ученика через делегат
//        delegate?.didEditStudent(updatedStudent, withImage: selectedImage)
//        
//        // Возвращаемся на предыдущий экран
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc func selectImage() {
//        imagePicker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            imagePicker.sourceType = .photoLibrary
//            present(imagePicker, animated: true, completion: nil)
//            //            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        } else {
//            // Обработка ситуации, когда фотогалерея недоступна
//            print("Фотогалерея недоступна")
//        }
//    }
//    
//    @objc func addPaidMonthButtonTapped() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//        
//        for month in ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"] {
//            alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
//                self?.addPaidMonth(month)
//                
//                // Добавим также консольный вывод для отладки
//                print("Selected month: \(month)")
//            }))
//        }
//        
//        present(alertController, animated: true)
//    }
//    
//    // MARK: - Helper Methods
//    
//    func addPaidMonth(_ month: String) {
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
//    }
//    
//     func updateUI() {
//        
//        // Устанавливаем текст в текстовые поля
//        studentNameTextField.text = student?.name
//        phoneTextField.text = student?.phoneNumber
//        // Формируем строку расписания из массива выбранных расписаний
//        let scheduleString = student?.schedule.map { "\($0.weekday) \($0.time)" }.joined(separator: ", ")
//          
//            scheduleTextField.text = scheduleString
//        
//        paidMonthsTableView.reloadData()
//        
//        // Устанавливаем автоматическое уменьшение размера шрифта для scheduleLabel
//        scheduleTextField.adjustsFontSizeToFitWidth = true
//        //        scheduleTextField.minimumScaleFactor = 0.5
//    }
//}
//
//extension StudentDetailViewController {
//   
//    // MARK: - UI Setup
//    
//    func setupUI() {
//        
//        view.backgroundColor = .white
//        
//        // Add Image Button
//        view.addSubview(imageButton)
//        imageButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(250)
//        }
//        imageButton.setTitle("Добавить фото", for: .normal)
//        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
//        imageButton.layer.cornerRadius = 125
//        imageButton.layer.borderWidth = 1
//        imageButton.layer.borderColor = UIColor.blue.cgColor
//        imageButton.clipsToBounds = true
//        //        imageButton.contentMode = .center
//        
//        // Student Name
//        view.addSubview(studentNameTextField)
//        studentNameTextField.snp.makeConstraints { make in
//            make.top.equalTo(imageButton.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        studentNameTextField.borderStyle = .roundedRect
//        studentNameTextField.placeholder = "Введите Имя"
//        
//        // Phone Number
//        view.addSubview(phoneTextField)
//        phoneTextField.snp.makeConstraints { make in
//            make.top.equalTo(studentNameTextField.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        phoneTextField.borderStyle = .roundedRect
//        phoneTextField.placeholder = "Введите номер телефона"
//        
//        // Schedule
//        view.addSubview(scheduleTextField)
//        scheduleTextField.snp.makeConstraints { make in
//            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        scheduleTextField.borderStyle = .roundedRect
//        scheduleTextField.placeholder = "Выберите дни недели и время"
//        scheduleTextField.isUserInteractionEnabled = true // Делаем текстовое поле доступным для взаимодействия
//        scheduleTextField.adjustsFontSizeToFitWidth = true
//        
//        // Добавляем жест тапа для отображения контроллера выбора
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSchedule))
//        scheduleTextField.addGestureRecognizer(tapGesture)
//        
//        // Paid Months Label
//        view.addSubview(paidMonthsLabel)
//        paidMonthsLabel.snp.makeConstraints { make in
//            make.top.equalTo(scheduleTextField.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        paidMonthsLabel.text = "Оплаченные месяцы:"
//        
//        // Paid Months Table
//        view.addSubview(paidMonthsTableView)
//        paidMonthsTableView.snp.makeConstraints { make in
//            make.top.equalTo(paidMonthsLabel.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
//        }
//        
//        // Add Paid Month Button
//        view.addSubview(addPaidMonthButton)
//        addPaidMonthButton.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//            make.height.equalTo(44)
//        }
//        addPaidMonthButton.setTitle("Добавить месяц", for: .normal)
//        addPaidMonthButton.layer.cornerRadius = 10
//        addPaidMonthButton.setTitleColor(.white, for: .normal)
//        addPaidMonthButton.backgroundColor = .systemBlue
//        addPaidMonthButton.addTarget(self, action: #selector(addPaidMonthButtonTapped), for: .touchUpInside)
//        
//        // Настройка таблицы оплаченных месяцев
//        paidMonthsTableView.dataSource = self
//        paidMonthsTableView.delegate = self
//        paidMonthsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaidMonthCell")
//        
//    }
//}
//



//STUDENTCARVC

//
//  StudentAddingViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 19.04.2024.
//

//import UIKit
//import SnapKit
//
//// MARK: - StudentDetailDelegate
//
//protocol StudentCardDelegate: AnyObject {
//    func didCreateStudent(_ existingStudent: Student, withImage: UIImage?)
//}
//
//enum EditMode {
//    case add
//    case edit
//}
//
//// MARK: - StudentDetailViewController
//
//class StudentCardViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    weak var delegate: StudentCardDelegate?
//    
//    var student: Student?
//    var students = [Student]() // Массив объектов типа Student
//    
//    var paidMonths = [PaidMonth]()
//    var schedules = [Schedule]()
//    var selectedSchedules = [(weekday: String, time: String)]()
//    var selectedImage: UIImage?
//    
//    let studentNameTextField = UITextField()
//    let phoneTextField = UITextField()
//    let scheduleTextField = UITextField()
//    let paidMonthsLabel = UILabel()
//    let paidMonthsTableView = UITableView()
//    
//    var imageButton = UIButton(type: .system)
//    let addPaidMonthButton = UIButton(type: .system)
//    
//    let imagePicker = UIImagePickerController()
//    
//    var lessonsForStudent: [String: [Lesson]] = [:]
//    
//    var editMode: EditMode // Добавляем свойство для хранения текущего режима
//    
//    
//    // MARK: - View Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupUI()
//        
//        view.backgroundColor = .white
//        
//        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
//        navigationItem.rightBarButtonItem = saveButton
//        
//        paidMonthsTableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
//        
//        // Выводим текущее содержимое массива перед обновлением
//           printSelectedSchedules()
//           
//        if let studentSchedule = student?.schedule {
//              // Очищаем массив selectedSchedules перед добавлением существующего расписания
//              selectedSchedules.removeAll()
//              selectedSchedules.append(contentsOf: studentSchedule.map { (weekday: $0.weekday, time: $0.time) })
//          }
//           
//           // Выводим содержимое массива после обновления
//           printUpdatedSelectedSchedules()
//        
//        updateScheduleTextField()
//      
//        print("student?.schedule \(String(describing: student?.schedule))")
//    }
//    
//    // Отладочный метод для вывода содержимого массива selectedSchedules
//    func printSelectedSchedules() {
//        print("Текущее содержимое массива selectedSchedules:")
//        for schedule in selectedSchedules {
//            print("\(schedule.weekday) \(schedule.time)")
//        }
//    }
//
//    // Отладочный метод для вывода содержимого массива selectedSchedules после обновления
//    func printUpdatedSelectedSchedules() {
//        print("Содержимое массива selectedSchedules после обновления:")
//        for schedule in selectedSchedules {
//            print("\(schedule.weekday) \(schedule.time)")
//        }
//    }
//    
//    init(editMode: EditMode, delegate: StudentCardDelegate?) {
//           self.editMode = editMode
//           super.init(nibName: nil, bundle: nil)
//           self.delegate = delegate
//       }
//       
//       required init?(coder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }
//
//    
//    // MARK: - Actions
//    
//    @objc private func saveButtonTapped() {
//        
//        if let existingStudent = student { // Если передан существующий ученик
//            // Обновляем существующего ученика
//            updateExistingStudent(existingStudent)
//        } else {
//            // Создаем нового ученика
//            createNewStudent()
//        }
//        
//        // Возвращаемся на предыдущий экран
//        navigationController?.popViewController(animated: true)
//    }
//    
//    private func createNewStudent() {
//        // Создание нового ученика
//        let studentID = UUID() // Создаем новый UUID
//        let studentName = studentNameTextField.text ?? ""
//        let phoneNumber = phoneTextField.text ?? ""
//        
//        // Создаем массив расписаний на основе выбранных дней и времени
//        for selectedSchedule in selectedSchedules {
//            let schedule = Schedule(weekday: selectedSchedule.weekday, time: selectedSchedule.time)
//            schedules.append(schedule)
//        }
//        let lessons = lessonsForStudent
//        let newStudent = Student(id: studentID, name: studentName, phoneNumber: phoneNumber, paidMonths: paidMonths, lessons: lessons, schedule: schedules, image: selectedImage)
//        
//        // Обновляем состояние isPaid в массиве paidMonths на основе текущего состояния UISwitch
//        for (index, cell) in paidMonthsTableView.visibleCells.enumerated() {
//            if let paidMonthCell = cell as? PaidMonthCell {
//                paidMonths[index].isPaid = paidMonthCell.switchControl.isOn
//            }
//        }
//        
//        print("Создание нового ученика:")
//        print("id: \(studentID)")
//        print("Имя: \(studentName)")
//        print("Номер телефона: \(phoneNumber)")
//        print("Расписание: \(schedules)")
//        
//        // Передаем нового ученика и выбранное изображение через делегата обратно в контроллер списка учеников
//        delegate?.didCreateStudent(newStudent, withImage: selectedImage)
//    }
//    private func updateExistingStudent(_ existingStudent: Student) {
//        // Обновление существующего ученика
//        let existingStudent = Student(
//            id: existingStudent.id,
//            name: studentNameTextField.text ?? "",
//            phoneNumber: phoneTextField.text ?? "",
//            paidMonths: paidMonths,
//            lessons: lessonsForStudent,
//            schedule: existingStudent.schedule, // Используем существующее расписание
//            image: selectedImage ?? existingStudent.imageForCell // Используем существующее изображение, если новое не выбрано
//        )
//        
//        print("Обновление существующего ученика:")
//        print("Имя: \(studentNameTextField.text ?? "")")
//        print("Номер телефона: \(phoneTextField.text ?? "")")
//        print("Расписание: \(existingStudent.schedule)")
//        
//        // Обновляем ученика через делегата
//        delegate?.didCreateStudent(existingStudent, withImage: selectedImage)
//    }
//    
//    
//    @objc func selectImage() {
//        imagePicker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            imagePicker.sourceType = .photoLibrary
//            present(imagePicker, animated: true, completion: nil)
//            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        } else {
//            // Обработка ситуации, когда фотогалерея недоступна
//            print("Фотогалерея недоступна")
//        }
//    }
//}
//
//extension StudentCardViewController {
//    
//    // MARK: - UI Setup
//    
//    func setupUI() {
//        
//        view.backgroundColor = .white
//        
//        // Add Image Button
//        view.addSubview(imageButton)
//        imageButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(250)
//        }
//        imageButton.setTitle("Добавить фото", for: .normal)
//        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
//        imageButton.layer.cornerRadius = 125
//        imageButton.layer.borderWidth = 1
//        imageButton.layer.borderColor = UIColor.blue.cgColor
//        imageButton.clipsToBounds = true
//        
//        switch (selectedImage, student?.imageForCell) {
//        case (let selectedImageName?, _):
//            imageButton.setImage(selectedImageName.withRenderingMode(.alwaysOriginal), for: .normal)
//        case (_, let studentImageName?):
//            imageButton.setImage(studentImageName.withRenderingMode(.alwaysOriginal), for: .normal)
//        default:
//            // Если и selectedImage, и student?.imageForCell равны nil, устанавливаем изображение по умолчанию
//            imageButton.setImage(UIImage(named: ""), for: .normal)
//        }
//        
//        // Student Name
//        view.addSubview(studentNameTextField)
//        studentNameTextField.snp.makeConstraints { make in
//            make.top.equalTo(imageButton.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        studentNameTextField.borderStyle = .roundedRect
//        studentNameTextField.placeholder = "Введите Имя"
//        
//        studentNameTextField.text = student?.name ?? ""
//        
//        // Phone Number
//        view.addSubview(phoneTextField)
//        phoneTextField.snp.makeConstraints { make in
//            make.top.equalTo(studentNameTextField.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        phoneTextField.borderStyle = .roundedRect
//        phoneTextField.placeholder = "Введите номер телефона"
//        
//        phoneTextField.text = student?.phoneNumber ?? ""
//        
//        // Schedule
//        view.addSubview(scheduleTextField)
//        scheduleTextField.snp.makeConstraints { make in
//            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
//        scheduleTextField.borderStyle = .roundedRect
//        scheduleTextField.placeholder = "Выберите дни недели и время"
//        scheduleTextField.isUserInteractionEnabled = true // Делаем текстовое поле доступным для взаимодействия
//        scheduleTextField.adjustsFontSizeToFitWidth = true
//        scheduleTextField.minimumFontSize = 10
//        
//        // Добавляем жест тапа для отображения контроллера выбора
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSchedule))
//        scheduleTextField.addGestureRecognizer(tapGesture)
//    }
//}
//
//
//
//// MARK: - imagePickerController
//
//extension StudentCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[.originalImage] as? UIImage {
//            selectedImage = pickedImage
//            selectedImage = pickedImage.squareImage() // Обрезаем изображение до квадратного формата
//            
//            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//// MARK: - UIImage Extension
//
//extension UIImage {
//    func squareImage() -> UIImage? {
//        let originalWidth = self.size.width
//        let originalHeight = self.size.height
//        
//        let smallerSide = min(originalWidth, originalHeight)
//        let cropRect = CGRect(x: (originalWidth - smallerSide) / 2, y: (originalHeight - smallerSide) / 2, width: smallerSide, height: smallerSide)
//        
//        if let croppedImage = self.cgImage?.cropping(to: cropRect) {
//            return UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation)
//        }
//        
//        return nil
//    }
//}
//
//extension StudentCardViewController {
//    
//    // MARK: - Actions
//    
//    @objc func selectSchedule() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let addScheduleAction = UIAlertAction(title: "Добавить расписание", style: .default) { [weak self] _ in
//            self?.showWeekdaysPicker()
//        }
//        actionSheet.addAction(addScheduleAction)
//        
//        if !selectedSchedules.isEmpty {
//            let deleteAction = UIAlertAction(title: "Удалить расписание", style: .destructive) { [weak self] _ in
//                self?.showDeleteScheduleAlert()
//            }
//            actionSheet.addAction(deleteAction)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        actionSheet.addAction(cancelAction)
//        
//        present(actionSheet, animated: true, completion: nil)
//        
//        //        existingSchedules = scheduleTextField.text?.components(separatedBy: ", ") ?? []
//        
//        actionSheet.view.snp.makeConstraints { make in
//            make.width.equalTo(400)
//            
//        }
//    }
//    
//    func showWeekdaysPicker() {
//        let weekdaysPickerController = UIAlertController(title: "Выберите день недели", message: nil, preferredStyle: .actionSheet)
//        
//        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
//        
//        for weekday in weekdays {
//            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
//                self?.showTimesPicker(for: weekday)
//            }
//            weekdaysPickerController.addAction(action)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        weekdaysPickerController.addAction(cancelAction)
//        
//        present(weekdaysPickerController, animated: true, completion: nil)
//        
//        weekdaysPickerController.view.snp.makeConstraints { make in
//            make.width.equalTo(400)
//            make.height.equalTo(300)
//            
//        }
//    }
//    
//    func showTimesPicker(for weekday: String) {
//        // Создаем экземпляр UIDatePicker с типом .time
//        let timePicker = UIDatePicker()
//        timePicker.datePickerMode = .time
//        timePicker.preferredDatePickerStyle = .wheels
//        
//        // Установим начальное время, например, 12:00
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.hour = 12
//        components.minute = 0
//        if let initialDate = calendar.date(from: components) {
//            timePicker.setDate(initialDate, animated: false)
//        }
//        
//        // Создаем UIAlertController
//        let timesPickerController = UIAlertController(title: "Выберите время для \(weekday)", message: "", preferredStyle: .actionSheet)
//        
//        // Добавляем UIDatePicker в UIAlertController
//        timesPickerController.view.addSubview(timePicker)
//        
//        // Создаем действия для выбора времени и отмены
//        let selectAction = UIAlertAction(title: "Выбрать", style: .default) { [weak self] _ in
//            guard let self = self else { return }
//            let selectedTime = self.formatTime(timePicker.date)
//            
//            //                    self.addSchedule(weekday, selectedTime) // Добавляем новое расписание
//            let newSchedule = (weekday: weekday, time: selectedTime)
//            self.selectedSchedules.append(newSchedule)
//            self.updateScheduleTextField()
//            
//            print("self.selectedSchedules.append(newSchedule) \(newSchedule)")
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        
//        // Добавляем действия в UIAlertController
//        timesPickerController.addAction(selectAction)
//        timesPickerController.addAction(cancelAction)
//        
//        // Показываем UIAlertController
//        present(timesPickerController, animated: true, completion: nil)
//        
//        timesPickerController.view.snp.makeConstraints { make in
//            make.width.equalTo(400)
//            make.height.equalTo(300)
//        }
//        
//        timePicker.snp.makeConstraints { make in
//            make.height.equalTo(160)
//            make.top.equalTo(timesPickerController.view.snp.top).offset(30)
//            make.leading.equalTo(timesPickerController.view.snp.leading)
//            make.trailing.equalTo(timesPickerController.view.snp.trailing)
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    // Обновление текстового поля с расписанием
//    func updateScheduleTextField() {
//        // Очищаем содержимое текстового поля перед обновлением
//        scheduleTextField.text = nil
//        
//        let studentScheduleStrings = student?.schedule.map { "\($0.weekday) \($0.time)" } ?? []
//        let selectedScheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
//        let allScheduleStrings = studentScheduleStrings + selectedScheduleStrings
//        let scheduleText = allScheduleStrings.joined(separator: ", ")
//        scheduleTextField.text = scheduleText
//    }
//    
//    func showDeleteScheduleAlert() {
//        let alert = UIAlertController(title: "Выберите день недели и время для удаления", message: nil, preferredStyle: .actionSheet)
//        
//        for schedule in selectedSchedules {
//            let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
//                self?.removeSchedule(schedule.weekday)
//            }
//            alert.addAction(action)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    func removeSchedule(_ schedule: String) {
//        if let index = selectedSchedules.firstIndex(where: { $0.weekday == schedule }) {
//            selectedSchedules.remove(at: index)
//            updateScheduleTextField()
//        }
//    }
//    
//    
//    // Метод для форматирования выбранного времени
//    func formatTime(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        return dateFormatter.string(from: date)
//    }
//}
//
