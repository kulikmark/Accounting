//
//  StudentModel.swift
//  Accounting
//
//  Created by Марк Кулик on 18.04.2024.
//

import UIKit

class Student {
    
    var id: UUID // Уникальный идентификатор
    var name: String
    var imageForCell: UIImage?
    var phoneNumber: String
    var paidMonths: [PaidMonth]
    var lessons: [String: [Lesson]]
    var schedule: [Schedule]
    
    init(id: UUID = UUID(), name: String, phoneNumber: String, paidMonths: [PaidMonth], lessons: [String: [Lesson]], schedule: [Schedule], image: UIImage? = nil) {
          self.id = id
          self.name = name
          self.imageForCell = image
          self.phoneNumber = phoneNumber
          self.paidMonths = paidMonths
          self.lessons = lessons
          self.schedule = schedule
    }
}

// Создаем новый тип для представления расписания
struct Schedule {
    var weekday: String
    var time: String
}
// Создаем новый тип для представления оплаченного месяца
struct PaidMonth {
    var month: String
    var isPaid: Bool
}

// Создаем новый тип для представления уроков
struct Lesson: Codable {
    var date: String
    var attended: Bool
}
