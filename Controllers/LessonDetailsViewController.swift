import UIKit
import SnapKit

protocol LessonDetailDelegate: AnyObject {
    func didUpdateStudentLessons(_ lessons: [String: [Lesson]])
    func didUpdateHomework(forLessonIndex index: Int, homework: String)
    func didUpdateAttendance(forLessonIndex index: Int, attended: Bool)
}

class LessonDetailsViewController: UIViewController, SaveChangesHandling {
    
    weak var delegate: LessonDetailDelegate?
    
    var student: Student?
    
    var changesMade = false
    var temporaryLessons: [String: [Lesson]] = [:] // Список уроков для отображения
    var homeworksArray = [String]()
    
    var lesson: Lesson!
    var lessonIndex: Int!
    
    var attendanceSwitch: UISwitch!
    var statusLabel: UILabel!
    var saveButton: UIButton!
    
    let homeworkTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Устанавливаем значение UISwitch равным значению lesson.attended
            attendanceSwitch.isOn = lesson.attended
        
        // Убедимся, что значение attendanceSwitch.isOn не изменяется вне метода viewDidLoad()
        print("Attendance Switch is initially on? \(attendanceSwitch.isOn)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Заменяем кнопку "Back" на кастомную кнопку
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = .white
        setupUI()
        setupObservers()
        setupTapGesture()
        self.title = "Lesson Details"
        // Set the text view with the current homework
        homeworkTextView.text = lesson.homework
        // Устанавливаем значение UISwitch равным значению lesson.attended
        attendanceSwitch.isOn = lesson.attended
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: homeworkTextView)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textViewDidChange(_ notification: Notification) {
        changesMade = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func shareHomework() {
        guard let homework = homeworkTextView.text else { return }
        let activityVC = UIActivityViewController(activityItems: [homework], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
               
        savingConfirmation()
        
    }
    
    @objc func saveButtonTapped() {
        guard let updatedHomework = homeworkTextView.text else { return }
        
        // Обновляем состояние attended
        lesson.attended = attendanceSwitch.isOn
        
        // Уведомляем делегата об обновлении домашнего задания
        delegate?.didUpdateHomework(forLessonIndex: lessonIndex, homework: updatedHomework)
        
        // Уведомляем делегата об обновлении уроков
        delegate?.didUpdateStudentLessons(temporaryLessons)
        
        changesMade = false
        
        print("After tapping saveHomework() on LessonDetailsViewController \(updatedHomework)")
        
        // Возвращаемся назад
        navigationController?.popViewController(animated: true)
    }
    
    @objc func attendanceSwitchValueChanged(_ sender: UISwitch) {
        
        // Сохраняем факт изменения состояния UISwitch
           changesMade = true
       
        // Обновляем статус урока при изменении значения переключателя
        lesson?.attended = sender.isOn
        delegate?.didUpdateAttendance(forLessonIndex: lessonIndex, attended: sender.isOn)
             
        // Обновляем текст статуса
        statusLabel.text = sender.isOn ? "Was present" : "Was absent"
    }
    
    func savingConfirmation() {
        // Проверяем, были ли внесены изменения
        if changesMade {
            let alertController = UIAlertController(title: "Save changes?", message: "There are unsaved changes. \n\n Are you sure you want to exit without saving?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.discardChanges()
            }
            alertController.addAction(cancelAction)
            
            let saveAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.saveButtonTapped()
            }
            alertController.addAction(saveAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func discardChanges() {
        // Добавим вывод на консоль для проверки вызова метода
        print("Метод discardChanges() вызван")
        
        // Сбрасываем флаг changesMade в false
        changesMade = false
        
        // Возвращаем UISwitch в исходное состояние
        attendanceSwitch.isOn = lesson.attended == false
        
        // Обновляем статус урока при изменении значения переключателя
        lesson?.attended = attendanceSwitch.isOn
        delegate?.didUpdateAttendance(forLessonIndex: lessonIndex, attended: attendanceSwitch.isOn)
        
        // Возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }
}
