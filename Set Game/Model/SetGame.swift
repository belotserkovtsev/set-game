//
//  SetGame.swift
//  Set Game
//
//  Created by milkyway on 01.08.2020.
//  Copyright © 2020 belotserkovtsev. All rights reserved.
//

import Foundation

struct SetGame<CardContent> where CardContent: CardContentDeterminable {
    private(set) var cards: [Card]
    private(set) var activeCards: [Card]
    private(set) var score = 0
    private(set) var indicesOfSelectedCards: [Int]
    private(set) var previousMadeSet = false
    
    mutating func select(_ card: Card) {

        if let i = activeCards.firstIndex(matching: card) {
            activeCards[i].isSelected = true
            indicesOfSelectedCards.append(i)

            if indicesOfSelectedCards.count == 3 {
                if selectedMakeSet() {
                    previousMadeSet = true
                    indicesOfSelectedCards.forEach { i in
                        activeCards[i].isMatched = true
                    }
                    score += 20
                } else {
                    previousMadeSet = false
                }
            } else if indicesOfSelectedCards.count == 4 {
                resetSelectedCards()
            }
//            print(activeCards[i])
        }

    }

    mutating func deselect(_ card: Card) {
        if let i = activeCards.firstIndex(matching: card) {
            activeCards[i].isSelected = false
            indicesOfSelectedCards.removeAll{$0 == i}

//            print(activeCards[i])
        }
    }
    
    mutating func noSetFound() {
        if SetGame.isSetPossible(with: activeCards) {
            score -= 2
        } else if cards.count != 0 {
            if activeCards.count >= 15 {
                cards += activeCards
                
                cards.shuffle()
                activeCards = Array(cards[0..<12])
                cards.removeSubrange(0..<12)
                
            } else {
                activeCards += cards.prefix(3)
                cards.removeFirst(cards.prefix(3).count)
            }
            
        }
        else {
            //game over
            print("game over")
        }
    }
    
    mutating func help() {
        score -= 20
        for i in 0..<activeCards.count {
            for j in i+1..<activeCards.count {
                for k in j+1..<activeCards.count {
                    if activeCards[i].isMatchingForSet(with: activeCards[j]) &&
                        activeCards[i].isMatchingForSet(with: activeCards[k]) &&
                        activeCards[j].isMatchingForSet(with: activeCards[k]){
                        
                        activeCards[i].isPartOfSetFoundByAI = true
                        activeCards[j].isPartOfSetFoundByAI = true
                        activeCards[k].isPartOfSetFoundByAI = true
                        
                        return
                    }
                }
            }
        }
        
        noSetFound()
    }

    private mutating func resetSelectedCards() {
        if previousMadeSet {
            let lastIndex = indicesOfSelectedCards.popLast()!
            activeCards[lastIndex].isSelected = false

            indicesOfSelectedCards.sort()
            for (_, elementIndex) in indicesOfSelectedCards.enumerated().reversed() {
                if let e = cards.first {
                    activeCards[elementIndex] = e
                    cards.remove(at: 0)
                } else {
                    activeCards.remove(at: elementIndex)
                }

            }
        }
        indicesOfSelectedCards.forEach { i in
            activeCards[i].isSelected = false
        }
        indicesOfSelectedCards = []
    }
    
    static func isSetPossible(with cards: [Card]) -> Bool {
        for i in 0..<cards.count {
            for j in i+1..<cards.count {
                for k in j+1..<cards.count {
                    if cards[i].isMatchingForSet(with: cards[j]) &&
                        cards[i].isMatchingForSet(with: cards[k]) &&
                        cards[j].isMatchingForSet(with: cards[k]){
                        
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func selectedMakeSet() -> Bool {
        
        var content: Set<Int> = []
        var color: Set<Int> = []
        var fill: Set<Int> = []
        var amount: Set<Int> = []
        
        for i in 0..<indicesOfSelectedCards.count {
            content.insert(activeCards[indicesOfSelectedCards[i]].data.content.type)
            color.insert(activeCards[indicesOfSelectedCards[i]].data.color.type)
            fill.insert(activeCards[indicesOfSelectedCards[i]].data.fill.type)
            amount.insert(activeCards[indicesOfSelectedCards[i]].data.amount)
        }
        
        return (content.count == 1 || content.count == 3) &&
            (color.count == 1 || color.count == 3) &&
            (fill.count == 1 || fill.count == 3) &&
            (amount.count == 1 || amount.count == 3)
    }
    
    init(numberOfSetsOfCards: Int, contentFactory: (Int, Int, Int, Int) -> CardContent){
        self.cards = []
        self.activeCards = []
        self.indicesOfSelectedCards = []
        var uId = 0
        for i in 0..<numberOfSetsOfCards {
            for j in 0..<numberOfSetsOfCards {
                for k in 0..<numberOfSetsOfCards {
                    for t in 1...numberOfSetsOfCards {
                        self.cards.append(Card(data: contentFactory(i, j, k, t), id: uId))
                        uId += 1
                    }
                }
            }
        }
        
        func initCards() {
            cards.shuffle()
            activeCards = Array(cards[0..<12])
            cards.removeSubrange(0..<12)
        }
        
        initCards()
        
        while !SetGame.isSetPossible(with: activeCards) {
            cards += activeCards
            initCards()
        }
        
//        let tempArrayForTesting = Array(self.cards[0..<5])
//        self.cards = tempArrayForTesting
        
    }

    init() {
        self.cards = []
        self.activeCards = []
        self.indicesOfSelectedCards = []
    }
    
    struct Card: Identifiable {
        var isSelected = false
        var isPartOfSetFoundByAI = false
        var isMatched = false
        var data: CardContent
        var id: Int
        
        func isMatchingForSet(with card: Card) -> Bool {
            if (self.data.amount == card.data.amount &&
                self.data.color.type == card.data.color.type &&
                self.data.content.type == card.data.content.type &&
                self.data.fill.type == card.data.fill.type) ||
                (self.data.amount != card.data.amount &&
                self.data.color.type != card.data.color.type &&
                self.data.content.type != card.data.content.type &&
                self.data.fill.type != card.data.fill.type) {
                return true
            }
            return false
        }
    }
}
