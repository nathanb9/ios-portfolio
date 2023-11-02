//
//  Videos.swift
//  OpenTok
//
//  Created by Nathan B on 5/17/23.
//



import Firebase
import FirebaseDatabase
import Foundation

class Videos: ObservableObject {
    
    @Published var entries: [String:Video] = [:]
    @Published var sortedIds: [String] = []
    @Published var justuploaded = false
    //@Published var likes:
    init() {
        let rootRef = Database.database().reference()
        
        // OBSERVER for video being added
        rootRef.child("urls").observe(.childAdded) { snapshot in
            if let entry = self.getEntries(snapshot) {
                print("INSERTED")
                self.entries[snapshot.key] = entry
                self.sortedIds.append(snapshot.key)
                self.sortit()
            }
            
            
            print("OBSERVER TRIGGERED")
            print(self.entries)
        }
        rootRef.child("urls").observe(.value) { snapshot in
            if let val = snapshot.value as? NSDictionary,
               let entry = Video.fromDict(val),
               let id = entry.id {self.entries[id] = entry}
        }
        
    }
    
    func sortit() {
        sortedIds = bubbleSort(arr: &sortedIds, cmp: cmp)
    }
    
    func bubbleSort<T>(arr: inout [T], cmp: (T, T) -> Int) -> [T]{
        print("HELLO!! IM BUBBLE SORTING")
        if (arr.count <= 0) {
            return arr
        }
        let n = arr.count
        for i in 0..<n - 1 {
            for j in 0..<n - i - 1 {
                if cmp(arr[j], arr[j + 1]) == -1 {
                    print("YANKY SWAP")
                    arr.swapAt(j, j + 1)
                }
            }
        }
        return arr
        
    }

    // returns 1 if first should go first
    func cmp(first: String, second: String) -> Int {
        print("comparing")
        print(first)
        print(second)
        let first_seen: Int = entries[first]?.seen ?? 0
        let second_seen: Int = entries[first]?.seen ?? 0
        // if first_seen has not been seen
        if (first_seen < second_seen) {
            return 1
            // second has not been seen
        } else if (first_seen > second_seen) {
            return -1
        } else {
            if (self.getLikes(id: first) > self.getLikes(id: second)) {
                return 1
            } else {
                return -1
            }
            // they are the same then compare with LIKES
        }
 
    }
    // TODO: update likes and get likes
    func getLikes(id: String) -> Int {
        return self.entries[id]?.likes ?? 0
    }
    func increaseLikes(id: String) -> Int {
        let ref = Database.database().reference().child("urls").child(id).child("likes")
        var likesfinal = 0
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if var likes = snapshot.value as? Int {
                
                likes += 1
                ref.setValue(likes)
                likesfinal = likes
                self.entries[id]?.likes = likes
            }
            
        }
        
        //entries[id]?.likes += 1
        //Database.database().reference().child("urls").child(id).child("likes").setValue(1)
        return likesfinal
    }
    func getUrl(index: Int) -> String? {
        if(sortedIds.count <= 0 || index < 0) {
            return ""
        }
        return self.entries[self.sortedIds[index]]?.url
    }
    
    private func getEntries(_ ds: DataSnapshot) -> Video? {
        if let dict = ds.value as? NSDictionary,
           let video = Video.fromDict(dict) {
            print("HELLO!")
            // init(id: String? ,url: String, title: String, seen: Int)
            return Video(id: ds.key, url: video.url, title: video.title,seen: video.seen, likes: video.likes)
        }
        return nil
        
    }
    func registerAsSeen(id: String) {
        Database.database().reference().child("seen").child("tiktokuser12").child(id).setValue("1")
        let ref = Database.database().reference().child("urls").child(id).child("seen")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if let seen = snapshot.value as? Int {
                
                
                ref.setValue(1)
                self.entries[id]?.seen = seen
            }
            
        }
    }
    // end of init()
    

}
