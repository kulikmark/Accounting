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
    
    var student: Student?
    var editMode: EditMode
    weak var delegate: StudentCardDelegate?
    
    // Add a segmented control for student type
    let studentTypeSegmentedControl: UISegmentedControl = {
        let items = ["Schoolchild", "Adult"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    var monthsArray = [Month]()
    
    var selectedSchedules = [(weekday: String, time: String)]()
    var selectedImage: UIImage?
    
    let scrollView = UIScrollView()
    let studentNameTextField = UITextField()
    let studentNameLabel = UILabel()
    let parentNameTextField = UITextField()
    let parentNameLabel = UILabel()
    let phoneTextField = UITextField()
    let phoneLabel = UILabel()
    let lessonPriceLabel = UILabel()
    let lessonPriceTextField = UITextField()
    let currencyLabel = UILabel()
    let currencyTextField = UITextField()
    let scheduleTextField = UITextField()
    let scheduleLabel = UILabel()
    
    var imageButton = UIButton(type: .system)
    
    let imagePicker = UIImagePickerController()
    
    var lessonPriceValue: Double?
    var enteredPrice: Double?
    var enteredCurrency: String?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateScheduleTextField()
        
        // Повторно проверяем выбранный индекс и скрываем поля, если необходимо
        if studentTypeSegmentedControl.selectedSegmentIndex != 0 {
            parentNameLabel.isHidden = true
            parentNameTextField.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateScheduleTextField()
        self.title = editMode == .add ? "Add Student" : "Edit Student"
        //        // Заменяем кнопку "Back" на кастомную кнопку
        //        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        //        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        // Добавляем жест для скрытия клавиатуры при тапе вне текстовых полей
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapGesture)
        
        // Добавляем обработчик изменений в UISegmentedControl
            studentTypeSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        // Повторно проверяем выбранный индекс и скрываем поля, если необходимо
        if studentTypeSegmentedControl.selectedSegmentIndex != 0 {
            parentNameLabel.isHidden = true
            parentNameTextField.isHidden = true
        }
        
    }
    
    // Метод для обработки изменений в UISegmentedControl
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Проверяем выбранный индекс и скрываем или отображаем соответствующие поля
        switch sender.selectedSegmentIndex {
        case 0:
            parentNameLabel.isHidden = false
            parentNameTextField.isHidden = false
        case 1:
            parentNameLabel.isHidden = true
            parentNameTextField.isHidden = true
        default:
            break
        }
    }
    
    
    // Функция для скрытия клавиатуры при тапе вне текстовых полей
    @objc private func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    init(editMode: EditMode, delegate: StudentCardDelegate?) {
        self.editMode = editMode
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc internal func saveButtonTapped() {
        
        // Скрыть клавиатуру перед сохранением
        view.endEditing(true)
        
        if let existingStudent = student {
            saveStudent(existingStudent, mode: .edit)
        } else {
            saveStudent(nil, mode: .add)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        
    }
    
    private func saveStudent(_ existingStudent: Student?, mode: EditMode) {
        // Determine student ID, using existing ID if available, otherwise generate a new UUID
        let studentID = existingStudent?.id ?? UUID()
        
        // Student type
           let studentTypeIndex = studentTypeSegmentedControl.selectedSegmentIndex
           let studentType: StudentType = studentTypeIndex == 0 ? .schoolchild : .adult
           
           
        // Extract student name from text field, defaulting to nil if text field is empty
        guard let studentName = studentNameTextField.text, !studentName.isEmpty else {
            displayErrorAlert(message: "Student's name cannot be empty")
            return
        }
        
        // Extract Parent name from text field, defaulting to nil if text field is empty
        guard let parentName = parentNameTextField.text, !parentName.isEmpty || studentTypeIndex == 1 else {
            displayErrorAlert(message: "Parent's name cannot be empty for adult students")
            return
        }
        
        // Extract phone number from text field, defaulting to nil if text field is empty
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            displayErrorAlert(message: "Phone number cannot be empty")
            return
        }
        
        guard let lessonPriceText = lessonPriceTextField.text, !lessonPriceText.isEmpty else {
            displayErrorAlert(message: "Please enter a valid lesson price")
            return
        }
        
        // Convert the lesson price text to a Double, replacing commas with dots if necessary
        let formattedLessonPriceText = lessonPriceText.replacingOccurrences(of: ",", with: ".")
        guard let lessonPriceValue = Double(formattedLessonPriceText) else {
            displayErrorAlert(message: "Invalid lesson price")
            return
        }
        
        // Extract currency from currency text field, defaulting to nil if text field is empty
        guard let currency = currencyTextField.text, !currency.isEmpty else {
            displayErrorAlert(message: "Currency cannot be empty")
            return
        }
        
        let newLessonPrice = LessonPrice(price: lessonPriceValue, currency: currency)
        
        // Создание уникального `PaidMonth` с текущей ценой урока и валютой
        let month = Month(monthName: "", monthYear: ""/* месяц */, isPaid: true, lessonPrice: newLessonPrice, lessons: [])
           
           // Добавление нового `PaidMonth` к студенту
           var updatedMonths = existingStudent?.months ?? []
        updatedMonths.append(month)
        
        // Check if the selectedSchedules is empty and mode is add
        if selectedSchedules.isEmpty && self.editMode == .add {
            // Display an alert if there are no schedules selected
            displayErrorAlert(message: "You need to add a schedule")
        }
        
        // Check if mode is edit and both selectedSchedules and existing student's schedules are empty
        if self.editMode == .edit && selectedSchedules.isEmpty && (self.student?.schedule.isEmpty ?? true) {
            // Display an alert if there are no schedules selected and no existing schedules
            displayErrorAlert(message: "You need to add a schedule")
        }
        
        // Use selectedSchedules only in 'add' mode
        var updatedSchedule: [Schedule] = mode == .add ? selectedSchedules.map { Schedule(weekday: $0.weekday, time: $0.time) } : existingStudent?.schedule ?? []
        
        // Use selectedSchedules only in 'add' mode
//        var updatedPaidMonths = existingStudent?.paidMonths ?? []
        var updatedLessons = existingStudent?.lessons ?? []
        
        if mode == .edit {
            updatedSchedule += selectedSchedules.map { Schedule(weekday: $0.weekday, time: $0.time) }

            switch existingStudent {
            case .some(let student):
                updatedMonths = student.months
                updatedLessons = student.lessons
            case .none:
                break
            }
        }
        
        // Create an updated student object with the gathered information
        let updatedStudent = Student(
            id: studentID,
            name: studentName,
            parentName: parentName,
            phoneNumber: phoneNumber, 
            month: Month(monthName: "", monthYear: "", isPaid: false, lessonPrice: newLessonPrice, lessons: []),
            months: updatedMonths,
            lessons: updatedLessons,
            lessonPrice: newLessonPrice,
            schedule: updatedSchedule,
            type: studentType,
            image: selectedImage ?? existingStudent?.imageForCell
        )
        
        // Notify the delegate about the creation or update of the student, passing the updated student and selected image if available
        delegate?.didCreateStudent(updatedStudent, withImage: selectedImage)
    }
    
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension StudentCardViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case lessonPriceTextField:
            let currentText = textField.text ?? ""
            if currentText.contains(",") && string.contains(",") {
                return false
            }
            let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
        case studentNameTextField, parentNameTextField, currencyTextField:
            let allowedCharacters = CharacterSet.letters
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
        case phoneTextField:
            let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
                return false
            }
        default:
            break
        }
        
        return true
    }
}


