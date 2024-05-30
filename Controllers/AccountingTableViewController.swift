//
//  AccountingTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//


import UIKit

// Контроллер таблицы учеников
class AccountingTableViewController: UITableViewController {
    
    var student: Student?
    
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    private var startScreenLabel: UILabel?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray // Установите желаемый цвет разделителя
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Выполните операции с UITableView здесь
        tableView.reloadData()
        
        setupStartScreenLabel()
        updateStartScreenLabelVisibility()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(StudentTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.reloadData()
        
        setupStartScreenLabel()
        updateStartScreenLabelVisibility()
    }
    
    private func setupStartScreenLabel() {
        startScreenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        startScreenLabel?.text = "There are no added students yet \n\n Add a new student and choose them for accounting"
        startScreenLabel?.font = UIFont.systemFont(ofSize: 20)
        startScreenLabel?.textColor = .lightGray
        startScreenLabel?.textAlignment = .center
        startScreenLabel?.numberOfLines = 0
        tableView.backgroundView = startScreenLabel
    }
    
    private func updateStartScreenLabelVisibility() {
        if students.isEmpty {
            startScreenLabel?.isHidden = false
            tableView.separatorStyle = .none
        } else {
            startScreenLabel?.isHidden = true
            tableView.separatorStyle = .singleLine
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        let student = students[indexPath.row]
        cell.configure(with: student, image: student.imageForCell)
        
        // Установка стиля выделения ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthsVC = MonthsTableViewController()
        //        monthsVC.delegate = self
        let student = students[indexPath.row]
        monthsVC.student = student
        monthsVC.paidMonths = student.paidMonths
        //        studentDetailVC.lessonsForStudent = student.lessons
        
        print("student in didSelectRowAt from StudentsTableViewController \(student.schedule)")
        navigationController?.pushViewController(monthsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
