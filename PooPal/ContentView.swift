import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingSheet = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Poo.createdAt, ascending: true)],
        animation: .default)
    private var poos: FetchedResults<Poo>
    
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(poos) { poo in
                        Text("Poo at \(poo.createdAt!, formatter: itemFormatter) Longitude: \(poo.location!.longitude) Latitude: \(poo.location!.latitude)")
                    }
                    .onDelete(perform: deleteItems)
                }
                
                Button(action: addItem) {
                    Label("Create a Reminder", systemImage: "plus")
                }
                .padding()
            }
            .navigationTitle("PooPal Reminders")
        }
    }

    private func addItem() {
        withAnimation {
            let newPoo = Poo(context: viewContext)
            newPoo.createdAt = Date()
            let pooLocation = Location(context: viewContext);
            
            let location = locationManager.location;

            pooLocation.latitude = location?.latitude ?? 0
            pooLocation.longitude = location?.longitude ?? 0

            newPoo.location = pooLocation;

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { poos[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
}
