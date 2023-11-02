//
//  Scores.swift
//  assign1
//
//  Created by Nathan B on 5/8/23.
//

import SwiftUI


struct ScoresView: View {
    let scores: [Score]
    
    var body: some View {
        VStack {
            Text("Highest Scores")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(5)
            List {
                
                ForEach(Array(scores.sorted(by: { $0.score > $1.score }).enumerated()), id: \.1) { index, score in
                    VStack {
                        HStack {
                            Text("\(index+1))              \(score.score)              ").font(.system(size: 14))
                            Text("\(score.time  , formatter: dateFormatter)").font(.system(size: 14))
                            
                        }
                    }
                }
                
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, d, MMMM, yyyy"
        return dateFormatter
    }()
}


