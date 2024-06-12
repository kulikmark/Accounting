//
//  AccountingTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//


import UIKit

class AccountingTableViewController: UITableViewController, MonthsTableViewControllerDelegate {
    
    var student: Student?
    
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    var selectedYear: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.reloadData()
        setupStartScreenLabel(with: "There are no added students yet \n\n Add a new student on Students screen and choose them for accounting")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        self.title = "Students Accounting"
        tableView.register(AccountingTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! AccountingTableViewCell
        let student = students[indexPath.row]
        cell.configure(with: student, image: student.imageForCell)
        
        // Установка стиля выделения ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthsVC = MonthsTableViewController()
        let student = students[indexPath.row]
        monthsVC.student = student
        // Создайте строку для представления цены и валюты
        let lessonPriceString = "\(student.lessonPrice.price) \(student.lessonPrice.currency)"
        monthsVC.lessonPrice = lessonPriceString
        monthsVC.paidMonths = student.paidMonths
        monthsVC.selectedYear = student.paidMonths.first?.year ?? ""
        monthsVC.schedules = student.schedule
        monthsVC.lessonsForStudent = student.lessons
        monthsVC.studentType = student.type
        
        monthsVC.delegate = self

        
        navigationController?.pushViewController(monthsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func didUpdateStudent(_ updatedStudent: Student, selectedYear: String) {
        StudentStore.shared.updateStudent(updatedStudent)
        self.selectedYear = selectedYear
        tableView.reloadData()
    }
}
