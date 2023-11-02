//
//  UploadView.swift
//  OpenTok
//
//  Created by Nathan B on 5/9/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import AVKit

struct UploadView: View {
    @State private var name: String = ""
    @State private var url: String = ""
    @EnvironmentObject var tiktoks: Videos

    
    var body: some View {
            
            VStack {
                Text("Name: ").bold()
                TextField("Enter name...", text: $name)
                Text("Video URL: ").bold()
                TextField("Enter url...", text: $url)
                Button("Upload Video", action: upload).padding(5)

        }
        
        
    }
    func upload () {
        // INSERT INTO DATABASE
        let root = Database.database().reference()
        root.child("urls").childByAutoId().setValue(["url": url,
                                                     "title": name, "seen": 0, "likes": 0])
        tiktoks.justuploaded = true
    }
    
    
}
