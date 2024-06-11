//
//  TextFormatter.swift
//  Accounting
//
//  Created by Марк Кулик on 04.06.2024.
//

import UIKit

struct TextFormatter {
    
    static func formattedText(boldText: String, regularText: String) -> NSAttributedString {
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
        let regularFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        
        let attributedString = NSMutableAttributedString(string: "\(boldText): ", attributes: boldFontAttribute)
        attributedString.append(NSAttributedString(string: regularText, attributes: regularFontAttribute))
        
        return attributedString
    }
}
