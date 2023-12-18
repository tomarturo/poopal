import SwiftUI
import CoreLocation

@main
struct PooPalApp: App {
    @StateObject private var locationManager = LocationManager()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CreateReminderButton()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("Create")
                    }
                
                RemindersList()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("List")
                    }
            }
        }
    }
}
