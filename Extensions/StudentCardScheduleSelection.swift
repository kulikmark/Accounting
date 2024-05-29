//
//  StudentCardScheduleSelection.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//

import UIKit

// MARK: - Schedule Management

extension StudentCardViewController {
    
    // MARK: - Actions
    
    @objc func selectSchedule() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addScheduleAction = UIAlertAction(title: "Add a schedule", style: .default) { [weak self] _ in
            self?.showWeekdaysPicker()
        }
        actionSheet.addAction(addScheduleAction)
        
        switch editMode {
        case .add:
           if !selectedSchedules.isEmpty {
                let deleteAction = UIAlertAction(title: "Delete the schedule", style: .destructive) { [weak self] _ in
                    self?.showDeleteScheduleAlert()
                }
                actionSheet.addAction(deleteAction)
            }
        
        case .edit:
            if !(student?.schedule.isEmpty ?? true) || !selectedSchedules.isEmpty {
                let deleteAction = UIAlertAction(title: "Delete the schedule", style: .destructive) { [weak self] _ in
                    self?.showDeleteScheduleAlert()
                }
                actionSheet.addAction(deleteAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
        actionSheet.view.snp.makeConstraints { make in
            make.width.equalTo(400)
        }
    }

    func showWeekdaysPicker() {
        let weekdaysPickerController = UIAlertController(title: "Choose a day of the week", message: nil, preferredStyle: .actionSheet)
        
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        
        for weekday in weekdays {
            let action = UIAlertAction(title: weekday, style: .default) { [weak self] _ in
                self?.showTimesPicker(for: weekday)
            }
            weekdaysPickerController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        weekdaysPickerController.addAction(cancelAction)
        
        present(weekdaysPickerController, animated: true, completion: nil)
        
        weekdaysPickerController.view.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
            
        }
    }
    
    func showTimesPicker(for weekday: String) {
        // Создаем экземпляр UIDatePicker с типом .time
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        // Установим начальное время, например, 12:00
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        if let initialDate = calendar.date(from: components) {
            timePicker.setDate(initialDate, animated: false)
        }
        
        // Создаем UIAlertController
        let timesPickerController = UIAlertController(title: "Choose a time for \(weekday)", message: "", preferredStyle: .actionSheet)
        
        // Добавляем UIDatePicker в UIAlertController
        timesPickerController.view.addSubview(timePicker)
        
        // Создаем действия для выбора времени и отмены
        let selectAction = UIAlertAction(title: "Choose", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedTime = self.formatTime(timePicker.date)
            let newSchedule = (weekday: weekday, time: selectedTime)
            self.selectedSchedules.append(newSchedule)
            self.updateScheduleTextField()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Добавляем действия в UIAlertController
        timesPickerController.addAction(selectAction)
        timesPickerController.addAction(cancelAction)
        
        // Показываем UIAlertController
        present(timesPickerController, animated: true, completion: nil)
        
        timesPickerController.view.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        
        timePicker.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.top.equalTo(timesPickerController.view.snp.top).offset(30)
            make.leading.equalTo(timesPickerController.view.snp.leading)
            make.trailing.equalTo(timesPickerController.view.snp.trailing)
        }
    }
    
    // MARK: - Helper Methods
    
    // Обновление текстового поля с расписанием
    func updateScheduleTextField() {
        var scheduleStrings = [String]()
        
        switch editMode {
        case .add:
            scheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
        case .edit:
            let selectedScheduleStrings = selectedSchedules.map { "\($0.weekday) \($0.time)" }
            let studentScheduleStrings = student?.schedule.map { "\($0.weekday) \($0.time)" } ?? []
            scheduleStrings = studentScheduleStrings + selectedScheduleStrings
        }
        
        let scheduleText = scheduleStrings.joined(separator: ", ")
        scheduleTextField.text = scheduleText
    }

    
    func showDeleteScheduleAlert() {
        let alert = UIAlertController(title: "Select the day of the week and the time to delete", message: nil, preferredStyle: .actionSheet)
        
        switch editMode {
        case .add:
            for schedule in selectedSchedules {
                let action = UIAlertAction(title: "\(schedule.weekday) \(schedule.time)", style: .default) { [weak self] _ in
                    self?.removeSchedule(schedule.weekday, from: .add)
                }
                alert.addAction(action)
            }
        case .edit:
            // Преобразуем расписание ученика к формату [(weekday: String, time: String)]
            let studentSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
            
            // Объединяем выбранные пользователем расписания и расписание ученика
            let allSchedules = studentSchedules + selectedSchedules
            
            for schedule in allSchedules {
                let action = UIAlertAction(title: "\(schedule.0) \(schedule.1)", style: .default) { [weak self] _ in
                    self?.removeSchedule(schedule.0, from: .edit)
                }
                alert.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }


    func removeSchedule(_ schedule: String, from mode: EditMode) {
        switch mode {
        case .add:
            if let index = selectedSchedules.firstIndex(where: { $0.weekday == schedule }) {
                selectedSchedules.remove(at: index)
                updateScheduleTextField()
            }
        case .edit:
            if let index = selectedSchedules.firstIndex(where: { $0.weekday == schedule }) {
                selectedSchedules.remove(at: index)
                updateScheduleTextField()
            }
            if let index = student?.schedule.firstIndex(where: { $0.weekday == schedule }) {
                student?.schedule.remove(at: index)
                updateScheduleTextField()
            }
        }
    }

    // Метод для форматирования выбранного времени
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}