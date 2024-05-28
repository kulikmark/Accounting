//
//  StudentAddingViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 19.04.2024.
//

import UIKit
import SnapKit
import Photos

// MARK: - StudentDetailDelegate

protocol StudentCardDelegate: AnyObject {
    func didCreateStudent(_ existingStudent: Student, withImage: UIImage?)
}

enum EditMode {
    case add
    case edit
}

// MARK: - StudentDetailViewController

class StudentCardViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: StudentCardDelegate?
    
    var student: Student?
//    var students = [Student]() // Массив объектов типа Student
    
    var paidMonths = [PaidMonth]()
//    var schedules = [Schedule]()
    var selectedSchedules = [(weekday: String, time: String)]()
    var selectedImage: UIImage?
    
    let studentNameTextField = UITextField()
    let studentNameLabel = UILabel()
    let phoneTextField = UITextField()
    let phoneLabel = UILabel()
    let scheduleTextField = UITextField()
    let scheduleLabel = UILabel()
    
    var imageButton = UIButton(type: .system)
    
    let imagePicker = UIImagePickerController()
    
//    var lessonsForStudent: [String: [Lesson]] = [:]
    
    var editMode: EditMode // Добавляем свойство для хранения текущего режима
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printCurrentEditMode()
        setupUI()
        // Добавляем вызов метода updateScheduleTextField() для обновления расписания при открытии в режиме редактирования
            updateScheduleTextField()
        
        view.backgroundColor = .white
        
