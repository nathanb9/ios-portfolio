
import Foundation
import CoreLocation
import MapKit

struct GPXPoint: Codable, Identifiable {
    var id: UUID {
        UUID()
    }
    var latitude: Double
    var longitude: Double
    var time: Date
}

struct GPXTrack: Codable {
    var name: String
    var time: Date
    var track: [GPXPoint]
    var minimumLatitude: CLLocationDegrees
    var maximumLatitude: CLLocationDegrees
    var minimumLong: CLLocationDegrees
    var maximumLong: CLLocationDegrees
    func bounds() -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 0.5 * (maximumLatitude + minimumLatitude), longitude: 0.5 * (maximumLong + minimumLong)
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 3.5 * (maximumLatitude - minimumLatitude), longitudeDelta: 3.5 * (maximumLong - minimumLong)
            )
        )
    }
}
private let day_formatter : DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "MMM dd, YYYY"
    return format
}()

private let time_formatter : DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "HHmmss"
    return format
}()
class LocationManager: NSObject, ObservableObject {

    private let locationManager = CLLocationManager()
    private var url: URL?
    var isTracking: Bool = false
    
    @Published var location: CLLocation?
    @Published var speed: CLLocationSpeed?
    @Published var region = MKCoordinateRegion()
    @Published var path = [CLLocation]()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.url = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    
    func trackingData() -> String {
        
        

            var pathway = [GPXPoint]()
            var minimumLatitude = CLLocationDegrees.greatestFiniteMagnitude
            var maximumLatitude = -CLLocationDegrees.greatestFiniteMagnitude
            var minimumLong = CLLocationDegrees.greatestFiniteMagnitude
            var maximumLong = -CLLocationDegrees.greatestFiniteMagnitude
            isTracking = false
            for curr_point in self.path {

                pathway.append(
                    GPXPoint(latitude: curr_point.coordinate.latitude, longitude: curr_point.coordinate.longitude, time: curr_point.timestamp))
                if (curr_point.coordinate.latitude < minimumLatitude) {
                    minimumLatitude = curr_point.coordinate.latitude
                }
                if (curr_point.coordinate.latitude > maximumLatitude) {
                    maximumLatitude = curr_point.coordinate.latitude
                }
                if (curr_point.coordinate.longitude < minimumLong) {
                    minimumLong = curr_point.coordinate.longitude
                }
                if (curr_point.coordinate.longitude > maximumLong) {
                    maximumLong = curr_point.coordinate.longitude
                }
            }
            
            self.path = [CLLocation]()
            
            let time = pathway.first!.time
            let name = "\(day_formatter.string(from: pathway.first!.time)) \(time_formatter.string(from: pathway.first!.time))"
            let data = GPXTrack(
                name: name, time: time, track: pathway, minimumLatitude: minimumLatitude, maximumLatitude: maximumLatitude, minimumLong: minimumLong, maximumLong: maximumLong
            )
            
            let file = url!.appendingPathComponent("\(name).json")
            
            do {
                let content: Data = try JSONEncoder.init().encode(data)
                try content.write(to: file)
            } catch {
                return "WriteError"
            }
            
            return name
        }
    
}

extension LocationManager: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
            guard let loc = location.last
            else {
                return
            }
            if (self.location == nil || loc != self.location) {
                self.location = loc
                self.speed = loc.speed
                self.region = MKCoordinateRegion(
                    center: loc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
                )
                if (isTracking) {
                    self.path.append(loc)
                }
            }
    }
}

extension CLLocation: Identifiable {
    public var id: UUID {
        UUID()
    }
}
