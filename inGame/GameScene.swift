//
//  GameScene.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2017-12-30.
//  Copyright © 2017 Leo's Apps. All rights reserved.
//

import SpriteKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player = SKSpriteNode(imageNamed: "playerBall")
    var explosionSound = SKAction.playSoundFileNamed("explosionSound.mp3", waitForCompletion: false)
    let tapToStartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var gameArea:CGRect
    var levelNumber = 0
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    enum gameState{
        case preGame // before the start of the game
        case inGame // during game play
        case afterGame // game is over
    }
    
    var currentGameState = gameState.preGame
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Enemy: UInt32 = 0b10 //2
    }
    
    enum gameLayers: CGFloat {
        case theBackground
        case theEnemy
        case thePlayer
        case theExplosion
        case theScoreLabel
        case theTapToStartLabel
    }
    
    // MARK: - Set area where user can play
    override init(size: CGSize) {
        // iphones screens have an aspect ratio of 16:9
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Random float generator
    // So that enemies will spawn in random places
    func random()->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random ( min: CGFloat, max: CGFloat) -> CGFloat{
        return random()*(max-min)+min
        
    }
    
    func spawnEnemy(){
        
        // MARK: Setting up the enemy and its behaviour
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        // this is where is spawns
        let startPoint = CGPoint(x:randomXStart,y:self.size.height*1.2)
        // then the enemy moves downward towards the player
        let endPoint = CGPoint(x: randomXEnd, y:-self.size.height*0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyBall")
        enemy.name = "Enemy"
        enemy.setScale(0.7)
        enemy.position = startPoint
        enemy.zPosition = gameLayers.theEnemy.rawValue
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(enemy.size.width/2))
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        
        
        // move the enemy down and delete its in the same x-axis as the player
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.6)
        let deleteEnemy = SKAction.removeFromParent()
        let addScoreAction = SKAction.run(addScore)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, addScoreAction])
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        // determine difference between endPoint and startPoint
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        //rotating enemy slightly as it falls
        enemy.zRotation = amountToRotate
        
        self.addChild(enemy)
        
    }
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber{
        case 1: levelDuration = 1.0
        case 2: levelDuration = 0.6
        case 3: levelDuration = 0.5
        case 4: levelDuration = 0.35
        default:
            levelDuration = 0.7
            //print("cannot find level info")
            
        }
        
        // MARK: - Enemy spawns every second
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    
    func addScore(){
        // increment by 1 everytime player dodges an enemy
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        // make game harder
        if gameScore == 2 || gameScore == 10 || gameScore == 35 {
            startNewLevel()
        }
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint){
        // MARK - Call Explosion when bodies collide
        let explosion = SKSpriteNode(imageNamed: "explosion_")
        explosion.position = spawnPosition
        explosion.zPosition = gameLayers.theExplosion.rawValue
        self.addChild(explosion)
        
        // MARK - Explosion animation
        // the explosion image size starts off small and grows so that it looks realistic
        explosion.setScale(0)
        
        let scaleIn = SKAction.scale(to: 0.5, duration:0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // which body made contact
        // MARK: - Player and Enemy collide
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            if body2.node != nil{
                if body2.node!.position.y > self.size.height{
                    return
                }
                else{
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        
        
    }
    
    
    // MARK: - Game Over
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        // MARK: - Stop all enemies on scene
        // Generate a list of all the enemies on the scene
        self.enumerateChildNodes(withName: "Enemy"){
            // cycle through the list calling each enemy ship
            enemy, stop in
            // then take away all of its action
            enemy.removeAllActions()
        }
        
        // MARK: - Change Scene
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1.0)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        // MARK: - Background setup
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "dayBackground")
            // Set background to have the same size as the screen
            background.size = self.size
            // change anchor point
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            // Set background at center of screen
            background.position = CGPoint(x:self.size.width/2, y:self.size.height*CGFloat(i))
            // Layering (set it at the back)
            background.zPosition = gameLayers.theBackground.rawValue
            background.name = "Background"
            self.addChild(background)
        }
        
        
        // MARK: - Player setup
        // .setScale(1) is normal size
        // 0.8 is SMALLER in size
        player.setScale(1)
        // Position
        player.position = CGPoint(x: self.size.width/2, y: 0-player.size.height)
        player.zPosition = gameLayers.thePlayer.rawValue
        // setting up physics body
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        // MARK: - Score Label setup
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.darkText
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = gameLayers.theScoreLabel.rawValue
        self.addChild(scoreLabel)
        
        
        let moveScoreToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveScoreToScreenAction)
        

        
        // MARK: - Tap to begin
        tapToStartLabel.text = "Tap To Start"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        tapToStartLabel.zPosition = gameLayers.theTapToStartLabel.rawValue
        tapToStartLabel.alpha = 0
        
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
    }
    
    func startGame(){
        
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            // MARK: - Player taps to start the game
            startGame()
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // MARK: - Move player left or right
        for touch: AnyObject in touches{
            // get the cordinates of where the user touches
            let pointOfTouch = touch.location(in:self)
            // get their position of previous touch
            let previousPointOfTouch = touch.previousLocation(in:self)
            // take that distance
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
                // and shift the player that amount of distance
                player.position.x += amountDragged
            }
            
            // make player stay in the gamearea (the left and right edges of the game)
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width/2
            }
            
            
        }
        
    }
    // stores time of the last frame, so that it can be updated to the current frame
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    // MARK: - Move the background
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // runs once per frame
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            // once that background has left the bottom of the screen, start moving it to the top
            // it will move back down and continue scrowling forever
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }

        
    }
    
    
}


