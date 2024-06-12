//
//  MonthsTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 29.04.2024.
//

import UIKit
import SnapKit

extension MonthsTableViewController {
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]]) {
        lessonsForStudent = lessons
    }
}

protocol MonthsTableViewControllerDelegate: AnyObject {
    func didUpdateStudent(_ student: Student, selectedYear: String)
}

// MARK: - StudentAddingViewController TableView

class MonthsTableViewController: UITableViewController, MonthLessonsDelegate, SaveChangesHandling {
    
    weak var delegate: MonthsTableViewControllerDelegate?
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
    var studentType: StudentType?
    var lessonPrice: String = ""
    var changesMade = false
    var paidMonths = [PaidMonth]()
    var schedules = [Schedule]()
    var selectedYear: String = ""
    var selectedSchedules = [(weekday: String, time: String)]()
    var lessonsForStudent: [String: [Lesson]] = [:]
    let addPaidMonthButton = UIButton(type: .system)
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        tableView.reloadData()
        
        print("вернулись lessonPrice: \(lessonPrice)") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.title = "Paid Months List"
        
        // Заменяем кнопку "Back" на кастомную кнопку
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        tableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
        print("lessonPrice: \(lessonPrice)")
        
    }
    
    @objc internal func saveButtonTapped() {
        guard let student = student else { return }
        
        // Update the student's paidMonths and lessons properties
        student.paidMonths = paidMonths
        student.lessons = lessonsForStudent
        
        delegate?.didUpdateStudent(student, selectedYear: selectedYear)
        
        // После сохранения изменений сбросьте флаг changesMade в false
        changesMade = false
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        savingConfirmation()
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paidMonths.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath) as! PaidMonthCell
        
        let paidMonth = paidMonths[indexPath.row]
        
        let defaultLessonPrice = LessonPrice(price: "50.0", currency: "GBP")
        let totalAmount = calculateTotalAmount(forMonth: paidMonth.month, lessonPrice: student?.lessonPrice ?? defaultLessonPrice)

        
        let attributedString = NSMutableAttributedString()

        let monthYearString = "\(paidMonth.month) \(paidMonth.year)"
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
        let regularFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]

        let totalAmountString = NSAttributedString(string: totalAmount, attributes: boldFontAttribute)
        let moneyString = NSAttributedString(string: "        Money: ", attributes: regularFontAttribute)
        
        attributedString.append(NSAttributedString(string: monthYearString, attributes: boldFontAttribute))
        attributedString.append(moneyString)
        attributedString.append(totalAmountString)

        cell.textLabel?.attributedText = attributedString
        
        cell.switchControl.isOn = paidMonth.isPaid // Установка состояния UISwitch
        
        // Установка значения tag для UISwitch
        cell.switchControl.tag = indexPath.row
        
        // Обработка изменений состояния UISwitch
        cell.switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // Установка стиля выделения ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    // Method to calculate total amount for a month
    func calculateTotalAmount(forMonth month: String, lessonPrice: LessonPrice) -> String {
        guard let lessons = lessonsForStudent[month] else {
            return "0" // No lessons for this month
        }
        
        // Преобразуем строку в Double для выполнения арифметических операций
        guard let price = Double(lessonPrice.price) else {
            return "Invalid price" // Если преобразование не удалось, возвращаем сообщение об ошибке
        }
        
        // Calculate total amount based on the number of lessons and the lesson price
        let lessonCount = lessons.count
        let totalAmount = Double(lessonCount) * price
        return String(format: "%.2f", totalAmount) // Format the total amount with 2 decimal places
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonth = paidMonths[indexPath.row].month
        
        // Создаем новый контроллер для отображения уроков выбранного месяца
        let monthLessonsVC = MonthLessonsViewController()
        
        let lessonPrice: String = "\(student?.lessonPrice.price ?? "0")"
        // Вместо student?.lessonPrice вы можете использовать прямое извлечение значения lessonPrice, так как вы уверены, что `student` не является nil на этом этапе. Это позволит избежать использования оператора `?`.

        // Передаем объект Student в MonthLessonsViewController
        monthLessonsVC.student = student
        monthLessonsVC.lessonPrice = lessonPrice // Передаем только цену урока без валюты
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.selectedYear = selectedYear
        monthLessonsVC.selectedSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
        monthLessonsVC.temporaryLessons = lessonsForStudent
        monthLessonsVC.delegate = self
        
        // Переходим к контроллеру с уроками выбранного месяца
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Confirm the deletion", message: "Are you sure you want to delete this month?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.deleteMonth(at: indexPath)
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
        changesMade = true
    }
    
//    func deleteMonth(at indexPath: IndexPath) {
//        paidMonths.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    func deleteMonth(at indexPath: IndexPath) {
        // Get the month to be deleted
        let monthToDelete = paidMonths[indexPath.row].month
        
        // Remove the paid month from the list
        paidMonths.remove(at: indexPath.row)
        
        // Remove the lessons for the deleted month
        student?.lessons[monthToDelete] = nil
        
        // Remove the lessons from the lessonsForStudent dictionary
        lessonsForStudent[monthToDelete] = nil
        
        // Check if there are no more months left and clear the selectedYear
            if paidMonths.isEmpty {
                selectedYear = ""
            }
        
        // Update the table view
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Switch Value Changed for PaidMonth
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        let index = sender.tag
        
        // Обновляем состояние в массиве данных
        paidMonths[index].isPaid = sender.isOn
        
        // Отладочный вывод
        print("Switch value changed at index \(index). New value isPaid: \(sender.isOn)")
        
        // Обновляем отображение ячейки
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        // Установка флага changesMade в true, так как были внесены изменения
        changesMade = true
    }
}
