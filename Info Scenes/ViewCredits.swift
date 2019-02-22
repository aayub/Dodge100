//
//  ViewCredits.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2018-01-02.
//  Copyright © 2018 Leo's Apps. All rights reserved.
//

import SpriteKit
import Foundation

class ViewCredits: SKScene {
    
    override func didMove(to view: SKView) {
        
        // MARK: Background
        let creditsBackground = SKSpriteNode(imageNamed: "creditBackgroundText")
        creditsBackground.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        creditsBackground.zPosition = 0
        self.addChild(creditsBackground)
        
        
    }
    
    // GO BACK TO MAIN MENU SCREEN
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let mainScene = MainMenuScene(size: self.size)
        mainScene.scaleMode = self.scaleMode
        let theTransition = SKTransition.fade(withDuration: 0.3)
        self.view!.presentScene(mainScene, transition: theTransition)
            
        }
        
    
    }
    
    
    
    
    
    
    

    
    
    
    
    
    

    

    
    
    

