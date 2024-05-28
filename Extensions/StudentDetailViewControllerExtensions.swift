////
////  StudentDetailViewControllerExtensions.swift
////  Accounting
////
////  Created by Марк Кулик on 24.04.2024.
////
//
//import UIKit
//
//// MARK: - StudentDetailViewController TableView
//
//extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return paidMonths.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath) as! PaidMonthCell
//        
//        let paidMonth = paidMonths[indexPath.row]
//        cell.textLabel?.text = paidMonth.month
//        cell.switchControl.isOn = paidMonth.isPaid // Установка состояния UISwitch
//        
//        // Обработка изменений состояния UISwitch
//        cell.switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
//        
//        // Установка стиля выделения ячейки
//        cell.selectionStyle = .none
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        guard let student = student else { return }
////        guard indexPath.row < student.paidMonths.count else {
////            // Обработка ошибки: индекс за пределами диапазона массива
////            print("Ошибка: индекс за пределами диапазона массива оплаченных месяцев")
////            return
////        }
////        let monthLessonsVC = MonthLessonsViewController()
//        
////        let selectedMonth = student.paidMonths[indexPath.row].month
////        monthLessonsVC.temporaryLessons = student.lessons.filter { $0.date == selectedMonth }
//        
//        let selectedMonth = paidMonths[indexPath.row].month
//        
//        // Создаем новый контроллер для отображения уроков выбранного месяца
//        let monthLessonsVC = MonthLessonsViewController()
//        
//        // Передаем объект Student в MonthLessonsViewController
//        monthLessonsVC.student = student
//        monthLessonsVC.selectedMonth = selectedMonth
//        monthLessonsVC.selectedSchedules = selectedSchedules
//        monthLessonsVC.temporaryLessons = lessonsForStudent
////        monthLessonsVC.delegate = self
//        
//        navigationController?.pushViewController(monthLessonsVC, animated: true)
//    }
//    
//    // MARK: - Table View Editing
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let alertController = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить этого ученика?", preferredStyle: .alert)
//            
//            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
//                self?.deleteMonth(at: indexPath)
//            }
//            alertController.addAction(deleteAction)
//            
//            present(alertController, animated: true, completion: nil)
//        }
//    }
//    
//    // MARK: - Switch Value Changed for PaidMonth
//    
//    @objc func switchValueChanged(_ sender: UISwitch) {
//        guard let cell = sender.superview?.superview as? PaidMonthCell,
//              let indexPath = paidMonthsTableView.indexPath(for: cell) else {
//            return
//        }
//        
//        // Обновляем состояние в массиве данных
//        paidMonths[indexPath.row].isPaid = sender.isOn
//    }
//    
//    // MARK: - Helper Methods
//    
//     func deleteMonth(at indexPath: IndexPath) {
//        // Удаление выбранного месяца из массива оплаченных месяцев
//        paidMonths.remove(at: indexPath.row)
//        
//        // Удаление строки из таблицы с анимацией "fade"
//        paidMonthsTableView.deleteRows(at: [indexPath], with: .fade)
//    }
//}
//
//// MARK: - StudentDetailViewController Select Schedule
//
//extension StudentDetailViewController {
//    
//    
//    // MARK: - Actions
//    
//    @objc func selectSchedule() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let addScheduleAction = UIAlertAction(title: "Добавить расписание", style: .default) { [weak self] _ in
//            self?.showWeekdaysPicker()
//        }
//        actionSheet.addAction(addScheduleAction)
//        
//        if !selectedSchedules.isEmpty {
//            let deleteAction = UIAlertAction(title: "Удалить расписание", style: .destructive) { [weak self] _ in
//                self?.showDeleteScheduleAlert()
//            }
//            actionSheet.addAction(deleteAction)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        actionSheet.addAction(cancelAction)
//        
//        present(actionSheet, animated: true, completion: nil)
//    }
//
//     func showWeekdaysPicker() {
//        let weekdaysPickerController = UIAlertController(title: "Выберите день недели", message: nil, preferredStyle: .actionSheet)
//        
//        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
//        
//        for weekday in weekdays {
//            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
//                self?.showTimesPicker(for: weekday)
//            }
//            weekdaysPickerController.addAction(action)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        weekdaysPickerController.addAction(cancelAction)
//        
//        present(weekdaysPickerController, animated: true, completion: nil)
//    }
//    
//    func showTimesPicker(for weekday: String) {
//        // Создаем экземпляр UIDatePicker с типом .time
//        let timePicker = UIDatePicker()
//        timePicker.datePickerMode = .time
//        
//        // Создаем UIAlertController
//        let timesPickerController = UIAlertController(title: "Выберите время для \(weekday)", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
//        
//        // Добавляем UIDatePicker в UIAlertController
//        timesPickerController.view.addSubview(timePicker)
//        
//        // Создаем действия для выбора времени и отмены
//        let selectAction = UIAlertAction(title: "Выбрать", style: .default) { [weak self] _ in
//            let selectedTime = self?.formatTime(timePicker.date)
//            self?.selectedSchedules.append((weekday: weekday, time: selectedTime ?? ""))
//            self?.updateScheduleTextField()
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        
//        // Добавляем действия в UIAlertController
//        timesPickerController.addAction(selectAction)
//        timesPickerController.addAction(cancelAction)
//        
//        // Показываем UIAlertController
//        present(timesPickerController, animated: true, completion: nil)
//    }
//
//    // MARK: - Helper Methods
//
//     func updateScheduleTextField() {
//        let scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
//        let scheduleString = scheduleStrings.joined(separator: ", ")
//        scheduleTextField.text = scheduleString
//    }
//    
//     func showDeleteScheduleAlert() {
//        let alert = UIAlertController(title: "Выберите день недели и время для удаления", message: nil, preferredStyle: .actionSheet)
//        
//        for schedule in selectedSchedules {
//            let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
//                self?.removeSchedule(schedule)
//            }
//            alert.addAction(action)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//
//     func removeSchedule(_ schedule: (weekday: String, time: String)) {
//        if let index = selectedSchedules.firstIndex(where: { $0 == schedule }) {
//            selectedSchedules.remove(at: index)
//            updateScheduleTextField()
//        }
//    }
//    
//    // Метод для форматирования выбранного времени
//    func formatTime(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        return dateFormatter.string(from: date)
//    }
//}
//
//// MARK: - func imagePickerController
//
//extension StudentDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[.originalImage] as? UIImage {
//            selectedImage = pickedImage
//            selectedImage = pickedImage.squareImage() // Обрезаем изображение до квадратного формата
//            imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        dismiss(animated: true, completion: nil)
//    }
//}
//
////extension StudentDetailViewController: MonthLessonsDelegate {
////    func didUpdateStudentLessons(_ lessonsMassive: [Lesson]) {
////        lessonsForStudent = lessonsMassive
////    }
////}
