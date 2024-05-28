//
//  MonthLessonsViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 16.04.2024.
//

//import UIKit
//
//class MonthLessonsViewController: UIViewController {
//    var lessons: [Lesson] = [] // Список уроков для отображения
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Настройка UI
//        setupUI()
//    }
//    
//    func setupUI() {
//        // Добавляем таблицу для отображения уроков
//        let tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LessonCell")
//        view.addSubview(tableView)
//    }
//}
//
//extension MonthLessonsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return lessons.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath)
//        let lesson = lessons[indexPath.row]
//        cell.textLabel?.text = lesson.date
//        cell.detailTextLabel?.text = lesson.attended ? "Присутствовал" : "Отсутствовал"
//        return cell
//    }
//}
//
////    func updateUI() {
////        guard let student = student else { return }
////        nameLabel.text = "Имя: \(student.name)"
////        paidMonthsLabel.text = "Оплаченные месяцы: \(student.paidMonths.joined(separator: ", "))"
////        lessonsTableView.reloadData()
////    }
//    
//    //    // Функция для добавления нового занятия
//    //    func addLesson(date: String, attended: Bool) {
//    //        guard let student = student else { return }
//    //        student.lessons.append((date: date, attended: attended))
//    //        // Обновление UI
//    //        // ...
//    //    }
//    //
//    //    // Функция для редактирования занятия
//    //    func editLesson(at index: Int, newDate: String, newAttended: Bool) {
//    //        guard let student = student, student.lessons.indices.contains(index) else { return }
//    //        student.lessons[index] = (date: newDate, attended: newAttended)
//    //        // Обновление UI
//    //        // ...
//    //    }
//    //
//    //    // Функция для удаления занятия
//    //    func deleteLesson(at index: Int) {
//    //        guard let student = student, student.lessons.indices.contains(index) else { return }
//    //        student.lessons.remove(at: index)
//    //        // Обновление UI
//    //        // ...
//    //    }
