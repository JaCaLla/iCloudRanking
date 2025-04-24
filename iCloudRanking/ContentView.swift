//
//  ContentView.swift
//  CloudKitRanking
//
//  Created by JAVIER CALATRAVA LLAVERIA on 23/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var ckManager = CloudKitManager()
    @State private var playerName = ""
    @State private var playerPoints = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Name", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Points", text: $playerPoints)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Button("Add") {
                        if let points = Int(playerPoints) {
                                ckManager.addScore(name: playerName, points: points)
                                playerName = ""
                                playerPoints = ""
                                //ckManager.fetchScores()
                        }
                    }
                }
                .padding()

                List(ckManager.scores) { score in
                    HStack {
                        Text(score.name)
                        Spacer()
                        Text("\(score.points)")
                    }
                }
            }
            .navigationTitle("iCloudRanking")
//            .onAppear {
//                ckManager.fetchScores()
//            }
        }
    }
}
