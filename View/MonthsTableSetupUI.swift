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
        addPaidMonthButton.addTarget(self, action: #selector(addMonthButtonTapped), for: .touchUpInside)
        
        // Настройка таблицы оплаченных месяцев
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
    }
}
