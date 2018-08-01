//
//  GameScene.swift
//  AircraftSiege
//
//  Created by Herbeyg Robledo Reyes on 7/24/18.
//  Copyright © 2018 TeamLynx. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    //TIMER
    var timer = Timer()
    var seconds = 0
    var starfield:SKEmitterNode!
    var smallClouds:SKEmitterNode!
    var mediumClouds:SKEmitterNode!
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var timerLabel:SKLabelNode!
    var backgroundMusic: SKAudioNode!
    
    
    var red:CGFloat = 0.40
    var green:CGFloat = 0.78
    var blue:CGFloat = 0.98
    
    
    var score:Int = 0 {
        didSet {
            scoreLabel.zPosition = 3
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var messageLabel:SKLabelNode!
    
    var gameTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3", "alien4"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var livesArray:[SKSpriteNode]!
    
    var timeInterval = 0.75
    
    var initialScore = 100

    
    override func didMove(to view: SKView) {
       // self.run(SKAction.playSoundFileNamed("music.mp3", waitForCompletion: false))
      //  backgroundMusic = SKAudioNode(fileNamed: "music.mp3")
       // addChild(backgroundMusic)

        //ADD THIS LINE
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.clock), userInfo: nil, repeats:true)
        
        addLives()
        
        starfield = SKEmitterNode(fileNamed: "big_clouds")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        smallClouds = SKEmitterNode(fileNamed: "small_clouds")
        smallClouds.position = CGPoint(x: 0, y: 1472)
        smallClouds.advanceSimulationTime(10)
        self.addChild(smallClouds)
        smallClouds.zPosition = -1
        
        
        mediumClouds = SKEmitterNode(fileNamed: "medium_clouds")
        mediumClouds.position = CGPoint(x: 0, y: 1472)
        mediumClouds.advanceSimulationTime(10)
        self.addChild(mediumClouds)
        mediumClouds.zPosition = -1
        
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        

        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 70)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor.black
        score = 0
        
        self.addChild(scoreLabel)
        
      /*
        timerLabel = SKLabelNode(text: "Seconds: 0")
        timerLabel.position = CGPoint(x: 80, y: self.frame.size.height - 150)
        timerLabel.fontName = "AmericanTypewriter-Bold"
        timerLabel.fontSize = 28
        timerLabel.fontColor = UIColor.black
 
        self.addChild(timerLabel)
        */
        
        messageLabel = SKLabelNode(text: "Next Level")
        messageLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.width/2)
        messageLabel.fontName = "AmericanTypewriter-Bold"
        messageLabel.fontSize = 28
        messageLabel.fontColor = UIColor.black
        messageLabel.isHidden = true
        
        self.addChild(messageLabel)
        
    /*
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            messageLabel.dismiss
            messageLabel.dismiss(animated: true, completion: nil)
        }
 */

        self.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        //gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(changeBackground), userInfo: nil, repeats: true)
        
        print("tiempo\(timeInterval)")
        print(gameTimer)
        
        
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        

        
        
    }
    

    
