//
//  ContentView.swift
//  weeklyRoutine
//
//  Created by Jacob Ko on 2022/05/12.
//

import SwiftUI

struct ContentView: View {
	
	var body: some View {
		Home()
			.preferredColorScheme(.dark)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
