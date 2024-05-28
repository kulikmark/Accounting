//
//  StudentsTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 13.04.2024.
//

import UIKit

// Модель данных для ученика
class Student {
    var name: String
    var imageForCell: UIImage?
    var phoneNumber: String
    var parentName: String
    
    init(name: String, phoneNumber: String, parentName: String, imageForCell: UIImage? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.parentName = parentName
        self.imageForCell = imageForCell
    }
}

// Контроллер таблицы учеников
class StudentsTableViewController: UITableViewController {
    var students = [Student]() // Массив объектов типа Student
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Students"
        tableView.register(StudentTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStudent))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        let student = students[indexPath.row]
        cell.configure(with: student, image: student.imageForCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let studentDetailVC = StudentDetailViewController()
           studentDetailVC.delegate = self
           studentDetailVC.student = students[indexPath.row]
           navigationController?.pushViewController(studentDetailVC, animated: true)
       }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let alertController = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить этого ученика?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                    self?.deleteStudent(at: indexPath)
                }
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        
        func deleteStudent(at indexPath: IndexPath) {
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    // MARK: - Actions
    
    @objc func addNewStudent() {
        let studentDetailVC = StudentDetailViewController()
        studentDetailVC.delegate = self
        navigationController?.pushViewController(studentDetailVC, animated: true)
    }
}

// MARK: - StudentDetailDelegate

extension StudentsTableViewController: StudentDetailDelegate {
     func didCreateStudent(_ student: Student, withImage: UIImage?) {
        students.append(student) // Добавляем нового ученика в массив
        tableView.insertRows(at: [IndexPath(row: students.count - 1, section: 0)], with: .automatic) // Вставляем новую строку в таблицу
        tableView.reloadData() // Перезагружаем таблицу
    }
}
