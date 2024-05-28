//
//  ViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 13.04.2024.
//

import UIKit

protocol StudentDetailDelegate: AnyObject {
    func didCreateStudent(_ student: Student, withImage: UIImage?)
}

class StudentDetailViewController: UIViewController {
    
    weak var delegate: StudentDetailDelegate?
    
    
    var student: Student?
    var selectedImage: UIImage?
    
    
    let nameLabel = UITextField()
    let phoneNumber = UITextField()
    let parentName = UITextField()
    let paidMonthsLabel = UILabel()
    let scheduleLabel = UILabel() // Новый UILabel для отображения расписания
    let paidMonthsTableView = UITableView()
    
    var imageButton = UIButton(type: .system)
    let addPaidMonthButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка UI и отображение данных ученика
        
        // Настройка UI
        setupUI()
        
        // Отображение данных ученика
        updateUI()
        
        view.backgroundColor = .white
        
        // Создаем кнопку с текстом
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        // Устанавливаем кнопку в правый верхний угол
        navigationItem.rightBarButtonItem = saveButton
        
        
    }
    
    @objc func saveButtonTapped() {
        print("Save button tapped") // Добавляем отладочную печать
        
        // Проверяем, что все необходимые данные заполнены
        guard let name = nameLabel.text,
              let image = selectedImage,
              let phoneNumberTextField = phoneNumber.text,
              let parentNameTextField = parentName.text
            else {
            return
        }
        
        // Создаем нового ученика с переданными данными и изображением
        let newStudent = Student(name: name, phoneNumber: phoneNumberTextField, parentName: parentNameTextField, imageForCell: image)
        
        // Передаем нового ученика и выбранное изображение через делегата обратно в контроллер списка учеников
        delegate?.didCreateStudent(newStudent, withImage: image)

        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
        
        func setupUI() {
            addPaidMonthButton.setTitle("+", for: .normal)
            addPaidMonthButton.backgroundColor = .lightGray
//            addPaidMonthButton.addTarget(self, action: #selector(self.addPaidMonthButtonTapped), for: .touchUpInside)
            
            let buttonSize: CGFloat = 110
            imageButton.layer.cornerRadius = buttonSize / 2
            
//             Устанавливаем цвет рамки кнопки
            imageButton.layer.borderColor = UIColor.blue.cgColor
            imageButton.layer.borderWidth = 0.3
            imageButton.clipsToBounds = true
            // Установка текста для нормального состояния кнопки
            imageButton.setTitle("Добавить фото", for: .normal)
            imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 12) // Новый размер шрифта, например, 14
            
            
            
//            // Установка текста для состояния кнопки при нажатии
//            imageButton.setTitle("Добавить фото", for: .highlighted)
            imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
            
            // Настройка контроллера изображений
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            nameLabel.borderStyle = .roundedRect
            phoneNumber.borderStyle = .roundedRect
            parentName.borderStyle = .roundedRect
            
            nameLabel.placeholder = "Введите имя ученика"
            phoneNumber.placeholder = "Введите номер телефона"
            parentName.placeholder = "Введите имя родителя"
            
            // Добавляем элементы на экран
            view.addSubview(nameLabel)
            view.addSubview(phoneNumber)
            view.addSubview(parentName)
            view.addSubview(paidMonthsLabel)
            view.addSubview(scheduleLabel) // Добавляем новый UILabel для отображения расписания
            view.addSubview(paidMonthsTableView)
            view.addSubview(imageButton)
            view.addSubview(addPaidMonthButton)
            
            // Настройка ограничений (constraints)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            phoneNumber.translatesAutoresizingMaskIntoConstraints = false
            parentName.translatesAutoresizingMaskIntoConstraints = false
            paidMonthsLabel.translatesAutoresizingMaskIntoConstraints = false
            scheduleLabel.translatesAutoresizingMaskIntoConstraints = false // Устанавливаем свойство для нового UILabel
            paidMonthsTableView.translatesAutoresizingMaskIntoConstraints = false
            imageButton.translatesAutoresizingMaskIntoConstraints = false
            addPaidMonthButton.translatesAutoresizingMaskIntoConstraints = false
            
            // Задаем ограничения для addPaidMonthButton
            NSLayoutConstraint.activate([
                addPaidMonthButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                addPaidMonthButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                addPaidMonthButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                addPaidMonthButton.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            NSLayoutConstraint.activate([
                imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Выравнивание по вертикали с nameLabel
                imageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20), // Отступ от левого края
                imageButton.widthAnchor.constraint(equalToConstant: 110), // Ширина кнопки
                imageButton.heightAnchor.constraint(equalToConstant: 110) // Высота кнопки
            ])

            // Задаем ограничения для nameLabel
            NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 10), // Отступ от правого края кнопки
                nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])

            // Задаем ограничения для phoneNumber
            NSLayoutConstraint.activate([
                phoneNumber.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20), // Отступ от нижнего края nameLabel
                phoneNumber.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 10), // Отступ от правого края кнопки
                phoneNumber.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])

            // Задаем ограничения для parentName
            NSLayoutConstraint.activate([
                parentName.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: 20), // Отступ от нижнего края phoneNumber
                parentName.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 10), // Отступ от правого края кнопки
                parentName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])
            
            // Задаем ограничения для scheduleLabel
            NSLayoutConstraint.activate([
                scheduleLabel.topAnchor.constraint(equalTo: parentName.bottomAnchor, constant: 20),
                scheduleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                scheduleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])
            
            // Задаем ограничения для paidMonthsLabel
            NSLayoutConstraint.activate([
                paidMonthsLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 20),
                paidMonthsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                paidMonthsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])
            
            // Задаем ограничения для paidMonthsTableView
            NSLayoutConstraint.activate([
                paidMonthsTableView.topAnchor.constraint(equalTo: paidMonthsLabel.bottomAnchor, constant: 20),
                paidMonthsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                paidMonthsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                paidMonthsTableView.bottomAnchor.constraint(equalTo: addPaidMonthButton.topAnchor, constant: -20)
            ])
            
