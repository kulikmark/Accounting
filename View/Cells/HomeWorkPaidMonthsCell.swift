//
//  HomeWorkPaidMonthsCell.swift
//  Accounting
//
//  Created by Марк Кулик on 10.06.2024.
//


import UIKit
import SnapKit

class HomeWorkPaidMonthsCell: UITableViewCell {
    
    var student: Student?
    var selectedMonth: String = ""
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var paidStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Устанавливаем фон ячейки на прозрачный
        self.backgroundColor = .clear
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(paidStatusLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(25)
        }
        
        paidStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(5)
            make.leading.equalTo(monthLabel)
        }
    }
    
    func configure(with student: Student, selectedMonth: String) {
           self.student = student
           self.selectedMonth = selectedMonth
        
        if let month = student.months.first(where: { $0.monthName == selectedMonth }) {
               monthLabel.text = "\(month.monthName) \(month.monthYear)"
               paidStatusLabel.text = month.isPaid ? "Paid" : "Not Paid"
           } else {
               monthLabel.text = "\(selectedMonth) - No Data"
               paidStatusLabel.text = "No Data"
           }
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
