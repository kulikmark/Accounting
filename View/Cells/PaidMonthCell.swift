//
//  PaidMonthCell.swift
//  Accounting
//
//  Created by Марк Кулик on 24.04.2024.
//

import UIKit
import SnapKit

class PaidMonthCell: UITableViewCell {
    
    let paidMonthStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.alignment = .fill
        stackview.distribution = .fill
        return stackview
    }()
    
    let monthYearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var totalSumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    // Метка для отображения текста "Оплачен"
    let paymentStatusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // Переключатель для определения оплаченности
    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    private func setupConstraints() {
           contentView.addSubview(paidMonthStackView)
           paidMonthStackView.addArrangedSubview(monthYearLabel)
           paidMonthStackView.addArrangedSubview(totalSumLabel)
           
           contentView.addSubview(paymentStatusLabel)
           contentView.addSubview(switchControl)
           
           paidMonthStackView.snp.makeConstraints { make in
               make.leading.equalToSuperview().inset(20)
               make.centerY.equalToSuperview()
           }
           
           paymentStatusLabel.snp.makeConstraints { make in
               make.trailing.equalTo(switchControl.snp.leading).offset(-10)
               make.centerY.equalToSuperview()
           }
           
           switchControl.snp.makeConstraints { make in
               make.trailing.equalToSuperview().inset(10)
               make.centerY.equalToSuperview()
               make.bottom.equalToSuperview().offset(-10)
           }
       }
    
    func configure(with student: Student, month: Month, index: Int, target: Any?, action: Selector) {
        monthYearLabel.text = "\(month.monthName) \(month.monthYear)"
        
        // Получаем список уроков для текущего месяца из студента
        let lessons = month.lessons
        let lessonsCount = Double(lessons.count)
        
        // Используем цену урока для текущего месяца из Month
        let lessonPrice = month.lessonPrice
        let moneySum = lessonsCount * lessonPrice.price
        
        // Форматируем текст для отображения общей суммы с учетом валюты урока
        totalSumLabel.text = String(format: "Total Sum: %.2f %@", moneySum, lessonPrice.currency)
        
        switchControl.tag = index
        switchControl.isOn = month.isPaid
        switchControl.addTarget(target, action: action, for: .valueChanged)
        
        // Устанавливаем текст статуса в зависимости от состояния переключателя
        paymentStatusLabel.text = switchControl.isOn ? "Paid" : "Unpaid"
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
