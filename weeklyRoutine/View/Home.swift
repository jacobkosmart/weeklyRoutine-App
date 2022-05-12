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
			
			// Making add Btn Center when habits empty
			ScrollView(habits.isEmpty ? .init() : .vertical, showsIndicators: false) {
				VStack (spacing: 15) {
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
			
		} content: {
			
		}

	}
}

// MARK: -  PREVIEW
struct Home_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
