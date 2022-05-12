//
//  HabitViewModel.swift
//  weeklyRoutine
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
	// MARK: -  PROPERTY
	// New Habit Properties
	@Published var addNewHabit: Bool = false
	@Published var title: String = ""
	@Published var habitColor: String = "Card-1"
	@Published var weekDays: [String] = []
	@Published var isRemainderOn: Bool = false
	@Published var remainderText: String = ""
	@Published var remainderDate: Date = Date()
	// MARK: -  INIT
	// MARK: -  FUNCTION
}

