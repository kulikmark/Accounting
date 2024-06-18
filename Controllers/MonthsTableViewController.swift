//
//  MonthsTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 29.04.2024.
//

import UIKit
import SnapKit

protocol DidUpdateStudentDelegate: AnyObject {
    func didUpdateStudent(_ student: Student)
}

class MonthsTableViewController: UITableViewController, SaveChangesHandling, DidUpdateStudentDelegate {
    func didUpdateStudent(_ student: Student) {
        StudentStore.shared.updateStudent(student)
        tableView.reloadData()
    }
    
    weak var delegate: DidUpdateStudentDelegate?
    var student: Student!
    var students: [Student] {
        return StudentStore.shared.students
    }
    var studentType: StudentType?
    var lessonPrice: String = ""
    var lessonPrices: [String] = []
    var changesMade = false
    var schedules = [Schedule]()
    var selectedMonth: Month?
    var selectedSchedules = [(weekday: String, time: String)]()
    var lessonsForStudent: [Lesson] = []
    let addPaidMonthButton = UIButton(type: .system)
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        tableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: - Button Actions
    
    @objc internal func saveButtonTapped() {
        guard let student = student else { return }
        delegate?.didUpdateStudent(student)
        changesMade = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        savingConfirmation()
    }
    
    @objc func addPaidMonthButtonTapped() {
        guard hasSelectedSchedule() else {
            displayErrorMessage("Add a schedule in the student card")
            return
        }
        showMonthSelection()
        changesMade = true
    }
    
    // MARK: - Helper Methods
    
    private func hasSelectedSchedule() -> Bool {
        return !(student?.schedule.isEmpty ?? true)
    }
    
    private func displayErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showMonthSelection() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        for month in ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] {
            alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
                self?.showYearInput(forMonth: month)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    private func showYearInput(forMonth month: String) {
        let yearAlertController = UIAlertController(title: "Enter Year", message: nil, preferredStyle: .alert)
        
        yearAlertController.addTextField { textField in
            textField.placeholder = "Year"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let yearText = yearAlertController.textFields?.first?.text {
                self?.addMonth(yearText, monthName: month)
            }
        }
        
        yearAlertController.addAction(cancelAction)
        yearAlertController.addAction(addAction)
        
        present(yearAlertController, animated: true)
    }
    
    // MARK: - Adding Months Methods
    
    private func addMonth(_ monthYear: String, monthName: String) {
        print("Adding month: \(monthName) \(monthYear)")
        
        guard let student = student else {return}
        
        // Создаем объект LessonPrice, используя значения студента или дефолтные значения
        let lessonPrice = LessonPrice(price: student.lessonPrice.price, currency: student.lessonPrice.currency)
        
        // Проверяем уникальность месяца и года
        if self.student!.months.contains(where: { $0.monthName == monthName && $0.monthYear == monthYear }) {
            let errorAlert = UIAlertController(title: "Error", message: "This month and year already exists.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            
            let month = Month(monthName: monthName, monthYear: monthYear, isPaid: false, lessonPrice: lessonPrice, lessons: [])
            let index = findInsertIndex(for: month)
            self.student?.months.insert(month, at: index)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            
            // Update the student in StudentStore
            StudentStore.shared.updateStudent(student)
            
            changesMade = true
        }
    }
    
    // MARK: - TableView DataSource and Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student?.months.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath) as! PaidMonthCell
        
        if let month = student?.months[indexPath.row] {
                cell.configure(with: student!, month: month, index: indexPath.row, target: self, action: #selector(switchValueChanged(_:)))
            }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMonth = student.months[indexPath.row]
        showMonthLessons(for: selectedMonth!)
    }
    
    private func showMonthLessons(for selectedMonth: Month) {
        let monthLessonsVC = MonthLessonsViewController()
        let lessonPrice = student?.lessonPrice.price ?? 0.0
        monthLessonsVC.student = student
        monthLessonsVC.lessonPrice = lessonPrice
        monthLessonsVC.selectedSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.lessonsForStudent = selectedMonth.lessons
        monthLessonsVC.delegate = self
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeletion(at: indexPath)
        }
        changesMade = true
    }
    
    private func confirmDeletion(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Confirm the deletion", message: "Are you sure you want to delete this month?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteMonth(at: indexPath)
        }
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteMonth(at indexPath: IndexPath) {
        student?.months.remove(at: indexPath.row)
        student?.lessons = []
        lessonsForStudent = []
       
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    // MARK: - Switch Value Changed for PaidMonth
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let index = sender.tag
        student?.months[index].isPaid = sender.isOn
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        changesMade = true
    }
}

// MARK: - Sorting months

extension MonthsTableViewController {
    
    private func findInsertIndex(for newMonth: Month) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        guard let newDate = dateFormatter.date(from: "\(newMonth.monthName) \(newMonth.monthYear)") else {
            return  student?.months.count ?? 0
        }
        
        for (index, month) in  student.months.enumerated() {
            guard let monthDate = dateFormatter.date(from: "\(month.monthName) \(month.monthYear)") else {
                continue
            }
            if newDate < monthDate {
                return index
            }
        }
        return student?.months.count ?? 0
    }
}
