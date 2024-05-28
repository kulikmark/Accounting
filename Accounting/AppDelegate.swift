//
//  AppDelegate.swift
//  Accounting
//
//  Created by Марк Кулик on 13.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var students = [Student]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Создание окна
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Создание экземпляра StudentsTableViewController
        let studentsTableViewController = StudentsTableViewController()
        studentsTableViewController.students = students
        
//        // Передача массива учеников из UserDefaults в StudentsTableViewController
//        studentsTableViewController.loadData()
        
        // Назначение StudentsTableViewController корневым контроллером
        window?.rootViewController = studentsTableViewController
        
        // Отображение окна
        window?.makeKeyAndVisible()
        
        // Возвращаемое значение true означает успешное завершение метода didFinishLaunchingWithOptions
        return true
    }
    
    func updateStudents(_ updatedStudents: [Student]) {
        students = updatedStudents
    }

//    func applicationWillTerminate(_ application: UIApplication) {
//        saveStudents()
//    }

//    private func saveStudents() {
//        saveData(students, forKey: "students")
//    }

    private func saveData<T: Encodable>(_ data: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            print("Ошибка при сохранении данных:", error.localizedDescription)
        }
    }
}
