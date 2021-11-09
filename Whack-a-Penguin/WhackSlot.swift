//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Nick Sagan on 09.11.2021.
//

import SpriteKit

class WhackSlot: SKNode {
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
}
