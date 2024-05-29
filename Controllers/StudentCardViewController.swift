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
    
    var paidMonths = [PaidMonth]()

    var selectedSchedules = [(weekday: String, time: String)]()
    var selectedImage: UIImage?
    
    let studentNameTextField = UITextField()
    let studentNameLabel = UILabel()
    let phoneTextField = UITextField()
    let phoneLabel = UILabel()
    let lessonPriceLabel = UITextField()
    let lessonPriceTextField = UITextField()
    let scheduleTextField = UITextField()
    let scheduleLabel = UILabel()
    
    var imageButton = UIButton(type: .system)
    
    let imagePicker = UIImagePickerController()
    
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
        
        let lessonPrice = lessonPriceTextField.text ?? ""
        
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
            lessonPrice: lessonPrice,
            lessons: [:],
            schedule: updatedSchedule,
            image: selectedImage ?? existingStudent?.imageForCell
        )
        
        // Notify the delegate about the creation or update of the student, passing the updated student and selected image if available
        delegate?.didCreateStudent(updatedStudent, withImage: selectedImage)
    }
}

