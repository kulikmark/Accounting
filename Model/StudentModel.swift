//
//  StudentModel.swift
//  Accounting
//
//  Created by Марк Кулик on 18.04.2024.
//

import UIKit

class Student {
    
    var id: UUID
    var name: String
    var imageForCell: UIImage?
    var phoneNumber: String
    var paidMonths: [PaidMonth]
    var lessonPrice: String
    var lessons: [String: [Lesson]]
    var schedule: [Schedule]
    
    init(id: UUID = UUID(),
         name: String,
         phoneNumber: String,
         paidMonths: [PaidMonth],
         lessonPrice: String,
         lessons: [String: [Lesson]],
         schedule: [Schedule],
         image: UIImage? = nil) {
        
        self.id = id
        self.name = name
        self.imageForCell = image
        self.phoneNumber = phoneNumber
        self.paidMonths = paidMonths
        self.lessonPrice = lessonPrice
        self.lessons = lessons
        self.schedule = schedule
    }
}


struct Schedule {
    var weekday: String
    var time: String
}

struct PaidMonth {
    var month: String
    var isPaid: Bool
}


struct Lesson: Codable {
    var date: String
    var attended: Bool
}
