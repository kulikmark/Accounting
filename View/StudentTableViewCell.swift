//
//  StudentTableViewCell.swift
//  Accounting
//
//  Created by Марк Кулик on 17.04.2024.
//

import UIKit
import SnapKit

class StudentTableViewCell: UITableViewCell {
    
    var student: Student?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var studentNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lessonPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(studentNameLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(lessonPriceLabel)
        contentView.addSubview(scheduleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(studentNameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(studentNameLabel)
        }
        
        lessonPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(studentNameLabel)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalTo(lessonPriceLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(studentNameLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func configure(with student: Student, image: UIImage?) {
        
        if let profileImage = image {
            // Если передано изображение, используем его
            profileImageView.image = profileImage
        } else if let studentImage = student.imageForCell {
            // Если у студента есть изображение, используем его
            profileImageView.image = studentImage
        } else {
            // Если изображение отсутствует как у студента, так и не было передано, установите замену, например, иконку по умолчанию
            profileImageView.image = UIImage(named: "icon")
        }
        
        studentNameLabel.text = "Name: \(student.name)"
        phoneNumberLabel.text = "Number: \(student.phoneNumber)"
        lessonPriceLabel.text = "Price: \(student.lessonPrice)"
        
        // Формируем строку расписания из массива структур Schedule
        let scheduleString = student.schedule.map { "\($0.weekday) \($0.time)" }.joined(separator: ", ")
        
        // Присваиваем полученную строку текстовому полю scheduleLabel
        scheduleLabel.text = "Schedule: \(scheduleString)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
