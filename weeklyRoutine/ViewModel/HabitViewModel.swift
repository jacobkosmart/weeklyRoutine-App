//
//  HabitViewModel.swift
//  weeklyRoutine
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
	// MARK: -  PROPERTY
	// MARK:  New Habit Properties
	// New Habit Properties
	@Published var addNewHabit: Bool = false
	@Published var title: String = ""
	@Published var habitColor: String = "Card-1"
	@Published var weekDays: [String] = []
	@Published var isRemainderOn: Bool = false
	@Published var remainderText: String = ""
	@Published var remainderDate: Date = Date()
	
	// MARK:  Remainder Time Picker
	@Published var showTimerPicker: Bool = false
	
	// MARK: Editing Habit
	@Published var editHabit: Habit?
	
	// MARK: - FUNCTION
	
	// MARK: -  Adding Habit to Database
	func addHabit(context: NSManagedObjectContext) async -> Bool {
		let habit = Habit(context: context)
		habit.title = title
		habit.color = habitColor
		habit.weekDays = weekDays
		habit.isReminderOn = isRemainderOn
		habit.reminderText = remainderText
		habit.notificationDate = remainderDate
		habit.notificationIDs = []
		
		if isRemainderOn{
			// MARK: -  Scheduling Notifications
			if let ids = try? await scheduleNotification() {
				habit.notificationIDs = ids
				if let _ = try? context.save() {
					return true
				}
			}
		} else {
			// MARK: -  Adding Data
			if let _ = try? context.save() {
				return true
			}
		}
		return false
	}
	
	// MARK: -  Adding Notifications
	func scheduleNotification() async throws -> [String] {
		let content = UNMutableNotificationContent()
		content.title = "위클리 루틴"
		content.subtitle = remainderText
		content.sound = UNNotificationSound.default
		
		// Scheduled Ids
		var notificationIDs: [String] = []
		let calendar = Calendar.current
		let weekdaySymbols: [String] = calendar.weekdaySymbols
		
		// MARK: -  Scheduling Notification
		for weekDay in weekDays {
			// Unique ID for each Notification
			let id = UUID().uuidString
			let hour = calendar.component(.hour, from: remainderDate)
			let min = calendar.component(.minute, from: remainderDate)
			let day = weekdaySymbols.firstIndex { currentDay in
				return currentDay == weekDay
			} ?? -1
			// MARK:  Since Week Day Starts from 1-7 So, Adding + 1 to Index
			if day != -1 {
				var components = DateComponents()
				components.hour = hour
				components.minute = min
				components.weekday = day + 1
				
				// MARK: This will Trigger Notification on Each Selected Day
				let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
				
				// MARK:  Notification Request
				let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
				try await UNUserNotificationCenter.current().add(request)
				
				// Adding ID
				notificationIDs.append(id)
				
			}
		}
		return notificationIDs
	}
	
	// MARK: -  Erasing Content
	func resetData() {
		title = ""
		habitColor = "Card-1"
		weekDays = []
		isRemainderOn = false
		remainderDate = Date()
		remainderText = ""
		editHabit = nil
	}
	
	// MARK: - Restoring Edit Data
	func restoreEditData() {
		if let editHabit = editHabit {
			title = editHabit.title ?? ""
			habitColor = editHabit.color ?? "Card-1"
			weekDays = editHabit.weekDays ?? []
			isRemainderOn = editHabit.isReminderOn
			remainderDate = editHabit.notificationDate ?? Date()
			remainderText = editHabit.reminderText ?? ""
		}
	}
	
	// MARK: - Deleting Habit From DB
	func deleteHabit(context: NSManagedObjectContext)-> Bool {
		if let editHabit = editHabit {
			context.delete(editHabit)
			if let _ = try? context.save() {
				return true
			}
		}
		return false
	}
	
	// MARK: -  Done Btn Status
	func doneStatus() -> Bool {
		let remainderStatus = isRemainderOn ? remainderText == "" : false
		
		if title == "" || weekDays.isEmpty || remainderStatus {
			return false
		}
		return true
	}
}


