//
//  Home.swift
//  weeklyRoutine
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI

struct Home: View {
	// MARK: -  PROPERTY
	// add FetchRequest
	@FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var habits: FetchedResults<Habit>
	@StateObject var vm = HabitViewModel()
	// MARK: -  BODY
	var body: some View {
		// MARK: Title
		VStack (spacing: 0) {
			Text("위클리 루틴")
				.font(.title2.bold())
				.frame(maxWidth: .infinity)
			// Setting Btn
				.overlay(alignment: .trailing) {
					Button {
						
					} label: {
						Image(systemName: "gearshape")
							.font(.title3)
							.foregroundColor(.white)
					}

				}
				.padding(.bottom, 10)
			
			// Making add Btn Center when habits empty
			ScrollView(habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
				VStack (spacing: 15) {
					ForEach(habits) { habit in
						HabitCardView(habit: habit)
					} //: LOOP
					// MARK: Add Habit Btn
					Button {
						vm.addNewHabit.toggle()
					} label: {
						Label {
							Text("새 루틴 추가")
						} icon: {
							Image(systemName: "plus.circle")
						}
						.font(.callout.bold())
						.foregroundColor(.white)
					}
					.padding(.top, 15)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				} //: VSTACK
				.padding(.vertical)
			} //: SCROLL
			
		} //: VSTACK
		.frame(maxHeight: .infinity, alignment: .top)
		.padding()
		.sheet(isPresented: $vm.addNewHabit) {
			// MARK:  Erasing all Exsisting Content
			vm.resetData()
		} content: {
			AddNewHabit()
				.environmentObject(vm)
		}
	}
	
	// MARK: -  FUNCTION
	
	// MARK: -  Habit Card View
	@ViewBuilder
	func HabitCardView(habit: Habit) -> some View {
		VStack (spacing: 6) {
			HStack {
				Text(habit.title ?? "")
					.font(.callout)
					.fontWeight(.semibold)
					.lineLimit(1)
				
				Image(systemName: "bell.badge.fill")
					.font(.callout)
					.foregroundColor(Color(habit.color ?? "Card-1"))
					.scaleEffect(0.9)
					.opacity(habit.isReminderOn ? 1 : 0)
				
				Spacer()
				
				let count = (habit.weekDays?.count ?? 0)
				Text(count == 7 ? "매일" : "일주일에 \(count)번")
					.font(.caption)
					.foregroundColor(.gray)
				
			} //: HSTACK
			.padding(.horizontal, 10)
			
			// MARK:  Displaying Current Week and Marking Activie Dates of Habit
			let calender = Calendar.current
			let currentWeek = calender.dateInterval(of: .weekOfMonth, for: Date())
			let symbols = calender.weekdaySymbols
			let startDate = currentWeek?.start ?? Date()
			let activeWeekDays = habit.weekDays ?? []
			let activePlot = symbols.indices.compactMap { index -> (String, Date) in
				let currentDate = calender.date(byAdding: .day, value: index, to: startDate)
				return (symbols[index], currentDate!)
			}
			
			HStack(spacing: 0) {
				ForEach(activePlot.indices, id: \.self) { index in
					let item = activePlot[index]
					
					VStack (spacing: 6) {
						// MARK:  Limiting to First 3 letters
						Text(item.0.prefix(3))
							.font(.caption)
						
						let status = activeWeekDays.contains { day in
							return day == item.0
						}
						
						Text(getDate(date: item.1))
							.font(.system(size: 14))
							.fontWeight(.semibold)
							.padding(8)
							.background {
								Circle()
									.fill(Color(habit.color ?? "Card-1"))
									.opacity(status ? 1 : 0)
							}
					} //: VSTACK
					.frame(maxWidth: .infinity)
				} //: LOOP
			} //: HSTACK
			.padding(.top, 15)
		} //: VSTACK
		.padding(.vertical)
		.padding(.horizontal, 6)
		.background {
			RoundedRectangle(cornerRadius: 12, style: .continuous)
				.fill(Color("TFBG").opacity(0.5))
		}
		.onTapGesture {
			// MARK:  Editing Habit
			vm.editHabit = habit
			vm.restoreEditData()
			vm.addNewHabit.toggle()
		}
	}
	
	// MARK: -  Formatting Date
	func getDate(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd"
		
		return formatter.string(from: date)
	}
}

// MARK: -  PREVIEW
struct Home_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
