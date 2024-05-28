////
////  SchedulePicker.swift
////  Accounting
////
////  Created by Марк Кулик on 29.04.2024.
////
//
//import UIKit
//
//// MARK: - StudentAddingViewController
//
//extension StudentCardViewController {
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
//        
////        existingSchedules = scheduleTextField.text?.components(separatedBy: ", ") ?? []
//        
//        actionSheet.view.snp.makeConstraints { make in
//            make.width.equalTo(400)
//            
//        }
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
//         
//         weekdaysPickerController.view.snp.makeConstraints { make in
//             make.width.equalTo(400)
//             make.height.equalTo(300)
//             
//         }
//    }
//    
//        func showTimesPicker(for weekday: String) {
//            // Создаем экземпляр UIDatePicker с типом .time
//            let timePicker = UIDatePicker()
//            timePicker.datePickerMode = .time
//            timePicker.preferredDatePickerStyle = .wheels
//            
//            // Установим начальное время, например, 12:00
//                let calendar = Calendar.current
//                var components = DateComponents()
//                components.hour = 12
//                components.minute = 0
//                if let initialDate = calendar.date(from: components) {
//                    timePicker.setDate(initialDate, animated: false)
//                }
//            
//            // Создаем UIAlertController
//            let timesPickerController = UIAlertController(title: "Выберите время для \(weekday)", message: "", preferredStyle: .actionSheet)
//            
//            // Добавляем UIDatePicker в UIAlertController
//            timesPickerController.view.addSubview(timePicker)
//            
//            // Создаем действия для выбора времени и отмены
//            let selectAction = UIAlertAction(title: "Выбрать", style: .default) { [weak self] _ in
//                    guard let self = self else { return }
//                    let selectedTime = self.formatTime(timePicker.date)
////                    self.addSchedule(weekday, selectedTime) // Добавляем новое расписание
//                let newSchedule = (weekday: weekday, time: selectedTime)
//                   self.selectedSchedules.append(newSchedule)
//                
//                print("self.selectedSchedules.append(newSchedule) \(newSchedule)")
//                }
//            
//            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//            
//            // Добавляем действия в UIAlertController
//            timesPickerController.addAction(selectAction)
//            timesPickerController.addAction(cancelAction)
//            
//            // Показываем UIAlertController
//            present(timesPickerController, animated: true, completion: nil)
//            
//            timesPickerController.view.snp.makeConstraints { make in
//                make.width.equalTo(400)
//                make.height.equalTo(300)
//            }
//            
//            timePicker.snp.makeConstraints { make in
//                make.height.equalTo(160)
//                make.top.equalTo(timesPickerController.view.snp.top).offset(30)
//                make.leading.equalTo(timesPickerController.view.snp.leading)
//                make.trailing.equalTo(timesPickerController.view.snp.trailing)
//            }
//        }
//
//    // MARK: - Helper Methods
//    
//    // Добавление нового расписания
//    func addSchedule(_ weekday: String, _ time: String) {
//        let newSchedule = "\(weekday) \(time)"
//        existingSchedules.append(newSchedule)
//        
//        // Добавляем новое расписание в массив выбранных расписаний
//            selectedSchedules.append((weekday: weekday, time: time))
//        
//        updateScheduleTextField()
//        
//        print("newSchedule in  func addSchedule \(newSchedule)")
//        print("existingSchedules in  func addSchedule \(existingSchedules)")
//        print("selectedSchedules in  func addSchedule \(selectedSchedules)")
//    }
//
//    // Обновление текстового поля с расписанием
//    func updateScheduleTextField() {
//        // Создаем массив строк из student?.schedule, представляя каждый элемент в формате "день недели время"
//        let studentScheduleStrings = student?.schedule.map { "\($0.weekday) \($0.time)" } ?? []
//        
//        // Создаем массив строк из selectedSchedules, представляя каждый элемент в формате "день недели время"
//        let selectedScheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
//        
//        // Объединяем оба массива строк
//        let allScheduleStrings = studentScheduleStrings + selectedScheduleStrings
//        
//        // Объединяем строки в одну с использованием разделителя ", "
//        let scheduleText = allScheduleStrings.joined(separator: ", ")
//        
//        // Устанавливаем полученную строку в качестве текста для scheduleTextField
//        scheduleTextField.text = scheduleText
//    }
//    
//    func showDeleteScheduleAlert() {
//        let alert = UIAlertController(title: "Выберите день недели и время для удаления", message: nil, preferredStyle: .actionSheet)
//        
//        for schedule in existingSchedules {
//            let action = UIAlertAction(title: schedule, style: .default) { [weak self] _ in
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
//    func removeSchedule(_ schedule: String) {
//        if let index = existingSchedules.firstIndex(of: schedule) {
//            existingSchedules.remove(at: index)
//            updateScheduleTextField()
//        }
//    }
//
//    
//    // Метод для форматирования выбранного времени
//    func formatTime(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        return dateFormatter.string(from: date)
//    }
//}
