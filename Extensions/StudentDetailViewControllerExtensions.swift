//
//  StudentDetailViewControllerExtensions.swift
//  Accounting
//
//  Created by Марк Кулик on 24.04.2024.
//

import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paidMonths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let student = student else { return }
        guard indexPath.row < student.paidMonths.count else {
            // Обработка ошибки: индекс за пределами диапазона массива
            print("Ошибка: индекс за пределами диапазона массива оплаченных месяцев")
            return
        }
        
        let selectedMonth = student.paidMonths[indexPath.row].month
        
        let monthLessonsVC = MonthLessonsViewController()
        monthLessonsVC.lessons = student.lessons.filter { $0.date == selectedMonth }
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
    
    // MARK: - Table View Editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    // MARK: - Switch Value Changed
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? PaidMonthCell,
              let indexPath = paidMonthsTableView.indexPath(for: cell) else {
            return
        }
        
        // Обновляем состояние в массиве данных
        paidMonths[indexPath.row].isPaid = sender.isOn
    }
    
    // MARK: - Helper Methods
    
    private func deleteStudent(at indexPath: IndexPath) {
        // Удаление выбранного месяца из массива оплаченных месяцев
        paidMonths.remove(at: indexPath.row)
        
        // Удаление строки из таблицы с анимацией "fade"
        paidMonthsTableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - StudentDetailViewController

extension StudentDetailViewController {
    
    // MARK: - Actions
    
    @objc func selectSchedule() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addScheduleAction = UIAlertAction(title: "Добавить расписание", style: .default) { [weak self] _ in
            self?.showWeekdaysPicker()
        }
        actionSheet.addAction(addScheduleAction)
        
        if let student = student, !student.schedule.isEmpty {
            let deleteAction = UIAlertAction(title: "Удалить расписание", style: .destructive) { [weak self] _ in
                self?.showDeleteScheduleAlert()
            }
            actionSheet.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showWeekdaysPicker() {
        let weekdaysPickerController = UIAlertController(title: "Выберите день недели", message: nil, preferredStyle: .actionSheet)
        
        let weekdays = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]
        
        for weekday in weekdays {
            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
                self?.showTimesPicker(for: weekday)
            }
            weekdaysPickerController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        weekdaysPickerController.addAction(cancelAction)
        
        present(weekdaysPickerController, animated: true, completion: nil)
    }
    
    func showTimesPicker(for weekday: String) {
        let timesPickerController = UIAlertController(title: "Выберите время для \(weekday)", message: nil, preferredStyle: .actionSheet)
        
        let times = ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00"]
        
        for time in times {
            let action = UIAlertAction(title: time, style: .default) { [weak self] _ in
                self?.student?.schedule.append(Schedule(weekday: weekday, time: time))
                self?.updateScheduleTextField()
            }
            timesPickerController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        timesPickerController.addAction(cancelAction)
        
        present(timesPickerController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func updateScheduleTextField() {
        guard let student = student else {
            return // Расписание отсутствует, ничего не делаем
        }
        
        let scheduleStrings = student.schedule.map { "\($0.weekday) \($0.time)" }
        let scheduleString = scheduleStrings.joined(separator: ", ")
        scheduleTextField.text = scheduleString
    }
    
    func showDeleteScheduleAlert() {
        guard let schedules = student?.schedule else {
            // student?.schedule равно nil, поэтому нет необходимости отображать какие-либо действия
            return
        }
        
        let alert = UIAlertController(title: "Выберите день недели и время для удаления", message: nil, preferredStyle: .actionSheet)
        
        for schedule in schedules {
            let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
                // Преобразование объекта Schedule в кортеж (weekday: String, time: String)
                let scheduleTuple = (weekday: schedule.weekday, time: schedule.time)
                self?.removeSchedule(scheduleTuple)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func removeSchedule(_ schedule: (weekday: String, time: String)) {
        // Проверяем, есть ли у студента расписание
        guard let student = student else {
            return // Расписание отсутствует, ничего не делаем
        }
        
        // Ищем индекс расписания, которое нужно удалить
        if let index = student.schedule.firstIndex(where: { $0.weekday == schedule.weekday && $0.time == schedule.time }) {
            // Удаляем расписание из массива
            student.schedule.remove(at: index)
            
            // Обновляем текстовое поле с расписанием
            updateScheduleTextField()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension StudentDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            selectedImage = pickedImage.squareImage() // Обрезаем изображение до квадратного формата
            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
