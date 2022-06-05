//
//  ContentView.swift
//  Connect Four Duos
//
//  Created by Luke Drushell on 6/5/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
     
    @State var board: [[Int]] = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
    var device = deviceScreen()
    @State var info = 1
    @State var hoverCircle = -1
    
    
    @State var pressing1 = false
    //1 = Player 1's Turn, 2 = Player 2's Turn, 3 = Player 1 Won, 4 = Player 2 Won
    
    var body: some View {
        ZStack {
            Color.teal.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text(info == 1 ? "Player 1's Turn!" : "Player 2's Turn!")
                    .bold()
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(5)
                Text(board == [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]] ? "Hold on a Column to Place a Puck!" : " ")
                    .bold()
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.headline)
                    .padding(5)
                Spacer()
                HStack {
                    ForEach(board.indices, id: \.self, content: { index in
                        Circle()
                            .frame(width: device.width / 11, height: device.width / 11, alignment: .center)
                            .foregroundColor(info == 1 ? .red : .yellow)
                            .opacity(hoverCircle == index ? 1 : 0)
                            .padding(3)
                    })
                }
                .padding(10)
                VStack {
                HStack {
                    ForEach(board.indices, id: \.self, content: { index in
                        VStack {
                            ForEach(board[index].indices, id: \.self, content: { i in
                                Circle()
                                    .frame(width: device.width / 11, height: device.width / 11, alignment: .center)
                                    .foregroundColor(puckColor(board[index][i]))
                            })
                        }
                        .padding(3)
                        .onLongPressGesture(perform: {
                            hoverCircle = index
                        })
                        .onTapGesture(perform: {
                            hoverCircle = -1
                        })
                    })
                }
                .padding(10)
                .background(.blue)
                .cornerRadius(10)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 4)
                })
                } .scaleEffect(CGSize(width: 1.0, height: -1.0))
                Spacer()
                Button {
                    if hoverCircle != -1 {
                        AudioServicesPlaySystemSound(1103)
                        var found = false
                        for i in board[hoverCircle].indices {
                            if board[hoverCircle][i] == 0 && (found == false) {
                                board[hoverCircle][i] = info
                                found = true
                                if info == 1 {
                                    info = 2
                                } else {
                                    info = 1
                                }
                            }
                        }
                    }
                } label: {
                    Text("Drop Puck")
                        .foregroundColor(.white)
                        .frame(width: device.width * 0.8, height: 80, alignment: .center)
                        .background(.green)
                        .cornerRadius(15)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 4)
                        })
                } .padding()
                Button {
                    board = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
                    info = 1
                    hoverCircle = -1
                    AudioServicesPlaySystemSound(1026)
                } label: {
                    Text("Reset")
                        .foregroundColor(.white)
                        .frame(width: device.width * 0.8, height: 80, alignment: .center)
                        .background(.red)
                        .cornerRadius(15)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 4)
                        })
                } .padding(.bottom, 30)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct puck {
    let x: Int
    let y: Int
}

class deviceScreen: ObservableObject {
    @Published var width = UIScreen.main.bounds.width
    @Published var height = UIScreen.main.bounds.height
}

struct Board {
    var c1: [Int]
    var c2: [Int]
    var c3: [Int]
    var c4: [Int]
    var c5: [Int]
    var c6: [Int]
    var c7: [Int]
}

func puckColor(_ num: Int) -> Color {
    var output = Color.white
    if num == 1 {
        output = .red
    } else if num == 2 {
        output = .yellow
    }
    return output
}
