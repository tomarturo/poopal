import SwiftUI
import MapKit
import CoreData

struct ReminderDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    var poo: Poo

    var body: some View {
        VStack(spacing: 0) {
            MapView(location: poo.location)
                .frame(height: UIScreen.main.bounds.height / 3)

            TextDetailView(location: poo.location)
                .frame(maxHeight: .infinity)
        }
        .background(Color.white) // 1. Background is white
    }
}

struct MapView: View {
    var location: Location?
    
    var body: some View {
        if let location = location {
            Map(coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            ), showsUserLocation: false, userTrackingMode: nil, annotationItems: [location]) { location in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                    content: {
                        ZStack {
                            Circle()
                                .fill(Color("Lavender").opacity(0.35))
                                .overlay(Circle().stroke(Color("Lavender"), lineWidth: 2))
                                .frame(width: 104, height: 104)
                            
                            Circle()
                                .fill(Color("Taupe"))
                                .frame(width: 48, height: 48)
                            
                            Image("Poop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    }
                )
            }
            .edgesIgnoringSafeArea(.all)
            //            .overlay(RecenterButton(region: .constant(MKCoordinateRegion(
            //                            center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
            //                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            //                        ))), alignment: .bottomTrailing)
            //        } else {
            //            Text("No location available")
            //                .foregroundColor(.red)
            //        }
        }
    }
}

struct TextDetailView: View {
    var location: Location?

    var body: some View {
        if let location = location {
            VStack(alignment: .leading) {
                Text("Evening Dookie")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Charcoal"))
                Text("Lat/Long: \(location.latitude), \(location.longitude)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 32)
                ForEach(0..<3) { index in
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("Charcoal"))
                            .imageScale(.small)
                            .frame(width: 16, height: 16)
                        Text(getText(for: index))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("Charcoal"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .background(Color.white)
            .padding(16)
            Spacer()
        } else {
            Text("No location available")
                .foregroundColor(.red)
        }
    }

    private func getText(for index: Int) -> String {
        switch index {
        case 0:
            return "Bag Bird's waste"
        case 1:
            return "Place it out of the way of passersby"
        case 2:
            return "Enjoy your walk! PooPal will remind you to pick it up on your way home."
        default:
            return ""
        }
    }
}

struct RecenterButton: View {
    @Binding var region: MKCoordinateRegion?
    
    var body: some View {
        Button(action: {
            // Recenter the map on the reminder's lat/long
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: region?.center.latitude ?? 0, longitude: region?.center.longitude ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }) {
            Image(systemName: "arrow.counterclockwise")
                .resizable()
                .imageScale(.small)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .padding()
        }
        .background(
            Circle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 40, height: 40)
        )
        .padding(.trailing, 16)
        .padding(.top, 16)
    }
}

