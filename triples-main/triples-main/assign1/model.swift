//
//  model.swift
//  assign1
//
//  Created by Nathan B on 3/23/23.
//
import SwiftUI

struct Tile {
    // val - represents the value to be shown on the board
    var val : Int
    // id - is an unique id for this tile
    var id : Int
    var row: Int
    var col: Int
}

class Triples:  ObservableObject{
    
    var board: [[Tile?]]{
        willSet {
            objectWillChange.send()
        }
    }
    
    var score: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isDone: Bool = false{
        willSet {
            objectWillChange.send()
        }
    }
    
    var freeSpace: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    enum Direction: Int, CaseIterable {
        case up
        case down
        case left
        case right
    }
    

    init() {
        score = 0
        freeSpace = 16
        board = [[nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil]]
        isDone = false
    }
    // re-inits 'board', and any other state you define
    func newgame() {

        
        board = [[nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil]]
        score = 0
        freeSpace = 16
        isDone = false
    }
    
    func self_init() {
        board = [[nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil],
                 [nil,nil,nil,nil]]
         
        score = 0
        freeSpace = 16
        isDone = false
    }
    // Build a func rotate2DInts that will take any 2D Int array and
    // rotate it once clockwise. Your func may assume that the array is
    // square.
    func rotate() {
        //self.board = rotate2D(input: self.board)
        self.board = rotate2D(input: self.board)
    }
    func isGameDone() -> Bool {
        if (!cancollapse(dir: Direction.left) && !cancollapse(dir: Direction.right) && !cancollapse(dir: Direction.up) && !cancollapse(dir: Direction.down)) {
            isDone = true
            return true
        }
        isDone = false
        return isDone
    }
    
/*
    func shift() -> Bool{
        // loop through each row
        for row in 0..<board.count {
            // loop through each column
            for back_pointer in 0..<board[row].count-1 {
                let front_pointer = back_pointer + 1
                // if nothing on the one on the left
                if (board[row][back_pointer] == 0) {
                    board[row][back_pointer] = board[row][front_pointer]
                    board[row][front_pointer] = 0
                } else {
                    // both have something
                    if (board[row][back_pointer] != 0 && board[row][front_pointer] != 0) {
                        // merging happens
                        //
                        // Suppose we have a row of tiles as:

                        // (val: 1, id: 13), (val:2, id:14), nil, nil


                        //If we collapsing left, we want id = 13 to disapper, while moving id = 14 to its left, and change its value to 3. This will make the animation in View more straightforward. You should change shift() function in your model to handle this task.
                        self.freeSpace += 1
                    }
                    board[row][back_pointer] =  board[row][back_pointer] + board[row][front_pointer]
                        board[row][front_pointer] = 0
                    
                    
                }
                
            }
        }
        return true
    }
 */
    func shift() -> Bool {
        var hasshifted = false
        // loop through each row
        for row in 0..<board.count {
            // loop through each column
            var didshift: Bool = false
            for back_pointer in 0..<board[row].count-1 {
                
                let front_pointer = back_pointer + 1
                // if the back one is EMPTY and FRONT is not empty
                if (board[row][back_pointer] == nil && board[row][front_pointer] != nil) {
                    board[row][back_pointer]?.val = board[row][front_pointer]?.val ?? -40
                    board[row][back_pointer] = board[row][front_pointer]
                    board[row][front_pointer] = nil
                    hasshifted = true
                } else {
                    if ((board[row][back_pointer] != nil && board[row][front_pointer]?.val != nil) && !didshift && ((((board[row][back_pointer]?.val ?? 4) % 3 == 0 && (board[row][front_pointer]?.val ?? 0) % 3 == 0) && (board[row][back_pointer]?.val == board[row][front_pointer]?.val)) || (board[row][back_pointer]!.val + (board[row][front_pointer]?.val ?? 0) == 3))) {
                        // the two numbers are div by 3 AND havent shifted this row yet AND they are the same
                        let sum = board[row][back_pointer]!.val + (board[row][front_pointer]?.val ?? 0)
                        score += sum
                        board[row][back_pointer] = board[row][front_pointer]
                        board[row][back_pointer]?.val = sum
                        board[row][front_pointer] = nil

                        self.freeSpace += 1
                        didshift = true
                        hasshifted = true
                    } else {
                        
                    }
                    
                }
                
            }
        }
        return hasshifted
    }
    
    func cancollapse(dir: Direction) -> Bool {
        var rotations: Int = 0
        var rt: Int = 0
        if (dir == Direction.left) {
            rt = 0
        } else if (dir == Direction.right) {
            rt = 2
        } else if (dir == Direction.down) {
            rt = 1
        } else if (dir == Direction.up) {
            rt = 3
        }
        while rotations < rt {
            rotate(); rotations += 1
        }
        
        let didshift: Bool = shift()
        
        rotations = 4 - rotations
        while (dir != .left) && (rotations > 0) {
            rotate(); rotations -= 1
        }
        
        return didshift
    }
    
    
    
    func canshift() -> Bool {
        
        
        for row in 0..<board.count {
            
            
            for back_pointer in 0..<board[row].count-1 {
                
                let front_pointer = back_pointer + 1
                if (board[row][back_pointer] == nil && board[row][front_pointer] != nil) {
                    return true
                } else {
                    if ((board[row][back_pointer] != nil && board[row][front_pointer]?.val != nil)  && ((((board[row][back_pointer]?.val ?? 4) % 3 == 0 && (board[row][front_pointer]?.val ?? 0) % 3 == 0) && (board[row][back_pointer]?.val == board[row][front_pointer]?.val)) || (board[row][back_pointer]!.val + (board[row][front_pointer]?.val ?? 0) == 3))) {
                        return true
                    } else {
                        
                    }
                    
                }
                
            }
        }
        return false
    }

    // collapse in specified direction using shift() and rotate()
    func collapse(dir: Direction) -> Bool {
        var rotations: Int = 0
        var rt: Int = 0
        if (dir == Direction.left) {
            rt = 0
        } else if (dir == Direction.right) {
            rt = 2
        } else if (dir == Direction.down) {
            rt = 1
        } else if (dir == Direction.up) {
            rt = 3
        }
        while rotations < rt {
            rotate(); rotations += 1
        }
            
        let didshift: Bool = shift()
            
        rotations = 4 - rotations
        while (dir != .left) && (rotations > 0) {
            rotate(); rotations -= 1
        }
            
        return didshift
        /*
        if (dir == Direction.down) {
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
            self.shift()
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
        }
        if (dir == Direction.left) {
            self.shift()
        }
        if (dir == Direction.right) {
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
            self.shift()
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
        }
        if (dir == Direction.up) {
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
            self.shift()
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
            self.board = rotate2D(input: board)
        }
         */
    }
}

// class-less function that will return of any square 2D Int array rotated clockwise
func rotate2D<T>(input: [[T]]) -> [[T]] {
    var output = [[T]]()
    
    for y in 0..<input.count {
        output.append([])
        for x in 0..<input[y].count {
            output[y].append(input[input.count - x - 1][y])
            
        }
    }
    return output
}

func rotate2DInts(input: [[Int]]) -> [[Int]] {
    return rotate2D(input: input)
}
