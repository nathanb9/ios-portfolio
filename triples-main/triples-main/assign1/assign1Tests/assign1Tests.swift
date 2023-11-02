//
//  assign1Tests.swift
//  assign1Tests
//
//  Created by Nathan B on 3/23/23.
//

import XCTest
@testable import assign1

final class assign1Tests: XCTestCase {
    func testSetup() {
        let game = Triples()
        game.newgame()
        
        XCTAssertTrue((game.board.count == 4) && (game.board[3].count == 4))
    }
    func testRotate1() {
        var board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        board = rotate2DInts(input: board)
        XCTAssertTrue(board == [[3,0,1,0],[3,2,2,3],[6,1,3,3],[6,3,3,3]])
    }
    
    func testShift() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.shift()
        XCTAssertTrue(game.board == [[3,3,3,0],[3,3,3,0],[2,1,3,0],[6,6,6,0]])
    }
    func testLeft() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .left)
        XCTAssertTrue(game.board == [[3,3,3,0],[3,3,3,0],[2,1,3,0],[6,6,6,0]])
    }

    func testRight() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .right)
        XCTAssertTrue(game.board == [[0,0,3,6],[0,1,2,6],[0,0,3,3],[0,3,3,12]])
    }

    func testDown() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .down)
        XCTAssertTrue(game.board == [[0,3,0,0],[0,2,6,3],[1,2,1,6],[3,3,6,6]])
    }

    func testUp() {
        let game = Triples()
        game.board = [[0,3,3,3],[1,2,3,3],[0,2,1,3],[3,3,6,6]]
        game.collapse(dir: .up)
        XCTAssertTrue(game.board == [[1,3,6,6],[0,2,1,3],[3,2,6,6],[0,3,0,0]])
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
