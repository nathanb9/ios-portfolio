//
//  PlayerView.swift
//  OpenTok
//
//  Created by Nathan B on 5/9/23.
//

import SwiftUI
import Firebase
import AVKit
import FirebaseDatabase
import Foundation
struct Video: Codable {
    var id: String?
    var url: String
    var title: String
    var seen: Int
    var likes: Int
    
    init(id: String? ,url: String, title: String, seen: Int, likes: Int) {
        self.url = url
        self.title = title
        self.seen = seen
        self.likes = likes
    }
    var dict: NSDictionary? {
        if let idstr = id {
            let d = NSDictionary(dictionary: [
                "id": idstr, "url":url, "title":title, "seen":seen, "likes":likes])
            return d
        }
        return nil
    }
    
    static func fromDict(_ d: NSDictionary) -> Video? {
        guard let url = d["url"] as? String else { return nil }
        guard let title = d["title"] as? String else { return nil }
        guard let seen = d["seen"] as? Int else { return nil }
        guard let likes = d["likes"] as? Int else { return nil }
        return Video(id: d["id"] as? String, url: url, title: title, seen: seen, likes: likes)
    }
    
    
}




struct PlayerView: View {
    
    //@State var current_video_likes: Int = 0
    //@State var current_video: Video
    @EnvironmentObject var tiktoks: Videos
    @State var curr_video = -1
    @State var title: String = ""
    @State var curr_likes = 0
    var body: some View {
        
            
            VStack {
                Text(title)
                
                if let url = URL(string: tiktoks.getUrl(index: self.curr_video) ?? "") {
                    //print("video playing is:")
                    //print(url)
                    //let player = AVPlayer (url: url)
                    //let controller = AVPlayerViewController()
                    //controller.player = player
                    VideoPlayer(player: AVPlayer(url: url))
                    //Text("\(url))")
                } else {
                    
                    Text("NO VIDEOS IN THE DATABSE OR NO VIDEOS SELECTED. PRESS PREV. OR NEXT TO START :) 👍").bold()
                }
                
                HStack {
                    Button(action: like) {
                        Text("👍").padding(2).background(.gray).cornerRadius(30)
                    }
                    Text(String(curr_likes) + " Likes")
                }
                
                
                HStack {
                    
                    HStack {
                        Button(action: previous) {
                            Text("Previous")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding(15)
                                .border(Color.blue, width: 3)
                                .cornerRadius(10)
                            
                        }
                        
                        Button(action: next) {
                            Text("Next")
                                .font(.title)
                                .foregroundColor(.blue)
                                .padding(15)
                                .border(Color.blue, width: 3)
                                .cornerRadius(10)
                            
                            
                        }
                    }
                    
                }
                Button(action: update_video_list) {
                    Text("Update Video List")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .border(Color.blue, width: 3)
                }
            }
        
        
    }
    func like() {
        tiktoks.increaseLikes(id: tiktoks.sortedIds[curr_video])
        curr_likes += 1
    }
    
    func previous() {
        print("curr_video")
        print(curr_video)
        print("count of id list")
        print(tiktoks.sortedIds.count)
        
        if (self.curr_video == -1) {
            if (tiktoks.sortedIds.count > 0) {
                self.curr_video = 0
            }
        } else {
            if (curr_video > 0) {
                if (tiktoks.justuploaded) {
                    self.curr_video = 0
                    tiktoks.justuploaded.toggle()
                } else {
                    self.curr_video -= 1
                }
                
            }
            else if (curr_video == 0) {
                self.curr_video = tiktoks.sortedIds.count-1
            }
            // register as seen
            tiktoks.entries[tiktoks.sortedIds[curr_video]]?.seen = 1
            tiktoks.registerAsSeen(id: tiktoks.sortedIds[curr_video])
            
            title = tiktoks.entries[tiktoks.sortedIds[curr_video]]?.title ?? "no title"
            curr_likes = tiktoks.entries[tiktoks.sortedIds[curr_video]]?.likes ?? 0
            print(tiktoks.entries[tiktoks.sortedIds[curr_video]]?.url ?? "BRUH")
        }
        
    }
    func next() {
        print("curr_video")
        print(curr_video)
        print("count of id list")
        print(tiktoks.sortedIds.count)
        
        if (self.curr_video == -1) {
            if (tiktoks.sortedIds.count > 0) {
                self.curr_video = 0
            }
        } else {
            if (curr_video < tiktoks.sortedIds.count - 1) {
                if (tiktoks.justuploaded) {
                    self.curr_video = 0
                    tiktoks.justuploaded.toggle()
                } else {
                    self.curr_video+=1
                }
                
                
            }
            else if (curr_video + 1 == tiktoks.sortedIds.count) {
                self.curr_video = 0
            }

            // register as seen
            tiktoks.entries[tiktoks.sortedIds[curr_video]]?.seen = 1
            tiktoks.registerAsSeen(id: tiktoks.sortedIds[curr_video])
            title = tiktoks.entries[tiktoks.sortedIds[curr_video]]?.title ?? "no title"
            curr_likes = tiktoks.entries[tiktoks.sortedIds[curr_video]]?.likes ?? 0
            print(tiktoks.entries[tiktoks.sortedIds[curr_video]]?.url ?? "BRUH")
        }

    }
    
    func update_video_list() {
        print(tiktoks.sortedIds)
        tiktoks.sortit()
        print(tiktoks.sortedIds)
        // call update and sort everything based on seen and not seen
    }
    
    // video player

}



