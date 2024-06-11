//
//  StudentModel.swift
//  Accounting
//
//  Created by Марк Кулик on 18.04.2024.
//

import UIKit

enum StudentType: String, Codable {
    case schoolchild = "Schoolchild"
    case adult = "Adult"
}

class Student {
    static var students = [Student]()

    var id: UUID
    var name: String
    var parentName: String
    var imageForCell: UIImage?
    var phoneNumber: String
    var paidMonths: [PaidMonth]
    var lessonPrice: LessonPrice
    var lessons: [String: [Lesson]]
    var schedule: [Schedule]
    var type: StudentType // New property

    init(id: UUID = UUID(),
         name: String,
         parentName: String,
         phoneNumber: String,
         paidMonths: [PaidMonth],
         lessonPrice: LessonPrice,
         lessons: [String: [Lesson]],
         schedule: [Schedule],
         type: StudentType,
         image: UIImage? = nil) {

        self.id = id
        self.name = name
        self.parentName = parentName
        self.imageForCell = image
        self.phoneNumber = phoneNumber
        self.paidMonths = paidMonths
        self.lessonPrice = lessonPrice
        self.lessons = lessons
        self.schedule = schedule
        self.type = type
    }
}

struct Schedule {
    var weekday: String
    var time: String
}

struct PaidMonth {
    var year: String
    var month: String
    var isPaid: Bool
}

struct LessonPrice {
    var price: String
    var currency: String
}

struct Lesson: Codable {
    var date: String
    var attended: Bool
    var homework: String?
}
