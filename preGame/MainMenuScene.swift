//
//  MainMenuScene.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2017-12-30.
//  Copyright © 2017 Leo's Apps. All rights reserved.
//

import Foundation
import SpriteKit



class MainMenuScene: SKScene{
    
    enum Layers: CGFloat{
        case Background
        case Labels
    }
    
    override func didMove(to view: SKView) {
        // MARK: Background
        let background = SKSpriteNode(imageNamed: "dayBackground")
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = Layers.Background.rawValue
        self.addChild(background)
        
        // MARK: "game by" Lable
        let gameBy = SKLabelNode(fontNamed: "HelveticaNeue-Italic")
        gameBy.text = "Leo's Code Production"
        gameBy.position = CGPoint(x:self.size.width/2, y:self.size.height*0.78)
        gameBy.fontSize = 70
        gameBy.fontColor = SKColor.white
        gameBy.zPosition = Layers.Labels.rawValue
        self.addChild(gameBy)
        
        // MARK: Solo Label
        let gameName = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameName.text = "Dodge"
        gameName.fontColor = SKColor.white
        gameName.fontSize = 200
        gameName.position = CGPoint(x:self.size.width/2, y:self.size.height*0.7)
        gameName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameName.zPosition = Layers.Labels.rawValue
        self.addChild(gameName)
        
        // MARK: Mission
        let gameName2 = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameName2.text = "100"
        gameName2.fontColor = SKColor.white
        gameName2.fontSize = 200
        gameName2.position = CGPoint(x:self.size.width/2, y:self.size.height*0.610)
        gameName2.zPosition = Layers.Labels.rawValue
        self.addChild(gameName2)
        
        
        // MARK: "Start Game" Button Label
        let startGame = SKLabelNode(fontNamed: "Helvetica-Bold")
        startGame.text = "Start Game"
        startGame.name = "Start Button"
        startGame.fontColor = SKColor.white
        startGame.fontSize = 150
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        startGame.zPosition = Layers.Labels.rawValue
        self.addChild(startGame)
        
        // MARK: View Credits
        let viewCredits = SKLabelNode(fontNamed: "Helvetica")
        viewCredits.text = "View Credits"
        viewCredits.name = "View the Credits"
        viewCredits.fontColor = SKColor.black
        viewCredits.fontSize = 40
        viewCredits.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.15)
        viewCredits.zPosition = Layers.Labels.rawValue
        self.addChild(viewCredits)
        
        
        // MARK: View Game Tutorial
        let howToPlay = SKLabelNode(fontNamed: "Helvetica")
        howToPlay.text = "Game Tutorial"
        howToPlay.name = "View Game Tutorial"
        howToPlay.fontColor = SKColor.black
        howToPlay.fontSize = 40
        howToPlay.position = CGPoint(x: self.size.width*0.70, y: self.size.height*0.15)
        howToPlay.zPosition = Layers.Labels.rawValue
        self.addChild(howToPlay)
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            let myTransition = SKTransition.fade(withDuration: 0.5)
            
            if nodeITapped.name == "Start Button"{
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
            if nodeITapped.name == "View the Credits"{
                
                let creditsScene = ViewCredits(size: self.size)
                creditsScene.scaleMode = self.scaleMode
                self.view?.presentScene(creditsScene, transition: myTransition)
                
            }
            
            if nodeITapped.name == "View Game Tutorial"{
                
                let tutorialScene = ViewGameTutorial(size: self.size)
                tutorialScene.scaleMode = self.scaleMode
                self.view?.presentScene(tutorialScene, transition: myTransition)
                
            }
            
            
        }
    }
}

