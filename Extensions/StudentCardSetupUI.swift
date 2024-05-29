//
//  StudentCardSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//

import UIKit

// MARK: - UI Setup

extension StudentCardViewController {
    
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
        
        // Lesson Price Label
        view.addSubview(lessonPriceLabel)
        lessonPriceLabel.text = "Lesson Price"
        lessonPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        lessonPriceLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Lesson Price Textfield
        view.addSubview(lessonPriceTextField)
        lessonPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(lessonPriceLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        lessonPriceTextField.borderStyle = .roundedRect
        lessonPriceTextField.placeholder = "Enter lesson price"
        lessonPriceTextField.text = student?.lessonPrice ?? ""
        
        // Schedule Label
        view.addSubview(scheduleLabel)
        scheduleLabel.text = "Schedule"
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalTo(lessonPriceTextField.snp.bottom).offset(20)
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

