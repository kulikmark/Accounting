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
        stackview.axis = .horizontal
        stackview.spacing = 8
        stackview.alignment = .fill
        stackview.distribution = .fill
        return stackview
    }()
    
    // Метка для отображения текста "Оплачен"
    let paidLabel: UILabel = {
        let label = UILabel()
        label.text = "Paid"
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
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(paidMonthStackView)
        paidMonthStackView.addArrangedSubview(paidLabel)
        paidMonthStackView.addArrangedSubview(switchControl)
        
        paidMonthStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
                  make.centerY.equalToSuperview()
        }
    }
}
