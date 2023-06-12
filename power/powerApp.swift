//
//  powerApp.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-11.
//

import SwiftUI

@main
struct powerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
