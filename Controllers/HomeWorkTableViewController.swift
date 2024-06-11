//
//  HomeWorkTableViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 29.05.2024.
//


import UIKit
import SnapKit

protocol HomeWorkTableViewControllerDelegate: AnyObject {
    func didUpdateStudent(_ student: Student, selectedYear: String)
}

extension HomeWorkTableViewController: MonthsTableViewControllerDelegate {
    func didUpdateStudent(_ updatedStudent: Student, selectedYear: String) {
        StudentStore.shared.updateStudent(updatedStudent)
        self.selectedYear = selectedYear
        tableView.reloadData()
    }
}

class HomeWorkTableViewController: UITableViewController {
    
    weak var delegate: HomeWorkTableViewControllerDelegate?
    
    var expandedIndexPaths = Set<IndexPath>()
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
    var lessonPrice: String = ""
    var changesMade = false
    var paidMonths = [PaidMonth]()
    var schedules = [Schedule]()
    var selectedYear: String = ""
    var selectedSchedules = [(weekday: String, time: String)]()
    var lessonsForStudent: [String: [Lesson]] = [:]
    let addPaidMonthButton = UIButton(type: .system)
    let titleLabel = UILabel()
    var startScreenLabel: UILabel?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        
        // Выполните операции с UITableView здесь
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        
        setupTitleLabel()
        tableView.register(HomeWorkTableViewCell.self, forCellReuseIdentifier: "HomeWorkTableViewCell")
        setupTableView()
        setupStartScreenLabel()
        updateStartScreenLabelVisibility()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "Homeworks List"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupStartScreenLabel() {
        startScreenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        startScreenLabel?.text = "Add first student \n\n On the Students screen"
        startScreenLabel?.font = UIFont.systemFont(ofSize: 20)
        startScreenLabel?.textColor = .lightGray
        startScreenLabel?.textAlignment = .center
        startScreenLabel?.numberOfLines = 0
        tableView.backgroundView = startScreenLabel
    }
    
    private func updateStartScreenLabelVisibility() {
        startScreenLabel?.isHidden = !students.isEmpty
        tableView.separatorStyle = students.isEmpty ? .none : .singleLine
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 380 : 100
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
            }
    }
}