//     @objc func changeBackground() {
//
//        for _ in 1...10{
//            self.backgroundColor=UIColor(red: red - 0.01, green: green - 0.01, blue: blue - 0.02, alpha: 1.0)
//            print(backgroundColor)
//        }
//    }
    
    
    
    //ADD THIS METHOD
    @objc func clock() {
        seconds=seconds+1
        print(seconds)
        
        
        
        
        
//
//            for _ in 1...20 {
//                print("Antes", backgroundColor)
//           red = red - 0.01
//           green = green - 0.01
//           blue = blue - 0.02
//
//           self.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//                print("Despues", backgroundColor)
//            }
        
        
        
        /*
        let red:CGFloat = 0.40
        let green:CGFloat = 0.78
        let blue:CGFloat = 0.98
       var bacgroundColor=UIColor(red: red, green: green, blue: blue, alpha: 1.0)

        
        self.backgroundColor=bacgroundColor
        
        for _ in 1...20 {
           bacgroundColor=UIColor(red: red - 0.01, green: green - 0.01, blue: blue - 0.02, alpha: 1.0)
            print(bacgroundColor)
            
        }
          */
        
        
        
        
        switch seconds {
        case 1:
            self.backgroundColor=UIColor(red:0.40, green:0.78, blue:0.92, alpha:1.0)
        case 2:
            self.backgroundColor=UIColor(red:0.39, green:0.77, blue:0.92, alpha:1.0)
        case 3:
            self.backgroundColor=UIColor(red:0.38, green:0.76, blue:0.92, alpha:1.0)
        case 4:
            self.backgroundColor=UIColor(red:0.37, green:0.75, blue:0.92, alpha:1.0)
        case 5:
            self.backgroundColor=UIColor(red:0.36, green:0.74, blue:0.92, alpha:1.0)
        case 6:
            self.backgroundColor=UIColor(red:0.35, green:0.73, blue:0.92, alpha:1.0)
        case 7:
            self.backgroundColor=UIColor(red:0.34, green:0.72, blue:0.92, alpha:1.0)
        case 8:
            self.backgroundColor=UIColor(red:0.33, green:0.71, blue:0.92, alpha:1.0)
        case 9:
            self.backgroundColor=UIColor(red:0.32, green:0.70, blue:0.92, alpha:1.0)
        case 10:
            self.backgroundColor=UIColor(red:0.31, green:0.69, blue:0.92, alpha:1.0)
            
            
        case 11:
            self.backgroundColor=UIColor(red:0.30, green:0.68, blue:0.92, alpha:1.0)
        case 12:
            self.backgroundColor=UIColor(red:0.29, green:0.67, blue:0.92, alpha:1.0)
        case 13:
            self.backgroundColor=UIColor(red:0.28, green:0.66, blue:0.92, alpha:1.0)
        case 14:
            self.backgroundColor=UIColor(red:0.27, green:0.65, blue:0.92, alpha:1.0)
        case 15:
            self.backgroundColor=UIColor(red:0.26, green:0.64, blue:0.92, alpha:1.0)
        case 16:
            self.backgroundColor=UIColor(red:0.25, green:0.63, blue:0.92, alpha:1.0)
        case 17:
            self.backgroundColor=UIColor(red:0.24, green:0.62, blue:0.92, alpha:1.0)
        case 18:
            self.backgroundColor=UIColor(red:0.23, green:0.61, blue:0.92, alpha:1.0)
        case 19:
            self.backgroundColor=UIColor(red:0.22, green:0.60, blue:0.92, alpha:1.0)
        case 20:
            self.backgroundColor=UIColor(red:0.21, green:0.59, blue:0.92, alpha:1.0)
            
            
        case 21:
            self.backgroundColor=UIColor(red:0.20, green:0.58, blue:0.92, alpha:1.0)
        case 22:
            self.backgroundColor=UIColor(red:0.19, green:0.57, blue:0.92, alpha:1.0)
        case 23:
            self.backgroundColor=UIColor(red:0.18, green:0.56, blue:0.92, alpha:1.0)
        case 24:
            self.backgroundColor=UIColor(red:0.17, green:0.55, blue:0.92, alpha:1.0)
        case 25:
            self.backgroundColor=UIColor(red:0.16, green:0.54, blue:0.92, alpha:1.0)
        case 26:
            self.backgroundColor=UIColor(red:0.15, green:0.53, blue:0.92, alpha:1.0)
        case 27:
            self.backgroundColor=UIColor(red:0.14, green:0.52, blue:0.92, alpha:1.0)
        case 28:
            self.backgroundColor=UIColor(red:0.13, green:0.51, blue:0.92, alpha:1.0)
        case 29:
            self.backgroundColor=UIColor(red:0.12, green:0.50, blue:0.92, alpha:1.0)
        case 30:
            self.backgroundColor=UIColor(red:0.11, green:0.49, blue:0.92, alpha:1.0)
            
            
            
        default:
           print(seconds)
        }

        
       //timerLabel.text=String(seconds)
        
        
        
        
        
        /*
        if (seconds==5){
             self.backgroundColor=UIColor(red:0.46, green:0.84, blue:0.89, alpha:1.0)
               //  starfield.particleSpeed = 500
              // print(starfield.particleScale)
        }
 
 */
    }
    
    
    

    
    
    func random(min: Double, max: Double) -> Double {
        return Double(arc4random_uniform(UInt32(max - min + 1))) + min
   
    }
    
    func addLives() {
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "Life Icon")
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: self.frame.size.height - 60 )
            liveNode.zPosition = 3
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    
    @objc func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
       // starfield.particleScale = CGFloat(random(min: 1, max: 3))
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 10, highestValue: 380)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        
        actionArray.append(SKAction.run {
            self.run(SKAction.playSoundFileNamed("sfx_lose.wav", waitForCompletion: false))
            if self.livesArray.count > 0 {
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
                var vul=true
                
                if vul{
                    print("Es Inmune")
                    self.player.run(self.blinkAnimation())
                }
       
                if self.livesArray.count == 0{
                   // self.backgroundMusic.run(SKAction.stop())
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                    gameOver.score = self.score
                    self.timer.invalidate()
                    self.view?.presentScene(gameOver, transition: transition)
                }
            }
        })
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
        
    }
    
    func blinkAnimation() -> SKAction{
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("sfx_blaster.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
        
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        explosion.zPosition = 2
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("sfx_explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 5
        
        
        if score == initialScore{
            timeInterval = timeInterval - 0.01
            
            gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
            
            initialScore = initialScore * 2
            
            messageLabel.isHidden = false
        }else{
            messageLabel.isHidden = true
        }
        
        
    }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
    }
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

