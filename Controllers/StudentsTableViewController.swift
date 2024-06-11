//
//  StudentsTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 13.04.2024.
//

import UIKit

// Контроллер таблицы учеников
class StudentsTableViewController: UITableViewController {
    
    var student: Student?
    
    var students: [Student] {
           return StudentStore.shared.students
       }
    
    var selectedYear: String = ""
    
    private let titleLabel = UILabel()
    
       private var startScreenLabel: UILabel?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        
        // Выполните операции с UITableView здесь
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "Students List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
   
        tableView.register(StudentTableViewCell.self, forCellReuseIdentifier: "StudentCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStudent))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        self.tableView.estimatedRowHeight = 300 // Установите приблизительную оценку высоты ячейки
        self.tableView.rowHeight = UITableView.automaticDimension
        
        setupStartScreenLabel()
        updateStartScreenLabelVisibility()
    }
    
    private func setupStartScreenLabel() {
        startScreenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        startScreenLabel?.text = "Add first student \n\n Tap + in the left corner of the screen"
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
        let studentCardVC = StudentCardViewController(editMode: .edit, delegate: self)
        studentCardVC.delegate = self
        let student = students[indexPath.row]
        studentCardVC.student = student
//        studentCardVC.paidMonths = student.paidMonths
        
        navigationController?.pushViewController(studentCardVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure you want to delete this student?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.deleteStudent(at: indexPath)
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteStudent(at indexPath: IndexPath) {
            StudentStore.shared.removeStudent(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateStartScreenLabelVisibility()
        }
    
    // MARK: - Actions
    
    @objc func addNewStudent() {
        let editMode: EditMode = .add // Устанавливаем режим добавления нового ученика
        
        let studentCardVC = StudentCardViewController(editMode: editMode, delegate: self)
        navigationController?.pushViewController(studentCardVC, animated: true)
    }
}

// MARK: - StudentDetailDelegate

extension StudentsTableViewController: StudentCardDelegate {
    
    func didCreateStudent(_ existingStudent: Student, withImage: UIImage?) {
        if let index = students.firstIndex(where: { $0.id == existingStudent.id }) {
            StudentStore.shared.updateStudent(existingStudent)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            StudentStore.shared.addStudent(existingStudent)
            tableView.insertRows(at: [IndexPath(row: students.count - 1, section: 0)], with: .automatic)
        }
        updateStartScreenLabelVisibility()
    }
}

// MARK: - MonthsTableViewControllerDelegate

extension StudentsTableViewController: MonthsTableViewControllerDelegate {
    func didUpdateStudent(_ updatedStudent: Student, selectedYear: String) {
        StudentStore.shared.updateStudent(updatedStudent)
        self.selectedYear = selectedYear
        tableView.reloadData()
    }
    
    func didUpdateStudent(_ updatedStudent: Student) {
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            StudentStore.shared.updateStudent(updatedStudent)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
