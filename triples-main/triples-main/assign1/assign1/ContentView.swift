//
//  ContentView.swift
//  assign1
//
//  Created by Nathan B on 3/23/23.
//

import SwiftUI

struct Score: Hashable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}
//
struct ContentView: View {

    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    
    
    @State var scores: [Score] = [Score.init(score: 300, time: Date()),Score.init(score: 400, time: Date())]

    
    struct TileView: View {
        var tile = Tile(val: 0, id: 0, row: 0, col: 0)
        
        
        init(tile: Tile) {
            self.tile = tile
            
        }
        
        var body: some View {
            Text(tile.val.description)
        }
        
    }
    
    
    
    var body: some View {
        
        //Text("FreeSpace: \(game.freeSpace)")
        TabView {
            
            BoardView(scores: $scores)
            .padding().tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            ScoresView(scores: scores).tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            
            Text("CMSC 436")
                .font(.largeTitle).tabItem {
                    Label("About", systemImage: "info.circle")
                }
            
            
            
        }
    }
    
    
    
    func f() {
        
        
        
    }
    
    
    
    
    
    

    
}

