//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by milkyway on 02.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var setGame: SetGame<CardContent>
    
    init() {
        setGame = SetGameViewModel.createSetGame()
    }
    
    var activeCards: [SetGame<CardContent>.Card] {
        setGame.activeCards
    }
    
    var cards: [SetGame<CardContent>.Card] {
        setGame.cards
    }
    
    var score: Int {
        setGame.score
    }

    var selectedCardsCount: Int {
        setGame.indicesOfSelectedCards.count
    }
    
    
    static func createSetGame() -> SetGame<CardContent> {
        SetGame(numberOfSetsOfCards: CardType.allCases.count) { (i, j, k, t) in
//            print ( "\(CardType.allCases[i]); \(CardColor.allCases[j]); \(FillContent.allCases[k])" )
            CardContent(content: CardType.allCases[i], color: CardColor.allCases[j], fill: CardFill.allCases[k], amount: t)


        }
    }
    
    //MARK: Intents
    
    func choose(card: SetGame<CardContent>.Card) {
        if card.isSelected {
            if selectedCardsCount != 3 || !card.isMatched {
                setGame.deselect(card)
            }
        } else {
            setGame.select(card)
        }

    }
    
    func help() {
        setGame.help()
    }
    
    func noSet() {
        setGame.noSetFound()
    }
    
    func newGame() {
        setGame = SetGameViewModel.createSetGame()
    }
    
//    func playGame() {
//        setGame.playGame()
//    }
    
    struct CardContent: CardContentDeterminable {
        var content: CardType
        var color: CardColor
        var fill: CardFill
        var amount: Int
    }
    
    enum CardType: TypeContentDeterminable, CaseIterable {
        case capsule, rectangle, diamond
        
        var type: Int {
            switch self {
            case .capsule:
                return 1
            case .rectangle:
                return 2
            case .diamond:
                return 3
            }
        }
    }
    
    enum CardColor: TypeContentDeterminable, CaseIterable {
        case blue, red, green
        
        var type: Int {
            switch self {
            case .blue:
                return 1
            case .red:
                return 2
            case .green:
                return 3
            }
        }
        
        var view: Color {
            switch self {
            case .blue:
                return Color.blue
            case .green:
                return Color.green
            case .red:
                return Color.red
            }
        }
    }
    
    enum CardFill: TypeContentDeterminable, CaseIterable {
        case striped, empty, filled
        
        var type: Int {
            switch self {
            case .striped:
                return 1
            case .empty:
                return 2
            case .filled:
                return 3
            }
        }
        
        var opacity: Double {
            switch self {
            case .empty:
                return 0
            case .filled:
                return 1
            case .striped:
                return 0.2
            }
        }
    }
}
