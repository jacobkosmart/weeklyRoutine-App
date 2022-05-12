//
//  AddNewHabit.swift
//  weeklyRoutine
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI

struct AddNewHabit: View {
	// MARK: -  PROPERTY
	@EnvironmentObject var vm: HabitViewModel
	// MARK: -  BODY
	var body: some View {
		NavigationView {
			VStack (spacing: 15) {
				// MARK: Title
				TextField("제목", text: $vm.title)
					.padding(.horizontal)
					.padding(.vertical, 10)
					.background(Color("TFBG").opacity(0.6), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
				
				// MARK: Habit Color Picker
				HStack (spacing: 0) {
					ForEach(1...7, id: \.self) { index in
						let color = "Card-\(index)"
						Circle()
							.fill(Color(color))
							.frame(width: 30, height: 30)
							.overlay(content: {
								if color == vm.habitColor {
									Image(systemName: "checkmark")
										.font(.caption.bold())
								}
							})
							.onTapGesture {
								withAnimation {
									vm.habitColor = color
								}
							}
							.frame(maxWidth: .infinity)
					} //: LOOP
				} //: HSTACK
				.padding(.vertical)
				
				Divider()
				
				// MARK: -  Weekly Selection
				VStack(alignment: .leading, spacing: 6) {
					Text("요일")
						.font(.callout.bold())
					let weekDays = Calendar.current.weekdaySymbols ?? []
					HStack (spacing: 10) {
						ForEach(weekDays, id: \.self) { day in
							let index = vm.weekDays.firstIndex { value in
								return value == day
							} ?? -1
							// Limit to First 2 Letters
							Text(day.prefix(3))
								.fontWeight(.semibold)
								.frame(maxWidth: .infinity)
								.padding(.vertical, 12)
								.background {
									RoundedRectangle(cornerRadius: 10, style: .continuous).fill(index != -1 ? Color(vm.habitColor) : Color("TFBG").opacity(0.6))
								}
								.onTapGesture {
									withAnimation {
										if index != -1 {
											vm.weekDays.remove(at: index)
										} else {
											vm.weekDays.append(day)
										}
									}
								}
						} //: LOOP
					} //: HSTACK
				} //: VSTACK
			} //: VSTACK
			.frame(maxHeight: .infinity, alignment: .top)
			.padding()
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle("새로운 루틴 추가하기")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						
					} label: {
						Image(systemName: "xmark.circle")
					}
					.tint(.white)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						
					} label: {
						Text("추가")
					}
					.tint(.white)
				}
			}
		} //: NAVIGATION
	}
}

// MARK: -  PREVIEW
struct AddNewHabit_Previews: PreviewProvider {
	static var previews: some View {
		AddNewHabit()
			.environmentObject(HabitViewModel())
			.preferredColorScheme(.dark)
	}
}
