//
//  LessonDetailsViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 16.04.2024.
//

import UIKit
import SnapKit

class LessonDetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, SaveChangesHandling {
    
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    weak var delegate: DidUpdateStudentDelegate?
    
    var student: Student!
    var lesson: Lesson!
    
    var updatedlessonsForStudent: [Lesson] = []
    var homeworksArray = [String]()
    
    var changesMade = false
    
    var attendanceSwitch: UISwitch!
    var statusLabel: UILabel!
    var saveButton: UIButton!
    var paperclipButton = UIButton(type: .system)
    
    let homeworkTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Устанавливаем значение UISwitch равным значению lesson.attended
        attendanceSwitch.isOn = lesson.attended
        
        // Убедимся, что значение attendanceSwitch.isOn не изменяется вне метода viewDidLoad()
        print("Attendance Switch is initially on? \(attendanceSwitch.isOn)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lesson Details"
        
        // Заменяем кнопку "Back" на кастомную кнопку
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .white
        setupUI()
        setupObservers()
        setupTapGesture()
       
        // Set the text view with the current homework
        homeworkTextView.text = lesson.homework
        // Устанавливаем значение UISwitch равным значению lesson.attended
        attendanceSwitch.isOn = lesson.attended
    }
    
    @objc func saveButtonTapped() {
        changesMade = false
        
        guard let updatedHomework = homeworkTextView.text else {
            print("Error: Failed to get updated homework")
            return
        }
        
        // Обновляем состояние attended
        lesson.attended = attendanceSwitch.isOn
        lesson.homework = updatedHomework
        
        // Отправляем уведомление о обновлении урока
        NotificationCenter.default.post(name: .lessonUpdatedNotification, object: nil, userInfo: ["updatedLesson": lesson!])
        
        // Debug output
           print("Saved lesson details:")
           print("Attendance: \(attendanceSwitch.isOn ? "Present" : "Absent")")
           print("Homework: \(updatedHomework)")
        
        delegate?.didUpdateStudent(student)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        savingConfirmation()
    }
    
    @objc func attendanceSwitchValueChanged(_ sender: UISwitch) {
        
        // Сохраняем факт изменения состояния UISwitch
        changesMade = true
        
        // Обновляем статус урока при изменении значения переключателя
        lesson?.attended = sender.isOn
        
        // Обновляем текст статуса
        statusLabel.text = sender.isOn ? "Was present" : "Was absent"
        
        delegate?.didUpdateStudent(student)
        
        print("attendanceSwitchValueChanged tapped: \(attendanceSwitch.isOn)")
    }
}

// MARK: - Hiding keyboard methods

extension LessonDetailsViewController {
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: homeworkTextView)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textViewDidChange(_ notification: Notification) {
        changesMade = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Paper clip button: Photo Gallery methods

extension LessonDetailsViewController {
    
    @objc func paperclipButtonTapped() {
        let actionSheet = UIAlertController(title: "Add Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            insertImageIntoTextView(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func insertImageIntoTextView(image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        let imageString = NSAttributedString(attachment: attachment)
        homeworkTextView.textStorage.insert(imageString, at: homeworkTextView.selectedRange.location)
        
        delegate?.didUpdateStudent(student)
    }
}

// MARK: - shareHomework method

extension LessonDetailsViewController {
    @objc func shareHomework() {
        guard let homework = homeworkTextView.text else { return }
        let activityViewController = UIActivityViewController(activityItems: [homework], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        // Настройка для iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItems?.last
            popoverController.sourceView = self.view // для безопасности, хотя barButtonItem должно быть достаточно
        }
    }
}


// MARK: - Saving Confirmation methods

extension LessonDetailsViewController {
    
    func savingConfirmation() {
        // Проверяем, были ли внесены изменения
        if changesMade {
            let alertController = UIAlertController(title: "Save changes?", message: "There are unsaved changes. \n\n Are you sure you want to exit without saving?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.discardChanges()
            }
            alertController.addAction(cancelAction)
            
            let saveAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.saveButtonTapped()
            }
            alertController.addAction(saveAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func discardChanges() {
        // Добавим вывод на консоль для проверки вызова метода
        print("Метод discardChanges() вызван")
        
        // Сбрасываем флаг changesMade в false
        changesMade = false
        
        // Возвращаем UISwitch в исходное состояние
        attendanceSwitch.isOn = lesson.attended == false
        
        // Обновляем статус урока при изменении значения переключателя
        lesson?.attended = attendanceSwitch.isOn
        //        delegate?.didUpdateAttendance(forLessonIndex: lessonIndex, attended: attendanceSwitch.isOn)
        
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
}
