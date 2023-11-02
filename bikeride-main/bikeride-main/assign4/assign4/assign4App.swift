import SwiftUI

@main
struct assign4App: App {
    @StateObject var locmanager = LocationManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(locmanager)
        }
    }
}
