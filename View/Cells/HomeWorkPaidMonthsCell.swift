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
    
    lazy var paidMonthLabel: UILabel = {
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
        
        contentView.addSubview(paidMonthLabel)
        contentView.addSubview(paidStatusLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        paidMonthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(25)
        }
        
        paidStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(paidMonthLabel.snp.bottom).offset(5)
            make.leading.equalTo(paidMonthLabel)
        }
    }
    
    func configure(with student: Student, selectedMonth: String) {
           self.student = student
           self.selectedMonth = selectedMonth
        
        if let paidMonth = student.paidMonths.first(where: { $0.month == selectedMonth }) {
               paidMonthLabel.text = "\(paidMonth.month) \(paidMonth.year)"
               paidStatusLabel.text = paidMonth.isPaid ? "Paid" : "Not Paid"
           } else {
               paidMonthLabel.text = "\(selectedMonth) - No Data"
               paidStatusLabel.text = "No Data"
           }
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
