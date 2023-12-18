//
//  RemindersList.swift
//  PooPal
//
//  Created by Tom Kurzeka on 12/17/23.
//
import SwiftUI
import CoreData

struct RemindersList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Poo.createdAt, ascending: true)],
        animation: .default)
    private var poos: FetchedResults<Poo>
    
    @StateObject var locationManager = LocationManager()

    var body: some View {
        List {
            ForEach(poos) { poo in
                Text("Poo at \(poo.createdAt!, formatter: itemFormatter) Longitude: \(poo.location!.longitude) Latitude: \(poo.location!.latitude)")
            }
            .onDelete(perform: deleteItems)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { poos[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                handleSaveError(error)
            }
        }
    }

    private func handleSaveError(_ error: Error) {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


//struct RemindersList_Previews: PreviewProvider {
//    static var previews: some View {
//        RemindersList()
//    }
//}
