//
//  NewDigsApp.swift
//  NewDigs
//
//  Created by MaKayla Ortega Robinson on 7/30/23.
//

import SwiftUI

@main
struct NewDigsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
