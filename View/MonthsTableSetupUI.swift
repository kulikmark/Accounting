//
//  MonthsTableSetupUI.swift
//  Accounting
//
//  Created by Марк Кулик on 07.06.2024.
//

import UIKit

extension MonthsTableViewController {
    
    // MARK: - UI Setup
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        // Add Paid Month Button
        view.addSubview(addPaidMonthButton)
        addPaidMonthButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addPaidMonthButton.setTitle("Add month", for: .normal)
        addPaidMonthButton.layer.cornerRadius = 10
        addPaidMonthButton.setTitleColor(.white, for: .normal)
        addPaidMonthButton.backgroundColor = .systemBlue
        addPaidMonthButton.addTarget(self, action: #selector(addPaidMonthButtonTapped), for: .touchUpInside)
        
        // Настройка таблицы оплаченных месяцев
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
    }
    
    @objc func addPaidMonthButtonTapped() {
        
        guard hasSelectedSchedule() else {
                    // Если расписание не выбрано, показываем сообщение об ошибке
                    displayErrorMessage("Добавьте расписание в карточке ученика")
                    return
                }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        for month in ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] {
            alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
                self?.showYearInput(forMonth: month)
            }))
        }
        
        present(alertController, animated: true)
        
        changesMade = true
    }
    
    func hasSelectedSchedule() -> Bool {
            // Проверяем наличие выбранного расписания
            return !(student?.schedule.isEmpty ?? true)
        }
        
        func displayErrorMessage(_ message: String) {
            let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    
    func showYearInput(forMonth month: String) {
        let yearAlertController = UIAlertController(title: "Enter Year", message: nil, preferredStyle: .alert)
        
        yearAlertController.addTextField { textField in
            textField.placeholder = "Year"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let yearText = yearAlertController.textFields?.first?.text {
                self?.addPaidMonth(yearText, month: month)
            }
        }
        
        yearAlertController.addAction(cancelAction)
        yearAlertController.addAction(addAction)
        
        present(yearAlertController, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func addPaidMonth(_ year: String, month: String) {
        print("Adding month: \(month)")
        let paidMonth = PaidMonth (year: year, month: month, isPaid: false)
        selectedYear = year
        paidMonths.append(paidMonth)
        
        print("Месяц добавился в массив\(paidMonths)")
        
        // Проверяем, есть ли уроки для этого месяца в словаре lessonsForStudent
        if lessonsForStudent[month] == nil || lessonsForStudent[month]?.isEmpty == true {
            // Если уроки для этого месяца еще не созданы или пусты, добавляем пустой массив уроков
            lessonsForStudent[month] = []
        }
        
        // Вставляем новую строку в таблицу и обновляем UI
        let indexPath = IndexPath(row: paidMonths.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateUI()
        
        // Установка флага changesMade в true, так как были внесены изменения
        changesMade = true
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}
