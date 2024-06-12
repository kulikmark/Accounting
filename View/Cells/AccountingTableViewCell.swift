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
        contentView.addSubview(lessonsQuantityLabel)
        contentView.addSubview(moneySumLabel)
        
        setupConstraints()
        
        print(" lessonsQuantityLabel.text \(String(describing: lessonsQuantityLabel.text))")
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
//            make.height.equalToSuperview().offset(-10).priority(.low)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

    }
    
    func configure(with student: Student, image: UIImage?) {
        if let profileImage = image {
            profileImageView.image = profileImage
        } else if let studentImage = student.imageForCell {
            profileImageView.image = studentImage
        } else {
            profileImageView.image = UIImage(named: "icon")
        }
        
        studentNameLabel.text = student.name
       
        // Вычисляем количество уроков
            let lessonsCount = Double(student.lessons.values.reduce(0) { $0 + $1.count })
            lessonsQuantityLabel.text = "Lessons Quantity: \(Int(lessonsCount))"
        
        // Вычисляем сумму денег, учитывая цену урока и валюту
           if let lessonPrice = Double(student.lessonPrice.price) {
               let moneySum = lessonsCount * lessonPrice
               moneySumLabel.text = "Money Sum: \(moneySum) \(student.lessonPrice.currency)"
           } else {
               moneySumLabel.text = "Money Sum: Invalid price"
           }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
