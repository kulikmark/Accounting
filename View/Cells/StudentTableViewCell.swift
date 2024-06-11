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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 4
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Устанавливаем фон ячейки на прозрачный
        self.backgroundColor = .clear
        
        // Добавляем визуальные эффекты к contentView
        self.contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        
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
            make.bottom.lessThanOrEqualToSuperview().offset(-10).priority(.medium)
        }
        
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(23)
            make.trailing.equalToSuperview().offset(-10)
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
         
            /*  Этот код говорит SnapKit установить высоту scheduleLabel равной высоте его родительского представления минус 10 с низким приоритетом.
            Это позволит scheduleLabel расти по высоте, если его содержимое не помещается внутри contentView,
            но при этом сохраняет приоритет других ограничений,
            чтобы не нарушать логику размещения в вашей ячейке. */
            
            make.height.equalToSuperview().offset(-10).priority(.low)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func configure(with student: Student, image: UIImage?) {
        self.student = student // Установите свойство student
        
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
        default: return 7 // Для непредвиденных случаев
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
