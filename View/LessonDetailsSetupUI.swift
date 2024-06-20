//
//  LessonDetailsSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 11.06.2024.
//

import UIKit

extension LessonDetailsViewController {
    
    func setupUI() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareHomework))
        let paperclipButton = UIBarButtonItem(image: UIImage(systemName: "paperclip"), style: .plain, target: self, action: #selector(paperclipButtonTapped))
        navigationItem.rightBarButtonItems = [shareButton, paperclipButton]
        
        let statusStackView = UIStackView()
               statusStackView.axis = .horizontal
               statusStackView.spacing = 10
               statusStackView.alignment = .fill
               statusStackView.distribution = .fill
        
        enterHWLabel = UILabel()
        enterHWLabel.font = UIFont.systemFont(ofSize: 14)
        enterHWLabel.textColor = .darkGray
        enterHWLabel.text = "Enter Homework here:"
        
        clippedPhotosLabel = UILabel()
        clippedPhotosLabel.font = UIFont.systemFont(ofSize: 14)
        clippedPhotosLabel.textColor = .darkGray
        clippedPhotosLabel.text = "Clipped photos"
        
        statusLabel = UILabel()
        enterHWLabel.font = UIFont.systemFont(ofSize: 14)
        enterHWLabel.textColor = .darkGray
        statusLabel.textAlignment = .left
        
        attendanceSwitch = UISwitch()
        attendanceSwitch.addTarget(self, action: #selector(attendanceSwitchValueChanged(_:)), for: .valueChanged)
        attendanceSwitch.isOn = lesson.attended
        statusLabel.text = attendanceSwitch.isOn ? "Student was present" : "Student was absent"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 60, height: 60)
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photoCollectionView.backgroundColor = .systemGroupedBackground
        photoCollectionView.layer.cornerRadius = 10
        
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        view.addSubview(statusStackView)
        statusStackView.addArrangedSubview(statusLabel)
        statusStackView.addArrangedSubview(attendanceSwitch)
        
        view.addSubview(enterHWLabel)
        view.addSubview(homeworkTextView)
        view.addSubview(clippedPhotosLabel)
        view.addSubview(saveButton)
        view.addSubview(photoCollectionView)
        
        // Constraints:
        enterHWLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        homeworkTextView.snp.makeConstraints { make in
            make.top.equalTo(enterHWLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        clippedPhotosLabel.snp.makeConstraints { make in
            make.top.equalTo(homeworkTextView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(clippedPhotosLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        photoCollectionView.layer.cornerRadius = 10
        
        statusStackView.snp.makeConstraints { make in
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
            make.trailing.leading.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
                       make.leading.trailing.equalToSuperview().inset(20)
                       make.height.equalTo(44)
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Рассчитываем сдвиг для текстового поля
        let keyboardHeight = keyboardFrame.height
        let textViewBottomY = homeworkTextView.frame.origin.y + homeworkTextView.frame.height
        let overlap = textViewBottomY - (view.frame.height - keyboardHeight)
        
        if overlap > 0 {
            view.frame.origin.y = -overlap
        }
    }

    @objc func handleKeyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func shareHomework() {
        guard let homeworkText = homeworkTextView.text else { return }
        
        let activityVC = UIActivityViewController(activityItems: [homeworkText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
