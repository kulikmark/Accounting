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
        

        let lessonPrice = LessonPrice(price: 100.0, currency: "GBP")
        
        let months = [Month(monthName: "June", monthYear: "2024", isPaid: false, lessonPrice: lessonPrice, lessons: []),
        Month(monthName: "July", monthYear: "2024", isPaid: false, lessonPrice: lessonPrice, lessons: []),
        Month(monthName: "August", monthYear: "2024", isPaid: false, lessonPrice: lessonPrice, lessons: []),
        Month(monthName: "September", monthYear: "2024", isPaid: false, lessonPrice: lessonPrice, lessons: [])]
//
//        // Создаем массив уроков для конкретного месяца (например, июнь 2024 года)
//                let lessons = [
//                    Lesson(date: "05.06.2024", attended: false, homework: "HW", photoUrls: [])
//                    // Добавьте URL для фотографий, если они есть
//                ]
            
            // Создаем тестового ученика с этим расписанием
            let testStudent = Student(
                id: UUID(),
                name: "Harry Potter",
                parentName: "Petunia Dursley",
                phoneNumber: "+44-7871256566",
                months: months,
                lessons: [],
                lessonPrice: lessonPrice,
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
            months: [],
            lessons: [],
            lessonPrice: lessonPrice,
            schedule: testSchedule1,
            type: .schoolchild,
            image: UIImage(named: "ron")?.squareImage()
        )
//        
//        // Создаем тестового ученика с этим расписанием
//        let testStudent3 = Student(
//            id: UUID(),
//            name: "Hermione Granger",
//            parentName: "",
//            phoneNumber: "+44-7871234231",
//            paidMonths: [],
//            lessons: [], 
//            lessonPrice: lessonPrice,
//            schedule: [],
//            type: .schoolchild,
//            image: UIImage(named: "hermione")?.squareImage()
//        )
            
        // Добавляем тестового ученика в модель данных
           StudentStore.shared.addStudent(testStudent)
        StudentStore.shared.addStudent(testStudent2)
//        StudentStore.shared.addStudent(testStudent3)
        
        // Возвращаемое значение true означает успешное завершение метода didFinishLaunchingWithOptions
        return true
    }
}

