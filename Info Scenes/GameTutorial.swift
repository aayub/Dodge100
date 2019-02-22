//
//  GameTutorial.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2018-01-03.
//  Copyright © 2018 Leo's Apps. All rights reserved.
//

import SpriteKit
import Foundation

class ViewGameTutorial: SKScene {
    
    override func didMove(to view: SKView) {
        
        // MARK: Background
        let tutorialBackground = SKSpriteNode(imageNamed: "gameTutorialText")
        tutorialBackground.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        tutorialBackground.zPosition = 0
        self.addChild(tutorialBackground)
        
        
    }
    
    // GO BACK TO MAIN MENU SCREEN
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let mainScene = MainMenuScene(size: self.size)
        mainScene.scaleMode = self.scaleMode
        let theTransition = SKTransition.fade(withDuration: 0.3)
        self.view!.presentScene(mainScene, transition: theTransition)
        
    }
    
    
}
