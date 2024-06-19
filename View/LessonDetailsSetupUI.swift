//
//  LessonDetailsSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 11.06.2024.
//

import UIKit

extension LessonDetailsViewController {
    
    //    func setupUI() {
    //
    //        // Add a button to share homework
    //        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareHomework))
    //
    //        // Create a paperclip button
    //        let paperclipButton = UIBarButtonItem(image: UIImage(systemName: "paperclip"), style: .plain, target: self, action: #selector(paperclipButtonTapped))
    //
    //        // Set both buttons to the right side of the navigation bar
    //        navigationItem.rightBarButtonItems = [shareButton, paperclipButton]
    //
    //        view.addSubview(homeworkTextView)
    //        view.addSubview(photoContainerView)
    //        photoContainerView.backgroundColor = .clear
    //
    //        // Add attendance switch
    //        attendanceSwitch = UISwitch()
    //        attendanceSwitch.addTarget(self, action: #selector(attendanceSwitchValueChanged(_:)), for: .valueChanged)
    //        view.addSubview(attendanceSwitch)
    //
    //        // Set initial state of attendanceSwitch based on lesson.attended
    //        attendanceSwitch.isOn = lesson.attended
    //
    //        // Add status label
    //        statusLabel = UILabel()
    //        statusLabel.text = attendanceSwitch.isOn ? "Student was present" : "Student was absent"
    //        statusLabel.textAlignment = .left
    //        view.addSubview(statusLabel)
    //
    //        // Add a button to save homework
    //        saveButton = UIButton(type: .system)
    //        saveButton.setTitle("Save Changes", for: .normal)
    //        saveButton.layer.cornerRadius = 10
    //        saveButton.setTitleColor(.white, for: .normal)
    //        saveButton.backgroundColor = .systemBlue
    //        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    //        view.addSubview(saveButton)
    //
    //        // Setup constraints
    //        homeworkTextView.snp.makeConstraints { make in
    //            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
    //            make.leading.trailing.equalToSuperview().inset(20)
    //            make.bottom.equalTo(photoContainerView.snp.top)
    //        }
    //        homeworkTextView.backgroundColor = UIColor.systemGroupedBackground
    //
    //        // Добавляем констрейнты для photoContainerView
    //        photoContainerView.snp.remakeConstraints { make in
    //            make.top.equalTo(homeworkTextView.snp.bottom).offset(-25)
    //            make.leading.trailing.equalToSuperview().inset(20)
    //            make.bottom.equalTo(statusLabel.snp.top).offset(-50)
    //        }
    //        photoContainerView.backgroundColor = .lightGray
    //        photoContainerView.layer.cornerRadius = 10
    //
    //        statusLabel.snp.makeConstraints { make in
    //            make.top.equalTo(attendanceSwitch.snp.top)
    //            make.leading.equalToSuperview().inset(20)
    //        }
    //
    //        attendanceSwitch.snp.makeConstraints { make in
    //            make.centerY.equalTo(attendanceSwitch)
    //            make.trailing.equalToSuperview().inset(20)
    //            make.bottom.equalTo(saveButton.snp.top).offset(-20)
    //        }
    //
    //        saveButton.snp.makeConstraints { make in
    //            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    //            make.leading.trailing.equalToSuperview().inset(20)
    //            make.height.equalTo(44)
    //        }
    //    }
    
    func setupUI() {
        
        // Add a button to share homework
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareHomework))
        
        // Create a paperclip button
        let paperclipButton = UIBarButtonItem(image: UIImage(systemName: "paperclip"), style: .plain, target: self, action: #selector(paperclipButtonTapped))
        
        // Set both buttons to the right side of the navigation bar
        navigationItem.rightBarButtonItems = [shareButton, paperclipButton]
        
        // Add a stack view for statusLabel and attendanceSwitch
        let statusStackView = UIStackView()
        statusStackView.axis = .horizontal
//        statusStackView.spacing = 8
        
        enterHWLabel = UILabel()
        enterHWLabel.font = UIFont.systemFont(ofSize: 14)
        enterHWLabel.textColor = .darkGray
        enterHWLabel.text = "Enter Homework here:"
        clippedPhotosLabel = UILabel()
        clippedPhotosLabel.font = UIFont.systemFont(ofSize: 14)
        clippedPhotosLabel.textColor = .darkGray
        clippedPhotosLabel.text = "Clipped photos"
        
        // Add attendance switch
        attendanceSwitch = UISwitch()
        attendanceSwitch.addTarget(self, action: #selector(attendanceSwitchValueChanged(_:)), for: .valueChanged)
        view.addSubview(attendanceSwitch)
        // Set initial state of attendance Switch based on lesson.attended
        attendanceSwitch.isOn = lesson.attended
        
        // Add status label
        statusLabel = UILabel()
        statusLabel.text = attendanceSwitch.isOn ? "Student was present" : "Student was absent"
        statusLabel.textAlignment = .left
        view.addSubview(statusLabel)
        
        view.addSubview(enterHWLabel)
        view.addSubview(homeworkTextView)
        view.addSubview(clippedPhotosLabel)
        view.addSubview(photoContainerView)
        view.addSubview(statusStackView)
        statusStackView.addArrangedSubview(statusLabel)
        statusStackView.addArrangedSubview(attendanceSwitch)
        
        // Add a button to save homework
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Setup constraints
        enterHWLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(homeworkTextView.snp.top).offset(-7)
        }
        
        homeworkTextView.snp.makeConstraints { make in
            make.top.equalTo(enterHWLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(clippedPhotosLabel.snp.top).offset(-25)
        }
        
        clippedPhotosLabel.snp.remakeConstraints { make in
            make.top.equalTo(homeworkTextView.snp.bottom)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(photoContainerView.snp.top).offset(-7)
        }
        
        // Добавляем констрейнты для photoContainerView
        photoContainerView.snp.remakeConstraints { make in
            make.top.equalTo(clippedPhotosLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
            make.bottom.equalTo(statusStackView.snp.top).offset(-25)
        }
        
        // Констрейнты для statusStackView
        statusStackView.snp.makeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-25)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