//            // Настройка таблицы оплаченных месяцев
//            paidMonthsTableView.dataSource = self
//            paidMonthsTableView.delegate = self
//            paidMonthsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaidMonthCell")
        }
        
        let imagePicker = UIImagePickerController()
        
    @objc func selectImage() {
        // Проверка доступности источников изображений (фотогалереи)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Обработка ситуации, когда фотогалерея недоступна
            print("Фотогалерея недоступна")
        }
       
    }
    
    let studentTableVC = StudentTableViewCell()
        
        func updateUI() {
            guard let student = student else { return }
            
            nameLabel.text = "\(student.name)"
            
            if let selectedImage = selectedImage {
                    imageButton.setBackgroundImage(selectedImage, for: .normal)
                } else {
                    // Handle the case where the selected image is nil
                }
            
//            paidMonthsLabel.text = "Оплаченные месяцы: \(student.paidMonths.joined(separator: ", "))"
//            scheduleLabel.text = "Расписание: \(student.schedule.map { "\($0.day) - \($0.times.joined(separator: ", "))" }.joined(separator: ", "))"
            
            
            // Устанавливаем автоматическое уменьшение размера шрифта для scheduleLabel
            scheduleLabel.adjustsFontSizeToFitWidth = true
            scheduleLabel.minimumScaleFactor = 0.5
            
            paidMonthsTableView.reloadData()
        }
        
//        @objc func addPaidMonthButtonTapped() {
//            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            
//            alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//            
//            for month in ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"] {
//                alertController.addAction(UIAlertAction(title: month, style: .default, handler: { [weak self] _ in
//                    self?.addPaidMonth(month)
//                }))
//            }
//            
//            present(alertController, animated: true)
//        }
//        
//        func addPaidMonth(_ month: String) {
//            guard let student = student else { return }
//            student.paidMonths.append(month)
//            updateUI()
//        }
//    }
//    
//    extension StudentDetailViewController: UITableViewDataSource {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return student?.paidMonths.count ?? 0
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PaidMonthCell", for: indexPath)
//            cell.textLabel?.text = student?.paidMonths[indexPath.row]
//            return cell
//        }
//    }
//    
//    extension StudentDetailViewController: UITableViewDelegate {
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            guard let student = student else { return }
//            let selectedMonth = student.paidMonths[indexPath.row]
//            let monthLessonsVC = MonthLessonsViewController()
//            monthLessonsVC.lessons = student.lessons.filter { $0.date == selectedMonth }
//            navigationController?.pushViewController(monthLessonsVC, animated: true)
//        }
    }

extension String {
    func abbreviatedWeekday() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU") // Устанавливаем локаль для русского языка
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "EE" // Формат дня недели в виде двух букв
            return formatter.string(from: date).uppercased()
        } else {
            let lowercaseInput = self.lowercased()
            switch lowercaseInput {
            case "пн", "понедельник":
                return "ПН"
            case "вт", "вторник":
                return "ВТ"
            case "ср", "среда":
                return "СР"
            case "чт", "четверг":
                return "ЧТ"
            case "пт", "пятница":
                return "ПТ"
            case "сб", "суббота":
                return "СБ"
            case "вс", "воскресенье":
                return "ВС"
            default:
                return nil
            }
        }
    }
}
    
extension StudentDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage,
           let imageURL = info[.imageURL] as? URL {
            selectedImage = pickedImage

            imageButton.setTitle("", for: .normal)
            imageButton.setBackgroundImage(selectedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
