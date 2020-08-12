//
//  ContentView.swift
//  Set Game
//
//  Created by milkyway on 01.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGameViewModel: SetGameViewModel
    @State var cardShakeSwitch = false
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.setGameViewModel.newGame()
                    }
                }, label: {
                    Text("New game")
                })
                        .padding(.trailing, 5)
            }

            HStack {
                Text("Cards left: \(setGameViewModel.cards.count + setGameViewModel.activeCards.count)")
                    .font(.title)
                    .bold()
                    .padding(.leading, 5)
                    .animation(.none)
                
                Spacer()
            }

            Grid(setGameViewModel.activeCards){ card in
                CardView(card: card, setGameViewModel: self.setGameViewModel)
                        .aspectRatio(3/4, contentMode: .fit)
                        .padding(8)
                        .shake(data: self.cardShakeSwitch ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.setGameViewModel.choose(card: card)
                                if self.setGameViewModel.selectedCardsCount == 3 &&
                                        !self.setGameViewModel.selectedMakeSet {
                                    self.cardShakeSwitch = !self.cardShakeSwitch
                                }
                            }
                        }
                        .transition(
                                .offset(
                                        x: self.offsetCoordinateOutsideScreen,
                                        y: self.offsetCoordinateOutsideScreen
                                )
                        )
            }
            
            NavigatorView(setGameViewModel: setGameViewModel)
                    .foregroundColor(.blue)
        }
                .padding()
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        self.setGameViewModel.newGame()
                    }

                }

    }
    
    private var offsetCoordinateOutsideScreen: CGFloat {
        [CGFloat.random(in: -1000..<(-500)), CGFloat.random(in: 500..<1000)].randomElement()!
    }
}

struct CardView: View {
    var card: SetGame<SetGameViewModel.CardContent>.Card
    @ObservedObject var setGameViewModel: SetGameViewModel

    var body: some View {
        Group {
            if card.data.content.type == 1 {
                CapsuleView(card: card)
            } else if card.data.content.type == 2 {
                RectangleView(card: card)
            } else if card.data.content.type == 3 {
                DiamondView(card: card)
            }
        }
                .padding()
                .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                .cardify(thickness: card.isPartOfSetFoundByAI ? 8 : 3)
                .padding(card.isSelected ? 8 : 0)
                .foregroundColor(.blue)
    }
}

struct NavigatorView: View {
    @ObservedObject var setGameViewModel: SetGameViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .frame(height: 50)
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.setGameViewModel.noSet()
                    }
                }, label: {
                    Text("No set")
                })

                Spacer()

                Text("Score: \(setGameViewModel.score)").animation(.none).font(.title)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut) {
                        self.setGameViewModel.help()
                    }
                }, label: {
                    Text("Get help")
                })
            }
                    .foregroundColor(.primary)
                    .font(.headline)
                    .padding()
        }
    }
}

struct CapsuleView: View {
    var card: SetGame<SetGameViewModel.CardContent>.Card
    var body: some View {
        GeometryReader { reader in
            VStack {
                ForEach(0..<self.card.data.amount) { i in
                    ZStack {
                        Capsule()
                            .stroke(lineWidth: 2)
                            
                        Capsule()
                            .opacity(self.card.data.fill.opacity)
                    }
                }
            }
            .foregroundColor(self.card.data.color.view)
            .frame(height: reader.size.height)
        }
    }
}

struct RectangleView: View {
    var card: SetGame<SetGameViewModel.CardContent>.Card
    var body: some View {
        GeometryReader { reader in
            VStack {
                ForEach(0..<self.card.data.amount) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                        RoundedRectangle(cornerRadius: 10)
                            .opacity(self.card.data.fill.opacity)
                        
                    }
                }
            }
                    .foregroundColor(self.card.data.color.view)
                    .frame(height: reader.size.height)
        }
    }
}

struct DiamondView: View {
    var card: SetGame<SetGameViewModel.CardContent>.Card
    var body: some View {
        GeometryReader { reader in
            VStack {
                ForEach(0..<self.card.data.amount) { i in
                    ZStack {
                        Diamond()
                            .stroke(lineWidth: 2)
                        Diamond()
                            .opacity(self.card.data.fill.opacity)
                        
                    }
                }
            }
                    .foregroundColor(self.card.data.color.view)
                    .frame(height: reader.size.height)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(setGameViewModel: SetGameViewModel())
    }
}
