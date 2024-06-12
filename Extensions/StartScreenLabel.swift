//
//  StartScreenLabel.swift
//  Accounting
//
//  Created by Марк Кулик on 11.06.2024.
//

import UIKit

extension UITableViewController {
    
    // Метод для установки стартового экрана
    func setupStartScreenLabel(with message: String) {
        let startScreenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        startScreenLabel.text = message
        startScreenLabel.font = UIFont.systemFont(ofSize: 17)
        startScreenLabel.textColor = .lightGray
        startScreenLabel.textAlignment = .center
        startScreenLabel.numberOfLines = 0
        tableView.backgroundView = startScreenLabel
        updateStartScreenLabelVisibility()
    }
    
    // Метод для обновления видимости стартового экрана
    func updateStartScreenLabelVisibility() {
        guard let startScreenLabel = tableView.backgroundView as? UILabel else { return }
        if let studentController = self as? StudentsTableViewController {
            startScreenLabel.isHidden = !studentController.students.isEmpty
            tableView.separatorStyle = studentController.students.isEmpty ? .none : .singleLine
        } else if let accountingController = self as? AccountingTableViewController {
            startScreenLabel.isHidden = !accountingController.students.isEmpty
            tableView.separatorStyle = accountingController.students.isEmpty ? .none : .singleLine
        } else if let homeworkController = self as? HomeWorkTableViewController {
            startScreenLabel.isHidden = !homeworkController.students.isEmpty
            tableView.separatorStyle = homeworkController.students.isEmpty ? .none : .singleLine
        }
    }
}
