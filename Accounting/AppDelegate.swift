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
//        // Создание окна
//        window = UIWindow(frame: UIScreen.main.bounds)
//        
//        // Создание экземпляра StudentsTableViewController и MonthsTableViewController
//        let studentsTableViewController = StudentsTableViewController()
//        let monthsTableViewController = MonthsTableViewController()
//        
//        // Оберните их в UINavigationController
//        let studentsNavController = UINavigationController(rootViewController: studentsTableViewController)
//        let monthsNavController = UINavigationController(rootViewController: monthsTableViewController)
//        
//        // Создайте UITabBarController и добавьте в него UINavigationController'ы
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [studentsNavController, monthsNavController]
//        
//        // Настройте табы
//        studentsNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//        monthsNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
//        
//        // Назначение UITabBarController корневым контроллером
//        window?.rootViewController = tabBarController
//        
//        // Отображение окна
//        window?.makeKeyAndVisible()
        
        // Возвращаемое значение true означает успешное завершение метода didFinishLaunchingWithOptions
        return true
    }
}

