//
//  AccountingTableViewCell.swift
//  Accounting
//
//  Created by Марк Кулик on 04.06.2024.
//

import UIKit
import SnapKit

class AccountingTableViewCell: UITableViewCell {
    
    var student: Student?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
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
    
    lazy var lessonsQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var moneySumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        contentView.addSubview(lessonsQuantityLabel)
        contentView.addSubview(moneySumLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(23)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(25)
        }
        
        lessonsQuantityLabel.snp.makeConstraints { make in
            make.top.equalTo(studentNameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(studentNameLabel)
            make.height.equalTo(16)
        }
        
        moneySumLabel.snp.makeConstraints { make in
            make.top.equalTo(lessonsQuantityLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(studentNameLabel)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    func configure(with student: Student) {
        
        self.student = student
        
        if let profileImage = student.imageForCell {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = UIImage(named: "icon")
        }
        
        studentNameLabel.text = student.name
        
        // Очищаем предыдущие данные
        lessonsQuantityLabel.text = ""
        moneySumLabel.text = ""
        
        // Вычисляем и отображаем информацию по каждому месяцу
        var totalLessonsCount = 0
        var totalMoneySum = 0.0
        
        for month in student.months {
            let lessonsCount = month.lessons.count
            totalLessonsCount += lessonsCount
            
            let lessonPrice = month.lessonPrice
            let moneySum = Double(lessonsCount) * lessonPrice.price
            totalMoneySum += moneySum
            
            // Создаем строку для отображения информации о месяце
            let monthInfo = "\(month.monthName) - Lessons: \(lessonsCount), Total: \(moneySum) \(lessonPrice.currency)"
            
            // Добавляем информацию в соответствующий label
            if let existingText = lessonsQuantityLabel.text, !existingText.isEmpty {
                lessonsQuantityLabel.text! += "\n\(monthInfo)"
            } else {
                lessonsQuantityLabel.text = monthInfo
            }
        }
        
        // Убедитесь, что отображаете общее количество уроков
        print("Total lessons for student: \(totalLessonsCount)")
        
        // Отображаем общее количество уроков и сумму денег
        lessonsQuantityLabel.text = "Total Lessons: \(totalLessonsCount)"
        moneySumLabel.text = "Total Money: \(totalMoneySum)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
