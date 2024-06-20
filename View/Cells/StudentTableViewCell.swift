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
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var studentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var lessonPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(studentNameLabel)
        containerView.addSubview(phoneNumberLabel)
        containerView.addSubview(lessonPriceLabel)
        containerView.addSubview(scheduleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).offset(10)
            make.width.height.equalTo(100)
            make.bottom.lessThanOrEqualTo(containerView).offset(-10).priority(.medium)
        }
        
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(23)
            make.trailing.equalTo(containerView).offset(-10)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(studentNameLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(studentNameLabel)
        }
        
        lessonPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(studentNameLabel)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalTo(lessonPriceLabel.snp.bottom).offset(7)
            make.leading.trailing.equalTo(studentNameLabel)
            make.bottom.lessThanOrEqualTo(containerView).offset(-10)
        }
    }
    
    func configure(with student: Student, image: UIImage?) {
        self.student = student
        
        if let profileImage = image {
            profileImageView.image = profileImage
        } else if let studentImage = student.imageForCell {
            profileImageView.image = studentImage
        } else {
            profileImageView.image = UIImage(named: "icon")
        }
        
        studentNameLabel.text = student.name
        phoneNumberLabel.text = "Phone: \(student.phoneNumber)"
        
        let lessonPriceString = "\(student.lessonPrice.price) \(student.lessonPrice.currency)"
        lessonPriceLabel.text = "Lesson Price: \(lessonPriceString)"
        
        updateScheduleTextField()
    }
    
    func updateScheduleTextField() {
        var scheduleStrings = [String]()
        
        // Отсортируйте выбранные расписания по дням недели перед отображением
        if let sortedSchedules = student?.schedule.sorted(by: { orderOfDay($0.weekday) < orderOfDay($1.weekday) }) {
            scheduleStrings = sortedSchedules.map { "\($0.weekday) \($0.time)" }
        }
        
        let formattedSchedule = scheduleStrings.joined(separator: ", ")
        scheduleLabel.text = "Schedule: \(formattedSchedule)"
    }

    func orderOfDay(_ weekday: String) -> Int {
        switch weekday {
        case "MON": return 0
        case "TUE": return 1
        case "WED": return 2
        case "THU": return 3
        case "FRI": return 4
        case "SAT": return 5
        case "SUN": return 6
        default: return 7
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
