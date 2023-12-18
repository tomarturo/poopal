//
//  CreateReminderButton.swift
//  PooPal
//
//  Created by Tom  on 7/27/21.
//

import SwiftUI

struct CreateReminderButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Poo.createdAt, ascending: true)],
        animation: .default)
    private var poos: FetchedResults<Poo>
    @StateObject var locationManager = LocationManager()
    @State private var showingSheet = false
    @State private var showingRemindersList = false
    @State var isAtMaxScale = false
    
    private let animation = Animation.easeOut(duration: 1.2).repeatForever(autoreverses: true)
    private let maxScale: CGFloat = 2
    
    private func addItem() {
        withAnimation {
            let newPoo = Poo(context: viewContext)
            newPoo.createdAt = Date()
            let pooLocation = Location(context: viewContext)
            
            let location = locationManager.location
            
            pooLocation.latitude = location?.latitude ?? 0
            pooLocation.longitude = location?.longitude ?? 0
            
            newPoo.location = pooLocation
            
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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Taupe")
                    .edgesIgnoringSafeArea([.horizontal, .top])
                VStack {
                    Text("Create Reminder")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Button(action: {
                        showingSheet.toggle()
                        addItem()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("White"))
                                .opacity(0.4)
                                .frame(width: 200, height: 200)
                            
                            Image("Poop")
                                .resizable()
                                .frame(width: 64, height: 64)
                        }
                        .padding()
                        .scaleEffect(isAtMaxScale ? 1 : 0.95)
                        .onAppear {
                            withAnimation(self.animation, {
                                self.isAtMaxScale.toggle()
                            })
                        }
                        .sheet(isPresented: $showingSheet) {
                            if let lastPoo = poos.last {
                                // Display details of the last Poo
                                ReminderDetail(poo: lastPoo)
                            } else {
                                // Handle the case where the selectedPoo is nil (optional)
                                Text("Error: Unable to find the newly created reminder.")
                            }
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct CreateReminderButton_Previews: PreviewProvider {
    static var previews: some View {
        CreateReminderButton()
    }
}

