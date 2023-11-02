
import SwiftUI
import MapKit
struct StatusViewer: View {
    
    @Binding var visible: Bool
    
    @Binding var gpxtStatus: GPXTrack
    
    @Binding var region: MKCoordinateRegion
    
    private let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM dd, YYYY [HH:mm:ss]"
        return f
    }()
    
    var body: some View {
        
        
        
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: false,
                annotationItems: gpxtStatus.track
            ) { loc in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: loc.latitude, longitude: loc.longitude
                    )
                ) {
                    Circle()
                        .foregroundColor(Color.blue.opacity(0.5))
                        .frame(width: 20, height: 20)
                }
            }.padding(.bottom, 20)
            
            Text("Date: \(formatter.string(from: gpxtStatus.time))")
        }
        
    }
    
}
