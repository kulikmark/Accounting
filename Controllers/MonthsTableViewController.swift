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

// MARK: - StudentAddingViewController TableView

class MonthsTableViewController: UITableViewController, MonthLessonsDelegate {
    
    var student: Student?
    var paidMonths = [PaidMonth]()
    
    var schedules = [Schedule]()
    var existingSchedules: [String] = []
    var selectedSchedules = [(weekday: String, time: String)]()
    
    var lessonsForStudent: [String: [Lesson]] = [:]
    
    let paidMonthsLabel = UILabel()
    let paidMonthsTableView = UITableView()
    let addPaidMonthButton = UIButton(type: .system)
    
    // MARK: - View Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        paidMonthsTableView.separatorStyle = .singleLine
        paidMonthsTableView.separatorColor = UIColor.lightGray // Установите желаемый цвет разделителя
        paidMonthsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Выполните операции с UITableView здесь
        paidMonthsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //        updateUI()
        
        view.backgroundColor = .white
        
        //        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        //        navigationItem.rightBarButtonItem = saveButton
        
        paidMonthsTableView.register(PaidMonthCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
        //        print("selectedschedules \(selectedSchedules)")
        //        print("massive schedules \(schedules)")
        //        print("student?.schedule \(student?.schedule)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paidMonths.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath) as! PaidMonthCell
        
        let paidMonth = paidMonths[indexPath.row]
        cell.textLabel?.text = paidMonth.month
        cell.switchControl.isOn = paidMonth.isPaid // Установка состояния UISwitch
        
        // Обработка изменений состояния UISwitch
        cell.switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // Установка стиля выделения ячейки
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonth = paidMonths[indexPath.row].month
        
        // Получаем текущее значение isPaid для выбранного месяца
        let isMonthPaid = paidMonths[indexPath.row].isPaid
        
        //        if student == nil {
        //            // Создаем новый объект Student, передавая необходимые параметры
        //            student = Student(name: studentNameTextField.text ?? "", phoneNumber: phoneTextField.text ?? "", paidMonths: [PaidMonth(month: selectedMonth, isPaid: isMonthPaid)], lessons: [:], schedule: [], image: nil)
        //        }
        
        // Создаем новый контроллер для отображения уроков выбранного месяца
        let monthLessonsVC = MonthLessonsViewController()
        
        // Передаем объект Student в MonthLessonsViewController
        monthLessonsVC.student = student
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.selectedSchedules = selectedSchedules
        monthLessonsVC.temporaryLessons = lessonsForStudent
        monthLessonsVC.delegate = self
        
        print("Navigating to MonthLessonsViewController")
        
        // Переходим к контроллеру с уроками выбранного месяца
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить этот месяц?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                self?.deleteMonth(at: indexPath)
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteMonth(at indexPath: IndexPath) {
        paidMonths.remove(at: indexPath.row)
        paidMonthsTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Switch Value Changed for PaidMonth
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? PaidMonthCell,
              let indexPath = paidMonthsTableView.indexPath(for: cell) else {
            return
        }
        
        // Обновляем состояние в массиве данных
        paidMonths[indexPath.row].isPaid = sender.isOn
        
        // Отладочный вывод
        print("Switch value changed at index \(indexPath.row). New value isPaid: \(sender.isOn)")
        
        // Обновляем отображение ячейки
        paidMonthsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension MonthsTableViewController {
    
    // MARK: - UI Setup
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        //        // Paid Months Label
        //        view.addSubview(paidMonthsLabel)
        //        paidMonthsLabel.snp.makeConstraints { make in
        //            make.top.equalTo(scheduleTextField.snp.bottom).offset(20)
        //            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        //        }
        //        paidMonthsLabel.text = "Оплаченные месяцы:"
        
        // Paid Months Table
        view.addSubview(paidMonthsTableView)
        paidMonthsTableView.snp.makeConstraints { make in
            make.top.equalTo(paidMonthsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        
        // Add Paid Month Button
        view.addSubview(addPaidMonthButton)
        addPaidMonthButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        addPaidMonthButton.setTitle("Добавить месяц", for: .normal)
        addPaidMonthButton.layer.cornerRadius = 10
        addPaidMonthButton.setTitleColor(.white, for: .normal)
        addPaidMonthButton.backgroundColor = .systemBlue
        addPaidMonthButton.addTarget(self, action: #selector(addPaidMonthButtonTapped), for: .touchUpInside)
        
        // Настройка таблицы оплаченных месяцев
        paidMonthsTableView.dataSource = self
        paidMonthsTableView.delegate = self
        paidMonthsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaidMonthCell")
        
    }
    
    @objc func addPaidMonthButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        for month in ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"] {
            alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
                self?.addPaidMonth(month)
            }))
        }
        
        present(alertController, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func addPaidMonth(_ month: String) {
        print("Adding month: \(month)")
        let paidMonth = PaidMonth(month: month, isPaid: false)
        paidMonths.append(paidMonth)
        
        print("Месяц добавился в массив\(paidMonths)")
        
        // Проверяем, есть ли уроки для этого месяца в словаре lessonsForNewStudent
        if lessonsForStudent[month] == nil {
            // Если уроки для этого месяца еще не созданы, добавляем пустой массив уроков
            lessonsForStudent[month] = []
        }
        
        // Вставляем новую строку в таблицу и обновляем UI
        let indexPath = IndexPath(row: paidMonths.count - 1, section: 0)
        paidMonthsTableView.insertRows(at: [indexPath], with: .automatic)
        updateUI()
    }
    
    func updateUI() {
        paidMonthsTableView.reloadData()
    }
}
