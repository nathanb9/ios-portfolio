//
//  BoardView.swift
//  assign1
//
//  Created by Nathan B on 5/9/23.
//

import SwiftUI

struct BoardView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    struct TileView: View {
        var tile = Tile(val: 0, id: 0, row: 0, col: 0)
        
        
        init(tile: Tile) {
            self.tile = tile
            
        }
        
        var body: some View {
            Text(tile.val.description)
        }
        
    }
    enum Direction {
        case up
        case down
        case left
        case right
    }
    @State var selected = "Determ"
    @State var random = true
    @State var seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
    @State var generator: RandomNumberGenerator = SeededGenerator(seed: 14)
    @State var idCounter = 0
    @State var gameover = false
    @State private var znewgame = true
    @State private var fontSize = 25.0
    var options = ["Random","Determ"]
    @Binding var scores: [Score]
    @StateObject var game: Triples = Triples()
    
    var body: some View {
        if (verticalSizeClass == .regular) {
            ZStack {
                
                VStack {
                    Text("Score: \(game.score)").font(.system(size: 30))
                    
                    
                    VStack {
                        ForEach(0..<game.board.count) { rowIndex in
                            HStack {
                                ForEach(0..<game.board[rowIndex].count) { colIndex in
                                    let tile = game.board[rowIndex][colIndex] ?? Tile.init(val: 0, id: 169, row: 169, col: 169)
                                    TileView(tile: tile)
                                        .offset(x: 1, y: 1)
                                        .frame(maxWidth: 40, maxHeight: 40)
                                        .background(getMyColor(tile: tile))
                                        .border(Color.gray, width: 1)
                                        .animation(.easeInOut(duration: 1))
                                        .bold()
                                }
                            }
                        }
                    }
                    .padding(6).background(Color.gray).gesture(
                        DragGesture(minimumDistance: 50, coordinateSpace: .global)
                            .onEnded { value in
                                let gesture = value.translation
                                if gesture.width < 0 && abs(gesture.width) > abs(gesture.height) {
                                    // left gesture
                                    if (leftf()) {
                                        spawn()
                                    }
                                    
                                } else if gesture.width > 0 && abs(gesture.width) > abs(gesture.height) {
                                    // right gesture
                                    if (rightf()) {
                                        spawn()
                                    }
                                    
                                    
                                } else if gesture.height < 0 && abs(gesture.height) > abs(gesture.width) {
                                    // up gesture
                                    if(upf()) {
                                        spawn()
                                    }
                                    
                                } else if gesture.height > 0 && abs(gesture.height) > abs(gesture.width) {
                                    // down gesture
                                    if (downf()) {
                                        spawn()
                                    }
                                    
                                    
                                }
                            }
                    )
                    // START OF BUTTONS
                    Button(action: {
                        if(upf()) {
                            spawn()
                        }
                        
                    }) {
                        Text("Up")
                    }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                    HStack {
                        Button(action: {
                            withAnimation {
                                if(leftf()) {
                                    spawn()
                                }
                                
                                
                                
                            }
                        }) {
                            Text("Left")
                        }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                        Button(action: {
                            if (rightf()) {
                                spawn()
                            }
                            
                            
                        }) {
                            Text("Right")
                        }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                    }
                    Button(action: {
                        if(downf()) {
                            spawn()
                        }
                        
                        
                    }) {
                        Text("Down")
                    }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                    Button(action: {
                        gameover = true
                        znewgame = true
                        print("NEW GAME")
                        print("gameover \(gameover) znewgame \(znewgame)")
                    }) {
                        Text("New Game")
                    }.frame(maxWidth: 120, maxHeight: 30).border(Color.black, width: 2)
                    VStack {
                        Picker("", selection: $selected) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.segmented).frame(width: 200)
                    }
                    
                }.onAppear() {
                    inital_newgame()
                }
                
                if gameover && znewgame {
                    GeometryReader { geometry in
                        ZStack {
                            Color.white
                            VStack {
                                
                                Text("Score: \(game.score)")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                Button("New Game") {
                                    scores.append(Score.init(score: game.score, time: Date()))
                                    znewgame.toggle()
                                    gameover = false
                                    ng()
                                    spawn()
                                    spawn()
                                    spawn()
                                    spawn()
                                    print("NEW GAME")
                                    
                                }.background(Color.red).cornerRadius(10.0).foregroundColor(.white)
                            }
                            
                        }.onChange(of: gameover) { newValue in
                            gameover = true
                            znewgame = true
                            
                        }.cornerRadius(10.0).padding(100).shadow(radius: 10.0).frame(maxWidth: .infinity, maxHeight: 400, alignment: .trailing)
                    }
                }
            }
        } else {
            ZStack{
                
                HStack {
                    
                    VStack {
                        Text("Score: \(game.score)").font(.system(size: 30)).background(Color.white)
                        VStack {
                            
                            ForEach(0..<game.board.count) { rowIndex in
                                HStack {
                                    ForEach(0..<game.board[rowIndex].count) { colIndex in
                                        let tile = game.board[rowIndex][colIndex] ?? Tile.init(val: 0, id: 169, row: 169, col: 169)
                                        TileView(tile: tile)
                                            .offset(x: 1, y: 1)
                                            .frame(maxWidth: 40, maxHeight: 40)
                                            .background(getMyColor(tile: tile))
                                            .border(Color.gray, width: 1)
                                            .animation(.easeInOut(duration: 1))
                                            .bold()
                                    }
                                }
                            }
                        }
                        .padding(6).background(Color.gray).gesture(
                            DragGesture(minimumDistance: 50, coordinateSpace: .global)
                                .onEnded { value in
                                    let gesture = value.translation
                                    if gesture.width < 0 && abs(gesture.width) > abs(gesture.height) {
                                        // left gesture
                                        if (leftf()) {
                                            spawn()
                                        }
                                        
                                    } else if gesture.width > 0 && abs(gesture.width) > abs(gesture.height) {
                                        // right gesture
                                        if (rightf()) {
                                            spawn()
                                        }
                                        
                                        
                                    } else if gesture.height < 0 && abs(gesture.height) > abs(gesture.width) {
                                        // up gesture
                                        if(upf()) {
                                            spawn()
                                        }
                                        
                                    } else if gesture.height > 0 && abs(gesture.height) > abs(gesture.width) {
                                        // down gesture
                                        if (downf()) {
                                            spawn()
                                        }
                                        
                                        
                                    }
                                }
                        )
                    }
                    
                    VStack {
                        
                    }
                    
                    // START OF BUTTONS
                    
                    VStack {
                        Button(action: {
                            if(upf()) {
                                spawn()
                            }
                            
                        }) {
                            Text("Up")
                        }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                        HStack {
                            Button(action: {
                                withAnimation {
                                    if(leftf()) {
                                        spawn()
                                    }
                                    
                                    
                                    
                                }
                            }) {
                                Text("Left")
                            }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                            Button(action: {
                                if (rightf()) {
                                    spawn()
                                }
                                
                                
                            }) {
                                Text("Right")
                            }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                        }
                        Button(action: {
                            if(downf()) {
                                spawn()
                            }
                            
                            
                        }) {
                            Text("Down")
                        }.frame(maxWidth: 60, maxHeight: 30).border(Color.black, width: 2)
                        Button(action: {
                            gameover = true
                            znewgame = true
                            print("NEW GAME")
                            print("gameover \(gameover) znewgame \(znewgame)")
                        }) {
                            Text("New Game")
                        }.frame(maxWidth: 120, maxHeight: 30).border(Color.black, width: 2)
                        VStack {
                            Picker("", selection: $selected) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.segmented).frame(width: 200)
                        }
                        
                    }.onAppear() {
                        inital_newgame()
                    }
                }
                    


                
                if gameover && znewgame {
                    GeometryReader { geometry in
                        ZStack {
                            Color.white
                            VStack {
                                
                                Text("Score: \(game.score)")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                Button("New Game") {
                                    scores.append(Score.init(score: game.score, time: Date()))
                                    znewgame.toggle()
                                    gameover = false
                                    ng()
                                    spawn()
                                    spawn()
                                    spawn()
                                    spawn()
                                    print("NEW GAME")
                                    
                                }.background(Color.red).cornerRadius(10.0).foregroundColor(.white)
                            }
                            
                        }.onChange(of: gameover) { newValue in
                            gameover = true
                            znewgame = true
                            
                        }.cornerRadius(10.0).padding(100).shadow(radius: 10.0).frame(maxWidth: .infinity, maxHeight: 400, alignment: .trailing)
                    }
                }
            }
            
        }
        
            
        
        // END OF BUTTONS
        
        
    }
    func downf() -> Bool {
        if (game.freeSpace == 0) {
            if (game.isGameDone()) {
                gameover = true
                znewgame = true
                return false
            }
            
        }
        if(game.collapse(dir: .down)) {
            return true
        }
        return false
    }
    func upf() -> Bool{
        if (game.freeSpace == 0) {
            if (game.isGameDone()) {
                gameover = true
                znewgame = true
                return false
            }
            
        }
        if(game.collapse(dir: .up)) {
            return true
        }
        return false
    }
    func leftf() -> Bool{
        if (game.freeSpace == 0) {
            if (game.isGameDone()) {
                gameover = true
                znewgame = true
                return false
            }
        }
        if(game.collapse(dir: .left)) {
            return true
        }
        return false
    }
    func rightf() -> Bool {
        if (game.freeSpace == 0) {
            if (game.isGameDone()) {
                gameover = true
                znewgame = true
                return false
            }
            
        }
        if(game.collapse(dir: .right)) {
            return true
        }
        return false
    }
    func ng() {
        if (selected == "Random") {
            random = true
        } else {
            random = false
        }
        newgame(rand: random)
    }
    
    func getMyColor(tile: Tile?) -> Color {
        if (tile?.val == 1) {
            return Color.blue
        } else if (tile?.val == 2){
            return Color.red
        } else {
            return Color.white
        }
    }
    
    
    // newgame(rand: Bool) - reinitializes all model state. The value of
    // rand should be derived from the Random/Deterministic segmented button.
    // Note that this method should not call spawn() (calling newgame just
    // initializes an empty game). Instead, the "action" for the newgame button
    // should call newgame(), followed by four spawn()s.
    
    func newgame(rand: Bool) {
        game.self_init()
        
        if (rand == true) {
            seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
            
        } else {
            seededGenerator = SeededGenerator(seed: 14)
        }
        
    }
    
    func inital_newgame() -> Void {
        ng()
        spawn()
        spawn()
        spawn()
        spawn()
        gameover = false
    }
    
    func collapse(dir: Direction) -> Bool {
        
        return false
    }
    
    func spawn() {
        let value: Int = Int.random(in: 1...2, using: &seededGenerator)
        var index: Int = Int.random(in: 0..<game.freeSpace, using: &seededGenerator)
        idCounter += 1
        for row in 0...3 {
            for col in 0...3 {
                if (game.board[row][col] == nil) {
                    if (index == 0) {
                        game.board[row][col] = Tile(val: value, id: idCounter, row: row, col: col)
                        game.board[row][col]?.val = value
                        game.freeSpace -= 1;
                        game.score += value;
                        return
                    }
                    index -= 1
                }
                
            }
        }
        
    }
}
