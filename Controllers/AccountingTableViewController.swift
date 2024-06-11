//
//  AccountingTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//


import UIKit

// Контроллер таблицы учеников
class AccountingTableViewController: UITableViewController, MonthsTableViewControllerDelegate {
    
    var student: Student?
    
    var students: [Student] {
        return StudentStore.shared.students
    }
    
    private var startScreenLabel: UILabel?
    
    var selectedYear: String = ""
    
    let titleLabel = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        
        // Выполните операции с UITableView здесь
        tableView.reloadData()
        
        setupStartScreenLabel()
        updateStartScreenLabelVisibility()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Paid Months Label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "Students Accounting"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        tableView.register(AccountingTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        
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
