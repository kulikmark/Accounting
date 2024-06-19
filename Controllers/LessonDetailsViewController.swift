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
    
    var photoImageViews: [UIImageView] = []
    
    var changesMade = false
    
    var enterHWLabel: UILabel!
    var clippedPhotosLabel: UILabel!
    var attendanceSwitch: UISwitch!
    var statusLabel: UILabel!
    var paperclipButton = UIButton(type: .system)
    var saveButton = UIButton(type: .system)
    
    
    let homeworkTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.systemGroupedBackground
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let photoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
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
        //        lesson.homework = updatedHomework
        lesson.homework = updatedHomework.isEmpty ? nil : updatedHomework
        
        // Отправляем уведомление о обновлении урока
        NotificationCenter.default.post(name: .lessonUpdatedNotification, object: nil, userInfo: ["updatedLesson": lesson!])
        print("Sending lesson update notification for lesson: \(lesson!)")
        
        // Debug output
        print ("Saved lesson details Attendance: \(attendanceSwitch.isOn ? "Present" : "Absent") Homework: \(updatedHomework)")
        
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
        statusLabel.text = sender.isOn ? "Student was present" : "Student was absent"
        
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
            addImageForHW(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addImageForHW(image: UIImage) {
        // Создаем UIImageView для фотографии
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8 // закругленные углы
        imageView.isUserInteractionEnabled = true
        
        // Добавляем imageView в массив photoImageViews
        photoImageViews.append(imageView)
        
        // Добавляем imageView в photoContainerView
        photoContainerView.addSubview(imageView)
        
        // Располагаем imageView в контейнере (может потребоваться настроить констрейнты)
        updatePhotoContainerConstraints()
        
        // Добавляем подпись (название фото) под изображением
        let imageLabel = UILabel()
        imageLabel.text = "Photo \(photoImageViews.count)" // Пример текста подписи
        imageLabel.textAlignment = .center
        imageLabel.font = UIFont.systemFont(ofSize: 12)
        imageLabel.textColor = .black
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        photoContainerView.addSubview(imageLabel)
        
        // Настраиваем констрейнты для imageLabel с использованием SnapKit
        imageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        // Добавляем круглую кнопку удаления (крестик)
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(deleteButton)
        
        // Настраиваем констрейнты для deleteButton с использованием SnapKit
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.trailing.equalTo(imageView.snp.trailing)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        // Настраиваем жест для открытия фото на весь экран
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFullscreenImage(_:)))
        imageView.addGestureRecognizer(tapGesture)
        
        // Вызываем метод делегата для обновления данных студента
        delegate?.didUpdateStudent(student)
    }

    @objc func deleteImage(_ sender: UIButton) {
        guard let imageView = sender.superview as? UIImageView else { return }
        
        if let index = photoImageViews.firstIndex(of: imageView) {
            // Удаляем изображение из массива и из контейнера
            photoImageViews.remove(at: index)
            imageView.removeFromSuperview()
            
            // Обновляем констрейнты контейнера после удаления изображения
            updatePhotoContainerConstraints()
            
            // Обновляем подписи (названия фото) под оставшимися изображениями
            updateImageLabels()
        }
    }

    func updateImageLabels() {
        // Удаляем старые названия фото
        photoContainerView.subviews.compactMap { $0 as? UILabel }.forEach { $0.removeFromSuperview() }
        
        // Добавляем новые названия фото для оставшихся изображений
        for (index, imageView) in photoImageViews.enumerated() {
            let imageLabel = UILabel()
            imageLabel.text = "Photo \(index + 1)" // Пример текста подписи
            imageLabel.textAlignment = .center
            imageLabel.font = UIFont.systemFont(ofSize: 12)
            imageLabel.textColor = .black
            imageLabel.translatesAutoresizingMaskIntoConstraints = false
            photoContainerView.addSubview(imageLabel)
            
            // Настраиваем констрейнты для imageLabel с использованием SnapKit
            imageLabel.snp.makeConstraints { make in
                make.centerX.equalTo(imageView.snp.centerX)
                make.top.equalTo(imageView.snp.bottom).offset(4)
            }
        }
        
        // Обновляем констрейнты контейнера после добавления названий фото
        updatePhotoContainerConstraints()
    }

    
    func updatePhotoContainerConstraints() {
        // Удаляем старые констрейнты
        photoContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем новые констрейнты для каждого изображения в photoImageViews
        var previousImageView: UIImageView?
        for imageView in photoImageViews {
            photoContainerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalTo(photoContainerView.snp.top).offset(8)
                make.leading.equalTo(photoContainerView.snp.leading).offset(8)
                make.width.height.equalTo(50) // задаем размеры изображения
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing).offset(8)
                }
            }
            previousImageView = imageView
        }
    }
    
    
    @objc func openFullscreenImage(_ gesture: UITapGestureRecognizer) {
        guard let tappedImageView = gesture.view as? UIImageView else { return }
        
        let fullscreenVC = FullscreenImageViewController(image: tappedImageView.image ?? UIImage.studentIcon)
        present(fullscreenVC, animated: true, completion: nil)
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
