//
//  MonthLessonsSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 07.06.2024.
//

import UIKit


extension MonthLessonsViewController {
    
    func setupUI() {
        // Создаем таблицу для отображения уроков
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self // Добавляем настройку делегата
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LessonCell")
        view.addSubview(tableView)
        
        // Устанавливаем стиль ячейки, чтобы включить detailTextLabel
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // Добавляем таблицу на представление
        view.addSubview(tableView)
        
        // Присваиваем созданную таблицу свойству tableView
        self.tableView = tableView
        
        // Add Title Label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "Lessons List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Add Scheduled Lessons Button
        view.addSubview(addScheduledLessonsButton)
        addScheduledLessonsButton.snp.makeConstraints { make in
            //            make.bottom.equalTo(addScheduledLessonsButton.snp.top).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addScheduledLessonsButton.setTitle("Add lessons according to the schedule", for: .normal)
        addScheduledLessonsButton.layer.cornerRadius = 10
        addScheduledLessonsButton.setTitleColor(.white, for: .normal)
        addScheduledLessonsButton.backgroundColor = .systemBlue
        addScheduledLessonsButton.addTarget(self, action: #selector(addScheduledLessonsButtonTapped), for: .touchUpInside)
        
        // Add Scheduled Lessons Button
        view.addSubview(addLessonButton)
        addLessonButton.snp.makeConstraints { make in
            make.top.equalTo(addScheduledLessonsButton.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addLessonButton.setTitle("Add a lesson", for: .normal)
        addLessonButton.layer.cornerRadius = 10
        addLessonButton.setTitleColor(.white, for: .normal)
        addLessonButton.backgroundColor = .systemBlue
        addLessonButton.addTarget(self, action: #selector(addLessonButtonTapped), for: .touchUpInside)
    }
}
