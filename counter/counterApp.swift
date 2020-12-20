//
//  counterApp.swift
//  counter
//
//  Created by Coding on 12/20/20.
//

import SwiftUI

@main
struct counterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
