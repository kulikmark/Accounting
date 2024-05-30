//
//  KeyboardWork.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//

import UIKit

// MARK: - Keyboard Handling

extension StudentCardViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Подписываемся на уведомления о появлении и исчезновении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Отписываемся от уведомлений при исчезновении контроллера
        NotificationCenter.default.removeObserver(self)
    }
    
    // Функция для определения текущего активного текстового поля
    private func activeTextField() -> UITextField? {
        if studentNameTextField.isFirstResponder {
            return studentNameTextField
        } else if phoneTextField.isFirstResponder {
            return phoneTextField
        } else if lessonPriceTextField.isFirstResponder {
            return lessonPriceTextField
        } else if scheduleTextField.isFirstResponder {
            return scheduleTextField
        }
        return nil
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeField = activeTextField() else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        let activeFieldBottom = activeField.frame.origin.y + activeField.frame.size.height
        let screenHeight = UIScreen.main.bounds.size.height
        let viewableScreenHeight = screenHeight - keyboardHeight
        
        // Проверяем, находится ли активное поле за пределами видимой области
        if activeFieldBottom > viewableScreenHeight {
            // Сдвигаем активное поле вверх только если оно находится за пределами видимой области
            let offset = activeFieldBottom - viewableScreenHeight
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -offset
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // При скрытии клавиатуры возвращаем представление на исходное положение
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

extension StudentCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case studentNameTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            lessonPriceTextField.becomeFirstResponder()
        case lessonPriceTextField:
            lessonPriceTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
