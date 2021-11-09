//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Nick Sagan on 09.11.2021.
//

import SpriteKit

class GameScene: SKScene {
    var popupTime = 0.85
    var numRounds = 0
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: frame.minX + 8, y: frame.minY + 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
            print("Create enemy")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            if node.name == "startAgain" {
                numRounds = 0
                score = 0
                popupTime = 0.85
                
                childNode(withName: "startAgain")?.removeFromParent()
                childNode(withName: "startAgain")?.removeFromParent()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    [weak self] in
                    self?.createEnemy()
                    print("Create enemy")
                }
            }
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else {continue}
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
                whackSlot.charNode.xScale = 0.75
                whackSlot.charNode.yScale = 0.75
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {

            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
            gameOver.zPosition = 1
            gameOver.name = "startAgain"
            addChild(gameOver)
            
            let finalScoreLabel = SKLabelNode(fontNamed: "chalkduster")
            finalScoreLabel.text = "Your score: \(score)"
            finalScoreLabel.position = CGPoint(x: frame.midX, y: gameOver.position.y - 60)
            finalScoreLabel.zPosition = 1
            finalScoreLabel.name = "startAgain"
            addChild(finalScoreLabel)
            
            run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            return
        } else {
            popupTime *= 0.991
            
            slots.shuffle()
            slots[0].show(hideTime: popupTime)
            
            if Int.random(in: 0...12) > 4 {slots[1].show(hideTime: popupTime)}
            if Int.random(in: 0...12) > 8 {slots[2].show(hideTime: popupTime)}
            if Int.random(in: 0...12) > 10 {slots[3].show(hideTime: popupTime)}
            if Int.random(in: 0...12) > 11 {slots[4].show(hideTime: popupTime)}
            
            let minDelay = popupTime / 2.0
            let maxDelay = popupTime * 2
            let delay = Double.random(in: minDelay...maxDelay)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                [weak self] in
                self?.createEnemy()
            }
        }
        

    }
}