//        self.navigationController?.navigationBar.topItem?.title = "Назад"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    init(editMode: EditMode, delegate: StudentCardDelegate?) {
           self.editMode = editMode
           super.init(nibName: nil, bundle: nil)
           self.delegate = delegate
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    // Отладочный метод для вывода текущего режима
        func printCurrentEditMode() {
            switch editMode {
            case .add:
                print("Текущий режим: Добавление ученика")
            case .edit:
                print("Текущий режим: Редактирование ученика")
            }
        }

    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        if let existingStudent = student {
            saveStudent(existingStudent, mode: .edit)
        } else {
            saveStudent(nil, mode: .add)
        }
        
        navigationController?.popViewController(animated: true)
    }

    private func saveStudent(_ existingStudent: Student?, mode: EditMode) {
        // Determine student ID, using existing ID if available, otherwise generate a new UUID
        let studentID = existingStudent?.id ?? UUID()
        
        // Extract student name from text field, defaulting to an empty string if text field is empty
        let studentName = studentNameTextField.text ?? ""
        
        // Extract phone number from text field, defaulting to an empty string if text field is empty
        let phoneNumber = phoneTextField.text ?? ""
        
        // Use selectedSchedules only in 'add' mode
        var updatedSchedule: [Schedule] = mode == .add ? selectedSchedules.map { Schedule(weekday: $0.weekday, time: $0.time) } : existingStudent?.schedule ?? []
        
        // Add selected schedules to the existing schedule only in 'edit' mode
        if mode == .edit {
            updatedSchedule += selectedSchedules.map { Schedule(weekday: $0.weekday, time: $0.time) }
        }
        
        // Create an updated student object with the gathered information
        let updatedStudent = Student(
            id: studentID,
            name: studentName,
            phoneNumber: phoneNumber,
            paidMonths: paidMonths,
            lessons: [:],
            schedule: updatedSchedule,
            image: selectedImage ?? existingStudent?.imageForCell
        )
        
        // Notify the delegate about the creation or update of the student, passing the updated student and selected image if available
        delegate?.didCreateStudent(updatedStudent, withImage: selectedImage)
    }

    @objc func selectImage() {
        imagePicker.delegate = self
        
        // Check if photo library is available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                // Access to photo library is authorized, open it
                openPhotoLibrary()
            case .notDetermined, .denied, .restricted:
                // User hasn't decided yet, request access
                requestPhotoLibraryAccess()
            case .limited:
                // User has limited access
                showLimitedAccessAlert()
            @unknown default:
                break
            }
        } else {
            // Photo library is not available, show error message
            showGalleryUnavailableAlert()
        }
    }

    func openPhotoLibrary() {
        // Open the photo library
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func requestPhotoLibraryAccess() {
        // Request access to the photo library
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if status == .authorized {
                    // User granted access, open the photo library
                    self.openPhotoLibrary()
                } else {
                    // User denied access or access is restricted
                    self.showPermissionDeniedAlert()
                }
            }
        }
    }

    func showPermissionDeniedAlert() {
        // Show alert when access to photo library is denied
        let alert = UIAlertController(title: "Access to Photo Library Denied", message: "You can enable access to the photo library in your device settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showLimitedAccessAlert() {
        // Show alert when access to photo library is limited
        let alert = UIAlertController(title: "Limited Access to Photo Library", message: "You can request additional permissions or grant access to specific resources in your device settings", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showGalleryUnavailableAlert() {
        // Show alert when photo library is unavailable
        let alert = UIAlertController(title: "Error", message: "Photo Library is unavailable", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            make.width.height.equalTo(200)
        }
        imageButton.setTitle("Adding photo", for: .normal)
        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        imageButton.layer.cornerRadius = 100
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = UIColor.systemBlue.cgColor
        imageButton.clipsToBounds = true
        
        switch (selectedImage, student?.imageForCell) {
        case (let selectedImageName?, _):
            imageButton.setImage(selectedImageName.withRenderingMode(.alwaysOriginal), for: .normal)
        case (_, let studentImageName?):
            imageButton.setImage(studentImageName.withRenderingMode(.alwaysOriginal), for: .normal)
        default:
           break
        }
        
        // Student Name Label
        view.addSubview(studentNameLabel)
        studentNameLabel.text = "Name"
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
        }
        studentNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Student Name TextField
        view.addSubview(studentNameTextField)
        studentNameTextField.snp.makeConstraints { make in
            make.top.equalTo(studentNameLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        studentNameTextField.borderStyle = .roundedRect
        studentNameTextField.placeholder = "Enter name"
        studentNameTextField.text = student?.name ?? ""
        
        // Phone Label
        view.addSubview(phoneLabel)
        phoneLabel.text = "Phone Number"
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(studentNameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Phone TextField
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.placeholder = "Enter phone number"
        phoneTextField.text = student?.phoneNumber ?? ""
        
        // Schedule Label
        view.addSubview(scheduleLabel)
        scheduleLabel.text = "Schedule"
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        scheduleLabel.font = UIFont.systemFont(ofSize: 14)

        // Schedule TextField
        view.addSubview(scheduleTextField)
        scheduleTextField.snp.makeConstraints { make in
            make.top.equalTo(scheduleLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        scheduleTextField.borderStyle = .roundedRect
        scheduleTextField.placeholder = "Select the days of the week and time"
        scheduleTextField.isUserInteractionEnabled = true // Делаем текстовое поле доступным для взаимодействия
        scheduleTextField.adjustsFontSizeToFitWidth = true
        scheduleTextField.minimumFontSize = 10
        
        // Добавляем жест тапа для отображения контроллера выбора
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSchedule))
        scheduleTextField.addGestureRecognizer(tapGesture)
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

extension StudentCardViewController {
    
    // MARK: - Actions
    
    @objc func selectSchedule() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addScheduleAction = UIAlertAction(title: "Add a schedule", style: .default) { [weak self] _ in
            self?.showWeekdaysPicker()
        }
        actionSheet.addAction(addScheduleAction)
        
        switch editMode {
        case .add:
           if !selectedSchedules.isEmpty {
                let deleteAction = UIAlertAction(title: "Delete the schedule", style: .destructive) { [weak self] _ in
                    self?.showDeleteScheduleAlert()
                }
                actionSheet.addAction(deleteAction)
            }
        
        case .edit:
            if !(student?.schedule.isEmpty ?? true) || !selectedSchedules.isEmpty {
                let deleteAction = UIAlertAction(title: "Delete the schedule", style: .destructive) { [weak self] _ in
                    self?.showDeleteScheduleAlert()
                }
                actionSheet.addAction(deleteAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
        actionSheet.view.snp.makeConstraints { make in
            make.width.equalTo(400)
        }
    }

    func showWeekdaysPicker() {
        let weekdaysPickerController = UIAlertController(title: "Choose a day of the week", message: nil, preferredStyle: .actionSheet)
        
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        
        for weekday in weekdays {
            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
                self?.showTimesPicker(for: weekday)
            }
            weekdaysPickerController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        weekdaysPickerController.addAction(cancelAction)
        
        present(weekdaysPickerController, animated: true, completion: nil)
        
        weekdaysPickerController.view.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
            
        }
    }
    
    func showTimesPicker(for weekday: String) {
        // Создаем экземпляр UIDatePicker с типом .time
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        // Установим начальное время, например, 12:00
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        if let initialDate = calendar.date(from: components) {
            timePicker.setDate(initialDate, animated: false)
        }
        
        // Создаем UIAlertController
        let timesPickerController = UIAlertController(title: "Choose a time for \(weekday)", message: "", preferredStyle: .actionSheet)
        
        // Добавляем UIDatePicker в UIAlertController
        timesPickerController.view.addSubview(timePicker)
        
        // Создаем действия для выбора времени и отмены
        let selectAction = UIAlertAction(title: "Choose", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedTime = self.formatTime(timePicker.date)
            let newSchedule = (weekday: weekday, time: selectedTime)
            self.selectedSchedules.append(newSchedule)
            self.updateScheduleTextField()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Добавляем действия в UIAlertController
        timesPickerController.addAction(selectAction)
        timesPickerController.addAction(cancelAction)
        
        // Показываем UIAlertController
        present(timesPickerController, animated: true, completion: nil)
        
        timesPickerController.view.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        
        timePicker.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.top.equalTo(timesPickerController.view.snp.top).offset(30)
            make.leading.equalTo(timesPickerController.view.snp.leading)
            make.trailing.equalTo(timesPickerController.view.snp.trailing)
        }
    }
    
    // MARK: - Helper Methods
    
    // Обновление текстового поля с расписанием
    func updateScheduleTextField() {
        var scheduleStrings = [String]()
        
        switch editMode {
        case .add:
            scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        case .edit:
            let selectedScheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
            let studentScheduleStrings = student?.schedule.map { "\($0.weekday) \($0.time)" } ?? []
            scheduleStrings = studentScheduleStrings + selectedScheduleStrings
        }
        
        let scheduleText = scheduleStrings.joined(separator: ", ")
        scheduleTextField.text = scheduleText
    }

    
    func showDeleteScheduleAlert() {
        let alert = UIAlertController(title: "Select the day of the week and the time to delete", message: nil, preferredStyle: .actionSheet)
        
        switch editMode {
        case .add:
            for schedule in selectedSchedules {
                let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
                    self?.removeSchedule(schedule.weekday, from: .add)
                }
                alert.addAction(action)
            }
        case .edit:
            // Преобразуем расписание ученика к формату [(weekday: String, time: String)]
            let studentSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
            
            // Объединяем выбранные пользователем расписания и расписание ученика
            let allSchedules = studentSchedules + selectedSchedules
            
            for schedule in allSchedules {
                let action = UIAlertAction(title: "\(schedule.0) \(schedule.1)", style: .default) { [weak self] _ in
                    self?.removeSchedule(schedule.0, from: .edit)
                }
                alert.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }


    func removeSchedule(_ schedule: String, from mode: EditMode) {
        switch mode {
        case .add:
            if let index = selectedSchedules.firstIndex(where: { $0.weekday == schedule }) {
                selectedSchedules.remove(at: index)
                updateScheduleTextField()
            }
        case .edit:
            if let index = selectedSchedules.firstIndex(where: { $0.weekday == schedule }) {
                selectedSchedules.remove(at: index)
                updateScheduleTextField()
            }
            if let index = student?.schedule.firstIndex(where: { $0.weekday == schedule }) {
                student?.schedule.remove(at: index)
                updateScheduleTextField()
            }
        }
    }

    // Метод для форматирования выбранного времени
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func printScheduleAvailability() {
        if let student = student {
            if student.schedule.isEmpty {
                print("У ученика нет расписания")
            } else {
                print("У ученика есть расписание:")
                for schedule in student.schedule {
                    print("\(schedule.weekday) \(schedule.time)")
                }
            }
        } else {
            print("Ученик не выбран")
        }
    }

    func printSelectedSchedules() {
        if selectedSchedules.isEmpty {
            print("Выбранных расписаний нет")
        } else {
            print("Выбранные расписания:")
            for schedule in selectedSchedules {
                print("\(schedule.weekday) \(schedule.time)")
            }
        }
    }
}
