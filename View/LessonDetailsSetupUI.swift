//
//  LessonDetailsSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 11.06.2024.
//

import UIKit

extension LessonDetailsViewController {
    
    func setupUI() {
        // Add a button to share homework
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareHomework))
        navigationItem.rightBarButtonItem = shareButton
        
        view.addSubview(homeworkTextView)
        
        // Add attendance switch
        attendanceSwitch = UISwitch()
        attendanceSwitch.addTarget(self, action: #selector(attendanceSwitchValueChanged(_:)), for: .valueChanged)
        view.addSubview(attendanceSwitch)
        
        // Set initial state of attendanceSwitch based on lesson.attended
        attendanceSwitch.isOn = lesson.attended
        
        // Add status label
        statusLabel = UILabel()
        statusLabel.text = attendanceSwitch.isOn ? "Was present" : "Was absent"
        statusLabel.textAlignment = .left
        view.addSubview(statusLabel)
        
        // Add a button to save homework
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Setup constraints
        homeworkTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(attendanceSwitch.snp.top).offset(-20)
        }
        homeworkTextView.backgroundColor = UIColor.systemGroupedBackground
        
        attendanceSwitch.snp.makeConstraints { make in
            make.top.equalTo(homeworkTextView.snp.bottom).offset(20)
            make.trailing.equalTo(homeworkTextView.snp.trailing)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(attendanceSwitch)
            make.leading.equalTo(homeworkTextView.snp.leading)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
}
