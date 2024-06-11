//
//  SavingConfirmation.swift
//  Accounting
//
//  Created by Марк Кулик on 04.06.2024.
//

import UIKit

protocol SaveChangesHandling: AnyObject {
  
    var changesMade: Bool { get set }
    func saveButtonTapped()
    func discardChanges()
}

extension SaveChangesHandling where Self: UIViewController {
    
    func savingConfirmation() {
        // Проверяем, были ли внесены изменения
        if changesMade {
            let alertController = UIAlertController(title: "Save changes?", message: "There are unsaved changes. \n\n Are you sure you want to exit without saving?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.discardChanges()
            }
            alertController.addAction(cancelAction)
            
            let saveAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.saveButtonTapped()
            }
            alertController.addAction(saveAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func discardChanges() {
           // Сбрасываем флаг changesMade в false
           changesMade = false
           
           // Возвращаемся на предыдущий экран
           navigationController?.popViewController(animated: true)
       }
}
