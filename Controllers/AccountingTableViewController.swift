//
//  AccountingTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//


import UIKit

extension AccountingTableViewController {
    func didUpdateStudent(_ updatedStudent: Student) {
        StudentStore.shared.updateStudent(updatedStudent)
        tableView.reloadData()
    }
}

class AccountingTableViewController: UITableViewController, DidUpdateStudentDelegate {
    
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        self.title = "Students Accounting"
        tableView.register(AccountingTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! AccountingTableViewCell
        let student = students[indexPath.row]
        cell.configure(with: student)
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMonthsVC(for: students[indexPath.row])
    }
    
    private func navigateToMonthsVC(for student: Student) {
        let monthsVC = MonthsTableViewController()
        monthsVC.student = student
        monthsVC.studentType = student.type
        monthsVC.lessonPrice = "\(student.lessonPrice.price) \(student.lessonPrice.currency)"
        monthsVC.schedules = student.schedule
        monthsVC.delegate = self
        navigationController?.pushViewController(monthsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
