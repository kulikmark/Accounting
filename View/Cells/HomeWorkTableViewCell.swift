
//  HomeWorkTableViewCell.swift
//  Accounting
//  Created by Марк Кулик on 07.06.2024.

import UIKit
import SnapKit

class HomeWorkTableViewCell: UITableViewCell, DidUpdateStudentDelegate {
    func didUpdateStudent(_ student: Student) {
        StudentStore.shared.updateStudent(student)
    }
    
   
    weak var navigationController: UINavigationController?
    var student: Student?
    var students: [Student] {
        return StudentStore.shared.students
    }
        var lessonPrice: String = ""
        var selectedYear: String = ""
        var paidMonths = [Month]()
        var lessonsForStudent: [Lesson] = []

        var isExpanded: Bool = false {
            didSet {
                innerTableView.isHidden = !isExpanded
                innerTableView.reloadData()
            }
        }
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.bounds.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 4
        return imageView
    }()
    
    lazy var studentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    // Добавляем UITableView
    lazy var innerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InnerCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        return tableView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
            
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5))
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2.0
        profileImageView.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.layoutSubviews()
        self.backgroundColor = .clear
        
        // Добавляем визуальные эффекты к contentView
        self.contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(studentNameLabel)
        contentView.addSubview(innerTableView)
        
        // Регистрация кастомной ячейки
        innerTableView.register(HomeWorkPaidMonthsCell.self, forCellReuseIdentifier: "HomeWorkPaidMonthsCell")
        
        setupConstraints()
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.width.equalTo(60)
                make.height.equalTo(profileImageView.snp.width)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
      
        studentNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(23)

        }

        innerTableView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with student: Student, image: UIImage?, isExpanded: Bool, navigationController: UINavigationController?) {
        
        self.student = student
        self.paidMonths = student.months
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
        innerTableView.reloadData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Добавляем делегаты для внутренней таблицы
extension HomeWorkTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращаем количество месяцев или 1, если месяцев нет
        return max(paidMonths.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorkPaidMonthsCell", for: indexPath) as! HomeWorkPaidMonthsCell
            
            if paidMonths.isEmpty {
                cell.monthLabel.text = "There are no added Months"
                cell.paidStatusLabel.text = ""
            } else {
                let paidMonth = paidMonths[indexPath.row]
                cell.configure(with: student!, selectedMonth: paidMonth.monthName)
            }
            
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMonth = paidMonths[indexPath.row]
        
        // Создаем новый контроллер для отображения уроков выбранного месяца
        let monthLessonsVC = MonthLessonsViewController()
        
        let lessonPrice = student?.lessonPrice.price ?? 0.0

        // Передаем объект Student в MonthLessonsViewController
        monthLessonsVC.student = student
        monthLessonsVC.lessonPrice = lessonPrice
        monthLessonsVC.selectedMonth = selectedMonth
        monthLessonsVC.selectedSchedules = student?.schedule.map { ($0.weekday, $0.time) } ?? []
        monthLessonsVC.lessonsForStudent = lessonsForStudent
        monthLessonsVC.delegate = self
        navigationController?.pushViewController(monthLessonsVC, animated: true)
        
        innerTableView.reloadData()
    }
}
