
//  HomeWorkTableViewCell.swift
//  Accounting
//  Created by Марк Кулик on 07.06.2024.


import UIKit
import SnapKit

class HomeWorkTableViewCell: UITableViewCell, DidUpdateStudentDelegate {
    func didUpdateStudent(_ student: Student) {
        StudentStore.shared.updateStudent(student)
        configure(with: student, image: profileImageView.image, isExpanded: isExpanded, navigationController: navigationController)
        innerTableView.reloadData()
    }
    
    
    weak var navigationController: UINavigationController?
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
    var lessonPrice: String = ""
    var selectedYear: String = ""
    var months = [Month]()
    var selectedMonth: Month?
    var lessonsForStudent: [Lesson] = []
    
    var isExpanded: Bool = false {
        didSet {
            innerTableView.isHidden = !isExpanded
            innerTableView.reloadData()
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var studentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var innerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        return tableView
    }()
    
    lazy var attendedLessonsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var missedLessonsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var homeworkCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2.0
        profileImageView.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        // Добавляем контейнер
        contentView.addSubview(containerView)
        
        // Добавляем элементы в containerView
        containerView.addSubview(profileImageView)
        containerView.addSubview(studentNameLabel)
        containerView.addSubview(innerTableView)
        containerView.addSubview(attendedLessonsLabel)
        containerView.addSubview(missedLessonsLabel)
        containerView.addSubview(homeworkCountLabel)
        
        // Регистрация кастомной ячейки
        innerTableView.register(HomeWorkPaidMonthsCell.self, forCellReuseIdentifier: "HomeWorkPaidMonthsCell")
        
        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(profileImageView.snp.width)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        studentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(23)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        attendedLessonsLabel.snp.makeConstraints { make in
            make.top.equalTo(studentNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(studentNameLabel)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        missedLessonsLabel.snp.makeConstraints { make in
            make.top.equalTo(attendedLessonsLabel.snp.bottom).offset(5)
            make.leading.equalTo(attendedLessonsLabel)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        homeworkCountLabel.snp.makeConstraints { make in
            make.top.equalTo(missedLessonsLabel.snp.bottom).offset(5)
            make.leading.equalTo(missedLessonsLabel)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        innerTableView.snp.makeConstraints { make in
            make.top.equalTo(homeworkCountLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(containerView).offset(-10)
            make.trailing.equalTo(containerView).offset(-10)
            //                make.centerX.equalTo(containerView)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with student: Student, image: UIImage?, isExpanded: Bool, navigationController: UINavigationController?) {
        
        self.student = student
        self.months = student.months
        self.navigationController = navigationController
        
        if let profileImage = image {
            profileImageView.image = profileImage
        } else if let studentImage = student.imageForCell {
            profileImageView.image = studentImage
        } else {
            profileImageView.image = UIImage(named: "icon")
        }
        
        studentNameLabel.text = student.name
        
        innerTableView.isHidden = !isExpanded // Обновляем видимость внутренней таблицы
        
        self.isExpanded = isExpanded // Устанавливаем состояние isExpanded
        
//        let attendedLessons = selectedMonth?.lessons.filter { $0.attended }.count
//        let missedLessons = selectedMonth?.lessons.filter { !$0.attended }.count
//        let homeworkCount = selectedMonth?.lessons.filter { $0.homework != nil }.count
        let attendedLessons = student.months.flatMap { $0.lessons }.filter { $0.attended }.count
            let missedLessons = student.months.flatMap { $0.lessons }.filter { !$0.attended }.count
        let homeworkCount = student.months.flatMap { $0.lessons }.filter { $0.homework != nil && !$0.homework!.isEmpty }.count
        
        attendedLessonsLabel.text = "Lessons attended: \(attendedLessons)"
        missedLessonsLabel.text = "Lessons missed: \(missedLessons)"
        homeworkCountLabel.text = "Homeworks counting: \(homeworkCount)"
        
        innerTableView.reloadData()
    }
    
    func updateLessonLabels() {
        let attendedLessons = student?.months.flatMap { $0.lessons }.filter { $0.attended }.count ?? 0
        let missedLessons = student?.months.flatMap { $0.lessons }.filter { !$0.attended }.count ?? 0
        let homeworkCount = student?.months.flatMap { $0.lessons }.filter { $0.homework != nil }.count ?? 0
        
        attendedLessonsLabel.text = "Lessons attended: \(attendedLessons)"
        missedLessonsLabel.text = "Lessons missed: \(missedLessons)"
        homeworkCountLabel.text = "Homeworks counting: \(homeworkCount)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Добавляем делегаты для внутренней таблицы
extension HomeWorkTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращаем количество месяцев или 1, если месяцев нет
        return max(student?.months.count ?? 0, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkPaidMonthsCell", for: indexPath) as! HomeWorkPaidMonthsCell
        
        if student?.months.isEmpty ?? true {
            cell.monthLabel.text = "There are no added Months"
            cell.paidStatusLabel.text = ""
        } else {
            let month = student?.months[indexPath.row]
            cell.configure(with: student!, selectedMonth: month?.monthName ?? "")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let months = student?.months, indexPath.row < months.count else {
               // Handle case where the array is empty or index is out of range
               return
           }
        selectedMonth = student?.months[indexPath.row]
        showMonthLessons(for: selectedMonth!)
    }
    
    private func showMonthLessons(for selectedMonth: Month) {
        let monthLessonsVC = MonthLessonsViewController()
        let lessonPrice = student?.lessonPrice.price ?? 0.0
        monthLessonsVC.student = student
        monthLessonsVC.lessonPrice = lessonPrice
        monthLessonsVC.selectedSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.lessonsForStudent = selectedMonth.lessons
        monthLessonsVC.delegate = self
        navigationController?.pushViewController(monthLessonsVC, animated: true)
    }
}
