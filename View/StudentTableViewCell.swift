//
//  StudentTableViewCell.swift
//  Accounting
//
//  Created by Марк Кулик on 17.04.2024.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    var profileImageView: UIImageView = {
          let imageView = UIImageView()
          // Настройка изображения профиля
        imageView.contentMode = .scaleAspectFit
          return imageView
      }()
      
      var nameLabel: UILabel = {
          let label = UILabel()
          // Настройка метки имени
          return label
      }()
      
      var phoneNumberLabel: UILabel = {
          let label = UILabel()
          // Настройка метки номера телефона
          return label
      }()
      
      var parentNameLabel: UILabel = {
          let label = UILabel()
          // Настройка метки имени родителя
          return label
      }()
      
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавляем подвиды в ячейку
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(parentNameLabel)
        
        // Disable autoresizing mask translation
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        parentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Profile image view constraints
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Phone number label constraints
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Parent name label constraints
            parentNameLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 8),
            parentNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            parentNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            parentNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Adjust bottom constraint as needed
        ])
    }
    
    // Обновленный метод configure(with:) в StudentTableViewCell
    func configure(with student: Student, image: UIImage?) {
        profileImageView.image = image ?? UIImage(named: "icon")
        nameLabel.text = student.name
        phoneNumberLabel.text = student.phoneNumber
        parentNameLabel.text = student.parentName
        
        // Добавим отладочный вывод здесь, чтобы проверить установленное изображение
        if let profileImage = profileImageView.image {
            print("Profile image set to:", profileImage)
        } else {
            print("Profile image is nil")
        }
    }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
  }

