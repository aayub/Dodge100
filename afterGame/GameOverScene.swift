//
//  GameOverScene.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2017-12-30.
//  Copyright © 2017 Leo's Apps. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    let restartLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    
    override func didMove(to view: SKView) {
        
        // MARK: - Background
        let background = SKSpriteNode(imageNamed: "dayBackground")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // MARK: - "Game Over" Label
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y:self.size.height*0.7)
        gameOverLabel.zPosition = 50
        self.addChild(gameOverLabel)
        
        // MARK: - Score Label
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 50
        self.addChild(scoreLabel)
        
        // MARK: - Store and update Highscore
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber,forKey: "highScoreSaved")
        }
        
        // MARK: - High Score Label
        let highScoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 50
        highScoreLabel.position = CGPoint(x:self.size.width/2, y:self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        // MARK: - Restart Button
        restartLabel.text = "Restart"
        restartLabel.fontSize = 125
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 50
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.30)
        self.addChild(restartLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in:self)
            if restartLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
    }
    
}

