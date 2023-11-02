//
//  ContentView.swift
//  OpenTok
//
//  Created by Nathan B on 5/8/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ContentView: View {
    
    @StateObject var tiktoks = Videos()
    
    
    var body: some View {
        TabView {
            PlayerView().environmentObject(tiktoks).padding().tabItem {
                Label("Player", systemImage: "play.rectangle")
            }
            UploadView().environmentObject(tiktoks).padding().tabItem {
                Label("Upload", systemImage: "square.and.arrow.up")
            }
        }
        //Button(action: upload) {Text("Upload")}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
