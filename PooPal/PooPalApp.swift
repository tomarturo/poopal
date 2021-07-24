//
//  PooPalApp.swift
//  PooPal
//
//  Created by Tom  on 7/24/21.
//

import SwiftUI

@main
struct PooPalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
