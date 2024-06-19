//
//  HomeWorkTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 29.05.2024.
//


import UIKit
import Combine
import SnapKit

protocol HomeWorkTableViewControllerDelegate: AnyObject {
    func didUpdateStudent(_ student: Student)
}

extension HomeWorkTableViewController: DidUpdateStudentDelegate {
    func didUpdateStudent(_ updatedStudent: Student) {
        StudentStore.shared.updateStudent(updatedStudent)
        tableView.reloadData()
    }
}

class HomeWorkTableViewController: UITableViewController {
    private var cancellables = Set<AnyCancellable>()
    
    weak var delegate: HomeWorkTableViewControllerDelegate?
    
    var expandedIndexPaths = Set<IndexPath>()
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
    var lessonPrice: String = ""
    var changesMade = false
    var paidMonths = [Month]()
    var schedules = [Schedule]()
    var selectedSchedules = [(weekday: String, time: String)]()
    var lessonsForStudent: [Lesson] = []
    let addPaidMonthButton = UIButton(type: .system)
    let titleLabel = UILabel()
    var startScreenLabel: UILabel?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStartScreenLabel(with: "Add first student on the Students screen")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        self.title = "Homeworks List"
        setupStartScreenLabel(with: "Add first student \n\n On the Students screen")
        tableView.register(HomeWorkTableViewCell.self, forCellReuseIdentifier: "HomeWorkTableViewCell")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkTableViewCell", for: indexPath) as! HomeWorkTableViewCell
        
        let student = students[indexPath.row]
        let isExpanded = expandedIndexPaths.contains(indexPath)
        cell.configure(with: student, image: student.imageForCell, isExpanded: isExpanded, navigationController: navigationController)
        cell.updateLessonLabels()
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Если строка развёрнута, устанавливаем большую высоту
        if expandedIndexPaths.contains(indexPath) {
            return 380
        } else {
            // Используем UITableView.automaticDimension для автоматического вычисления высоты строки
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Устанавливаем приблизительную высоту строки
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if expandedIndexPaths.contains(indexPath) {
                expandedIndexPaths.remove(indexPath)
            } else {
                expandedIndexPaths.insert(indexPath)
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // Scroll to the selected cell if needed
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            
            // Reload the cell to update its content without flickering
            if let cell = tableView.cellForRow(at: indexPath) as? HomeWorkTableViewCell {
               
                cell.configure(with: cell.student!, image: cell.profileImageView.image, isExpanded: expandedIndexPaths.contains(indexPath), navigationController: navigationController)
                cell.updateLessonLabels()
            }
    }
}
