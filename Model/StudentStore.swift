//
//  StudentStore.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//

import UIKit

class StudentStore {
    static let shared = StudentStore()
    
    /*private(set)*/ var students: [Student] = []
    
    private init() {}
    
    func addStudent(_ student: Student) {
        students.append(student)
        // Notify listeners if using NotificationCenter or any observer pattern
    }
    
    func updateStudent(_ updatedStudent: Student) {
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            students[index] = updatedStudent
            // Notify listeners if using NotificationCenter or any observer pattern
        }
    }
    
    func removeStudent(at index: Int) {
        students.remove(at: index)
        // Notify listeners if using NotificationCenter or any observer pattern
    }
}
