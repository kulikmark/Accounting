//
//  StudentStore.swift
//  Accounting
//
//  Created by Марк Кулик on 30.05.2024.
//

import UIKit

class StudentStore {
    static let shared = StudentStore()
    
    private init() {}
    
    var students = [Student]()
}
