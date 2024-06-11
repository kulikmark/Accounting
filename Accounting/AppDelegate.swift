//
//  AppDelegate.swift
//  Accounting
//
//  Created by Марк Кулик on 13.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Создаем тестовое расписание для ученика
            let testSchedule1 = [
                Schedule(weekday: "WED", time: "12:00")
            ]
        
        let testSchedule2 = [
            Schedule(weekday: "WED", time: "12:00")
        ]
        
        let lessonPrice = LessonPrice(price: "100", currency: "GBP")
        
        let paidMonth = [PaidMonth(year: "2024", month: "June", isPaid: true),
            PaidMonth(year: "2024", month: "July", isPaid: false),
        PaidMonth(year: "2024", month: "August", isPaid: false),
                         PaidMonth(year: "2024", month: "September", isPaid: false),
                         PaidMonth(year: "2024", month: "October", isPaid: false),
                         PaidMonth(year: "2024", month: "November", isPaid: false),
                         PaidMonth(year: "2024", month: "December", isPaid: false)]
        
//        let lesson = Lesson(date: "2024.06.05", attended: false, homework: "HW")
            
            // Создаем тестового ученика с этим расписанием
            let testStudent = Student(
                id: UUID(),
                name: "Harry Potter",
                parentName: "Petunia Dursley",
                phoneNumber: "+44-7871256566",
                paidMonths: paidMonth,
                lessonPrice: lessonPrice,
                lessons: [:],
                schedule: testSchedule1,
                type: .schoolchild,
                image: UIImage(named: "harry")?.squareImage()
            )
        
        // Создаем тестового ученика с этим расписанием
        let testStudent2 = Student(
            id: UUID(),
            name: "Ron Weasley",
            parentName: "Molly Weasley",
            phoneNumber: "+44-7871234567",
            paidMonths: [],
            lessonPrice: lessonPrice,
            lessons: [:],
            schedule: testSchedule2,
            type: .schoolchild,
            image: UIImage(named: "ron")?.squareImage()
        )
        
        // Создаем тестового ученика с этим расписанием
        let testStudent3 = Student(
            id: UUID(),
            name: "Hermione Granger",
            parentName: "",
            phoneNumber: "+44-7871234231",
            paidMonths: [],
            lessonPrice: lessonPrice,
            lessons: [:],
            schedule: [],
            type: .schoolchild,
            image: UIImage(named: "hermione")?.squareImage()
        )
            
        // Добавляем тестового ученика в модель данных
           StudentStore.shared.addStudent(testStudent)
        StudentStore.shared.addStudent(testStudent2)
        StudentStore.shared.addStudent(testStudent3)
        
        // Возвращаемое значение true означает успешное завершение метода didFinishLaunchingWithOptions
        return true
    }
}

