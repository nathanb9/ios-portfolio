
import MapKit
import UniformTypeIdentifiers
import SwiftUI


struct ContentView: View {
    
    @State var filesDisplay: Bool = false
    @State var destShow: Bool = false
    @EnvironmentObject var locmanager: LocationManager
    @State var map_current: Bool = false
    @State var sessionRegion: MKCoordinateRegion = MKCoordinateRegion()
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @State var savedShow: GPXTrack = GPXTrack(name: "", time: Date(),track:[],minimumLatitude:0,maximumLatitude: 0, minimumLong: 0, maximumLong: 0
    )
    
    var body: some View {
        
        NavigationView {
            VStack {
                Map(
                    coordinateRegion: $locmanager.region,
                    interactionModes: MapInteractionModes(),
                    showsUserLocation: true,
                    annotationItems: locmanager.path
                ) {
                    loc in
                    MapAnnotation(coordinate: loc.coordinate) {
                        Rectangle()
                            .foregroundColor(Color.red.opacity(0.5))
                            .frame(width: 15, height: 15)
                    }
                }.padding(.bottom, 15)
                
                if let speed = locmanager.speed {
                    Text("Speed: \(speed.description) m/s")
                } else {
                    Text("Speed: N/A")
                }
                
                Button() {
                    mp()
                } label: {
                    //
                    if (map_current) {
                        Label("Stop", systemImage: "stop")
                            .bold()
                            .frame(width: 175)
                            .padding()
                    } else {
                        Label("Start", systemImage: "play")
                            .bold()
                            .frame(width: 175)
                            .padding()
                    }
                }
                .foregroundColor(.white)
                .background(map_current ? .red : .blue)
                .cornerRadius(10)
                
                NavigationLink(
                    destination: StatusViewer(
                        visible: $destShow,
                        gpxtStatus: $savedShow,
                        region: $sessionRegion
                    ).navigationTitle("Saved Route"),
                    isActive: $destShow
                ) {
                    Button() {
                        filesDisplay = true
                    } label:
                    {
                        Text("Browse Saved Tracks")
                            .frame(width: 250)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                }
        
            }
            
        }
       
        .fileImporter(
            isPresented: $filesDisplay,
            allowedContentTypes: [UTType.json]
        ) { res in
            if let url = try? res.get() {
                    if let data = try?
                        Data(contentsOf: url) {
                    if let t = try?
                        JSONDecoder().decode(GPXTrack.self, from: data) {
                            self.savedShow = t
                            self.sessionRegion = t.bounds()
                            self.destShow = true
                            return
                        }
                    }
                }

                alertMessage = "Please choose another file"
                self.showAlert = true
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Session Saved"), message: Text(alertMessage))
        }
        
    }
    func mp() -> Void {
        
        if (map_current) {
            let prsed = locmanager.trackingData()
            alertMessage = "Session has been saved into \"\(prsed)\""
            showAlert = true
        } else {
            locmanager.isTracking = true
        }
        
        map_current.toggle()
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var lm = LocationManager()
    
    static var previews: some View {
        ContentView().environmentObject(lm)
    }
}

