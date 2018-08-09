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
    var vul = true
    var score:Int = 0 {
        didSet {
            scoreLabel.zPosition = 3
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var messageLabel:SKLabelNode!
    
    var gameTimer:Timer!
    var colorTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3", "alien4"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var livesArray:[SKSpriteNode]!
    
    var timeInterval = 0.75
    
    var initialScore = 100

    var red:CGFloat = 0.40
    var green:CGFloat = 0.78
    var blue:CGFloat = 0.92
    
    override func didMove(to view: SKView) {
        
        let gradientBG = CAGradientLayer()
        gradientBG.frame = (self.view?.bounds)!
        gradientBG.colors = [SKColor.black, SKColor.cyan]
        gradientBG.locations = [0.0, 0.5]
        gradientBG.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientBG.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientBG.zPosition = 1
        
        self.scene?.view?.layer.addSublayer(gradientBG)
        
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
        player.zPosition = 1
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

        self.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha:1.0)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clock), userInfo: nil, repeats: true)
      
  

    
        
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
    

//    let gradient CAGradientLayer = {
//        let g = CAGradientLayer()
//        g.colors = [UIColor(red:1, green:0.71, blue:0, alpha:1).cgColor, red:0.95, green:0.69, blue:0.69, alpha:1).cgColor]
//        return g
//    }()
//
//    gradient.frame = inputsContainer.bounds
//
//    inputsContainer.layer.insertSublayer(gradient, at: 0)
    
     @objc func changeBackground() {
        
        red = red - 0.01
        green = green - 0.01

        self.backgroundColor=UIColor(red: red - 0.01, green: green - 0.01, blue: blue, alpha: 1.0)
        print(backgroundColor)
        
        if (red <= 0.05 || green == 0.43 ) {
            
            colorTimer.invalidate()
            print("Color Rojo impreso", red)
        }
    }
    
    
    
    
    
    
    //ADD THIS METHOD
    @objc func clock() {
        seconds=seconds+1
        //print(seconds)
      
        
//        for _ in seconds...seconds+2{
//            red = red - 0.01
//            green = green - 0.01
//            blue = blue - 0.02
//             self.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha:1.0)
//            print(backgroundColor)
//        }
//
        
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
            //De 8EB1FE a 8699C8
         case 1:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0) //
        case 2:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 3:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 4:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 5:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 6:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 7:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 8:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 9:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0) //
        case 10:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0)
        case 11:
            self.backgroundColor=UIColor(red:0.56, green:0.68, blue:0.99, alpha:1.0)
        case 12:
            self.backgroundColor=UIColor(red:0.56, green:0.68, blue:0.98, alpha:1.0)
        case 13:
            self.backgroundColor=UIColor(red:0.55, green:0.68, blue:0.97, alpha:1.0)
        case 14:
            self.backgroundColor=UIColor(red:0.55, green:0.67, blue:0.96, alpha:1.0)
        case 15:
            self.backgroundColor=UIColor(red:0.55, green:0.67, blue:0.95, alpha:1.0)
        case 16:
            self.backgroundColor=UIColor(red:0.55, green:0.66, blue:0.94, alpha:1.0)
        case 17:
            self.backgroundColor=UIColor(red:0.55, green:0.66, blue:0.93, alpha:1.0)
        case 18:
            self.backgroundColor=UIColor(red:0.55, green:0.65, blue:0.92, alpha:1.0)
        case 19:
            self.backgroundColor=UIColor(red:0.55, green:0.65, blue:0.91, alpha:1.0)
        case 20:
            self.backgroundColor=UIColor(red:0.55, green:0.65, blue:0.91, alpha:1.0)
            
            
        case 21:
            self.backgroundColor=UIColor(red:0.55, green:0.65, blue:0.90, alpha:1.0)
        case 22:
            self.backgroundColor=UIColor(red:0.54, green:0.64, blue:0.89, alpha:1.0)
        case 23:
            self.backgroundColor=UIColor(red:0.54, green:0.64, blue:0.88, alpha:1.0)
        case 24:
            self.backgroundColor=UIColor(red:0.54, green:0.64, blue:0.87, alpha:1.0)
        case 25:
            self.backgroundColor=UIColor(red:0.54, green:0.63, blue:0.86, alpha:1.0)
        case 26:
            self.backgroundColor=UIColor(red:0.54, green:0.63, blue:0.85, alpha:1.0)
        case 27:
            self.backgroundColor=UIColor(red:0.54, green:0.62, blue:0.84, alpha:1.0)
        case 28:
            self.backgroundColor=UIColor(red:0.54, green:0.62, blue:0.83, alpha:1.0)
        case 29:
            self.backgroundColor=UIColor(red:0.53, green:0.62, blue:0.82, alpha:1.0)
        case 30:
            self.backgroundColor=UIColor(red:0.53, green:0.61, blue:0.81, alpha:1.0)
            
            
        case 31:
            self.backgroundColor=UIColor(red:0.53, green:0.61, blue:0.80, alpha:1.0)
        case 32:
            self.backgroundColor=UIColor(red:0.53, green:0.60, blue:0.79, alpha:1.0)
        case 33:
            self.backgroundColor=UIColor(red:0.53, green:0.60, blue:0.78, alpha:1.0) // termina 8EB1FE-8699C8
        case 34:
            self.backgroundColor=UIColor(red:0.52, green:0.59, blue:0.77, alpha:1.0) // De 8699C8 a 637294
        case 35:
            self.backgroundColor=UIColor(red:0.51, green:0.59, blue:0.76, alpha:1.0)
        case 36:
            self.backgroundColor=UIColor(red:0.51, green:0.58, blue:0.75, alpha:1.0)
        case 37:
            self.backgroundColor=UIColor(red:0.50, green:0.57, blue:0.74, alpha:1.0)
        case 38:
            self.backgroundColor=UIColor(red:0.49, green:0.56, blue:0.73, alpha:1.0)
        case 39:
            self.backgroundColor=UIColor(red:0.49, green:0.55, blue:0.72, alpha:1.0)
        case 40:
            self.backgroundColor=UIColor(red:0.48, green:0.54, blue:0.71, alpha:1.0)
            
        case 41:
            self.backgroundColor=UIColor(red:0.47, green:0.54, blue:0.70, alpha:1.0)
        case 42:
            self.backgroundColor=UIColor(red:0.47, green:0.53, blue:0.69, alpha:1.0)
        case 43:
            self.backgroundColor=UIColor(red:0.46, green:0.52, blue:0.68, alpha:1.0)
        case 44:
            self.backgroundColor=UIColor(red:0.45, green:0.52, blue:0.67, alpha:1.0)
        case 45:
            self.backgroundColor=UIColor(red:0.44, green:0.51, blue:0.66, alpha:1.0)
        case 46:
            self.backgroundColor=UIColor(red:0.43, green:0.50, blue:0.65, alpha:1.0)
        case 47:
            self.backgroundColor=UIColor(red:0.43, green:0.49, blue:0.64, alpha:1.0)
        case 48:
            self.backgroundColor=UIColor(red:0.42, green:0.49, blue:0.63, alpha:1.0)
        case 49:
            self.backgroundColor=UIColor(red:0.41, green:0.48, blue:0.62, alpha:1.0)
        case 50:
            self.backgroundColor=UIColor(red:0.41, green:0.47, blue:0.61, alpha:1.0)
            
        case 51:
            self.backgroundColor=UIColor(red:0.40, green:0.46, blue:0.60, alpha:1.0)
        case 52:
            self.backgroundColor=UIColor(red:0.40, green:0.46, blue:0.59, alpha:1.0)
        case 53:
            self.backgroundColor=UIColor(red:0.39, green:0.45, blue:0.58, alpha:1.0) // termina 8699C8-637294
        case 54:
            self.backgroundColor=UIColor(red:0.38, green:0.44, blue:0.57, alpha:1.0) // De 637294 a 3C4F6F
        case 55:
            self.backgroundColor=UIColor(red:0.37, green:0.43, blue:0.56, alpha:1.0)
        case 56:
            self.backgroundColor=UIColor(red:0.36, green:0.42, blue:0.55, alpha:1.0)
        case 57:
            self.backgroundColor=UIColor(red:0.35, green:0.41, blue:0.54, alpha:1.0)
        case 58:
            self.backgroundColor=UIColor(red:0.34, green:0.40, blue:0.53, alpha:1.0)
        case 59:
            self.backgroundColor=UIColor(red:0.33, green:0.39, blue:0.52, alpha:1.0)
        case 60:
            self.backgroundColor=UIColor(red:0.32, green:0.38, blue:0.51, alpha:1.0)
            
        case 61:
            self.backgroundColor=UIColor(red:0.31, green:0.37, blue:0.50, alpha:1.0)
        case 62:
            self.backgroundColor=UIColor(red:0.30, green:0.36, blue:0.49, alpha:1.0)
        case 63:
            self.backgroundColor=UIColor(red:0.29, green:0.36, blue:0.49, alpha:1.0)
        case 64:
            self.backgroundColor=UIColor(red:0.28, green:0.35, blue:0.48, alpha:1.0)
        case 65:
            self.backgroundColor=UIColor(red:0.27, green:0.34, blue:0.47, alpha:1.0)
        case 66:
            self.backgroundColor=UIColor(red:0.26, green:0.33, blue:0.46, alpha:1.0)
        case 67:
            self.backgroundColor=UIColor(red:0.25, green:0.32, blue:0.45, alpha:1.0)
        case 68:
            self.backgroundColor=UIColor(red:0.24, green:0.31, blue:0.44, alpha:1.0) // termina 637294-3C4F6F
        case 69:
            self.backgroundColor=UIColor(red:0.24, green:0.30, blue:0.43, alpha:1.0) // De 3C4F6F a 161A25
        case 70:
            self.backgroundColor=UIColor(red:0.23, green:0.30, blue:0.42, alpha:1.0)
        case 71:
            self.backgroundColor=UIColor(red:0.23, green:0.29, blue:0.41, alpha:1.0)
        case 72:
            self.backgroundColor=UIColor(red:0.22, green:0.28, blue:0.40, alpha:1.0)
        case 73:
            self.backgroundColor=UIColor(red:0.22, green:0.27, blue:0.39, alpha:1.0)
        case 74:
            self.backgroundColor=UIColor(red:0.21, green:0.26, blue:0.38, alpha:1.0)
        case 75:
            self.backgroundColor=UIColor(red:0.21, green:0.25, blue:0.37, alpha:1.0)
        case 76:
            self.backgroundColor=UIColor(red:0.20, green:0.24, blue:0.36, alpha:1.0)
        case 77:
            self.backgroundColor=UIColor(red:0.20, green:0.23, blue:0.35, alpha:1.0)
        case 78:
            self.backgroundColor=UIColor(red:0.19, green:0.22, blue:0.34, alpha:1.0)
        case 79:
            self.backgroundColor=UIColor(red:0.19, green:0.21, blue:0.33, alpha:1.0)
        case 80:
            self.backgroundColor=UIColor(red:0.18, green:0.20, blue:0.32, alpha:1.0)
            
            
        case 81:
            self.backgroundColor=UIColor(red:0.18, green:0.19, blue:0.31, alpha:1.0)
        case 82:
            self.backgroundColor=UIColor(red:0.17, green:0.18, blue:0.30, alpha:1.0)
        case 83:
            self.backgroundColor=UIColor(red:0.17, green:0.17, blue:0.29, alpha:1.0)
        case 84:
            self.backgroundColor=UIColor(red:0.16, green:0.16, blue:0.28, alpha:1.0)
        case 85:
            self.backgroundColor=UIColor(red:0.16, green:0.15, blue:0.27, alpha:1.0)
        case 86:
            self.backgroundColor=UIColor(red:0.15, green:0.14, blue:0.26, alpha:1.0)
        case 87:
            self.backgroundColor=UIColor(red:0.15, green:0.13, blue:0.25, alpha:1.0)
        case 88:
            self.backgroundColor=UIColor(red:0.14, green:0.12, blue:0.24, alpha:1.0)
        case 89:
            self.backgroundColor=UIColor(red:0.14, green:0.11, blue:0.25, alpha:1.0)
        case 90:
            self.backgroundColor=UIColor(red:0.13, green:0.10, blue:0.24, alpha:1.0)
            
        case 91:
            self.backgroundColor=UIColor(red:0.13, green:0.09, blue:0.23, alpha:1.0)
        case 92:
            self.backgroundColor=UIColor(red:0.12, green:0.08, blue:0.22, alpha:1.0)
        case 93:
            self.backgroundColor=UIColor(red:0.12, green:0.07, blue:0.21, alpha:1.0)
        case 94:
            self.backgroundColor=UIColor(red:0.11, green:0.06, blue:0.20, alpha:1.0)
        case 95:
            self.backgroundColor=UIColor(red:0.11, green:0.05, blue:0.19, alpha:1.0)
        case 96:
            self.backgroundColor=UIColor(red:0.10, green:0.04, blue:0.18, alpha:1.0)
        case 97:
            self.backgroundColor=UIColor(red:0.10, green:0.03, blue:0.17, alpha:1.0)
        case 98:
            self.backgroundColor=UIColor(red:0.09, green:0.02, blue:0.16, alpha:1.0)
        case 99:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 100:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
            
        
        case 101:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0) // Termina 3C4F6F-161A25
        case 102:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0) // De 161A25 a 0B0C13
        case 103:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 104:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 105:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 106:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 107:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 108:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 109:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0)
        case 110:
            self.backgroundColor=UIColor(red:0.09, green:0.01, blue:0.15, alpha:1.0) //0
        case 111:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 112:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 113:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 114:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 115:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 116:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 117:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 118:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0)
        case 119:
            self.backgroundColor=UIColor(red:0.08, green:0.01, blue:0.14, alpha:1.0) //1
        case 120:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 121:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 122:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 123:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 124:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 125:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 126:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 127:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0)
        case 128:
            self.backgroundColor=UIColor(red:0.08, green:0.02, blue:0.13, alpha:1.0) //2
        case 129:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 130:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 131:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 132:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 133:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 134:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 135:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0)
        case 136:
            self.backgroundColor=UIColor(red:0.07, green:0.03, blue:0.12, alpha:1.0) //3
        case 137:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 138:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 139:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 140:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 141:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 142:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 143:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 144:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)
        case 145:
            self.backgroundColor=UIColor(red:0.06, green:0.04, blue:0.11, alpha:1.0)//4
        case 146:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 147:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 148:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 149:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 150:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 151:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 152:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 153:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0)
        case 154:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.10, alpha:1.0) //5
        
        
            
        case 155:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 156:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 157:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 158:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 159:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 160:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 161:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 162:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0)
        case 163:
            self.backgroundColor=UIColor(red:0.05, green:0.06, blue:0.09, alpha:1.0) //6
        case 164:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 165:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 166:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 167:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 168:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 169:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 170:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 171:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0)
        case 172:
            self.backgroundColor=UIColor(red:0.04, green:0.06, blue:0.08, alpha:1.0) //7
    
        case 173:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 174:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 175:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 176:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 177:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 178:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 179:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 180:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0)
        case 181:
            self.backgroundColor=UIColor(red:0.04, green:0.05, blue:0.07, alpha:1.0) // Termina 161A25-0B0C13
            
        case 182:
            self.backgroundColor=UIColor(red:0.05, green:0.05, blue:0.07, alpha:1.0) // De 0B0C13 a A33F35
        
        case 183:
            self.backgroundColor=UIColor(red:0.07, green:0.05, blue:0.07, alpha:1.0)
        
        case 184:
            self.backgroundColor=UIColor(red:0.09, green:0.06, blue:0.08, alpha:1.0)
       
        case 185:
            self.backgroundColor=UIColor(red:0.11, green:0.07, blue:0.08, alpha:1.0)
            
        
        case 186:
            self.backgroundColor=UIColor(red:0.13, green:0.07, blue:0.09, alpha:1.0)
        
        case 187:
            self.backgroundColor=UIColor(red:0.15, green:0.08, blue:0.09, alpha:1.0)
        
        case 188:
            self.backgroundColor=UIColor(red:0.17, green:0.09, blue:0.09, alpha:1.0)
        
        case 189:
            self.backgroundColor=UIColor(red:0.19, green:0.09, blue:0.10, alpha:1.0)
       
        case 190:
            self.backgroundColor=UIColor(red:0.21, green:0.10, blue:0.10, alpha:1.0)
            
        
        case 191:
            self.backgroundColor=UIColor(red:0.23, green:0.11, blue:0.11, alpha:1.0)
        case 192:
            self.backgroundColor=UIColor(red:0.25, green:0.11, blue:0.11, alpha:1.0)
        
        case 193:
            self.backgroundColor=UIColor(red:0.27, green:0.12, blue:0.12, alpha:1.0)
        
        case 194:
            self.backgroundColor=UIColor(red:0.29, green:0.13, blue:0.12, alpha:1.0)
        
        case 195:
            self.backgroundColor=UIColor(red:0.31, green:0.13, blue:0.13, alpha:1.0)
        
        
        case 196:
            self.backgroundColor=UIColor(red:0.33, green:0.14, blue:0.13, alpha:1.0)
        case 197:
            self.backgroundColor=UIColor(red:0.35, green:0.15, blue:0.14, alpha:1.0)
        case 198:
            self.backgroundColor=UIColor(red:0.37, green:0.15, blue:0.14, alpha:1.0)
        case 199:
            self.backgroundColor=UIColor(red:0.39, green:0.16, blue:0.15, alpha:1.0)
        
        case 200:
            self.backgroundColor=UIColor(red:0.41, green:0.17, blue:0.15, alpha:1.0)
            
            
        
        case 201:
            self.backgroundColor=UIColor(red:0.43, green:0.17, blue:0.15, alpha:1.0)
        
        case 202:
            self.backgroundColor=UIColor(red:0.45, green:0.18, blue:0.16, alpha:1.0)
        
        case 203:
            self.backgroundColor=UIColor(red:0.47, green:0.19, blue:0.16, alpha:1.0)
        
        case 204:
            self.backgroundColor=UIColor(red:0.49, green:0.19, blue:0.17, alpha:1.0)
        
        case 205:
            self.backgroundColor=UIColor(red:0.51, green:0.20, blue:0.17, alpha:1.0)
        
       
        case 206:
            self.backgroundColor=UIColor(red:0.53, green:0.21, blue:0.18, alpha:1.0)
        
        case 207:
            self.backgroundColor=UIColor(red:0.55, green:0.21, blue:0.18, alpha:1.0)
        
        case 208:
            self.backgroundColor=UIColor(red:0.57, green:0.22, blue:0.19, alpha:1.0)
        
        case 209:
            self.backgroundColor=UIColor(red:0.59, green:0.23, blue:0.19, alpha:1.0)
        
        case 210:
            self.backgroundColor=UIColor(red:0.61, green:0.23, blue:0.20, alpha:1.0)
        
        
        case 211:
            self.backgroundColor=UIColor(red:0.63, green:0.24, blue:0.20, alpha:1.0)// Termina 0B0C13-A33F35
        case 212:
            self.backgroundColor=UIColor(red:0.65, green:0.25, blue:0.21, alpha:1.0) // De A33F35 a E37042
        
        case 213:
            self.backgroundColor=UIColor(red:0.67, green:0.27, blue:0.21, alpha:1.0)
       
        case 214:
            self.backgroundColor=UIColor(red:0.69, green:0.29, blue:0.21, alpha:1.0)
        
        case 215:
            self.backgroundColor=UIColor(red:0.71, green:0.30, blue:0.22, alpha:1.0)
            
        
        case 216:
            self.backgroundColor=UIColor(red:0.73, green:0.32, blue:0.22, alpha:1.0)
        
        case 217:
            self.backgroundColor=UIColor(red:0.75, green:0.33, blue:0.23, alpha:1.0)
        
        case 218:
            self.backgroundColor=UIColor(red:0.77, green:0.35, blue:0.23, alpha:1.0)
        
        case 219:
            self.backgroundColor=UIColor(red:0.79, green:0.37, blue:0.23, alpha:1.0)
        
        case 220:
            self.backgroundColor=UIColor(red:0.81, green:0.38, blue:0.24, alpha:1.0)
            
            
        
        case 221:
            self.backgroundColor=UIColor(red:0.83, green:0.40, blue:0.24, alpha:1.0)
        
        case 222:
            self.backgroundColor=UIColor(red:0.85, green:0.41, blue:0.25, alpha:1.0)
        
        case 223:
            self.backgroundColor=UIColor(red:0.87, green:0.43, blue:0.25, alpha:1.0)
        
        case 224:
            self.backgroundColor=UIColor(red:0.89, green:0.44, blue:0.26, alpha:1.0) // Termina A33F35 - E37042
        case 225:
            self.backgroundColor=UIColor(red:0.87, green:0.45, blue:0.27, alpha:1.0) // De E37042 a C98659
        
        
            
        case 226:
            self.backgroundColor=UIColor(red:0.85, green:0.47, blue:0.29, alpha:1.0)
        
        case 227:
            self.backgroundColor=UIColor(red:0.83, green:0.49, blue:0.31, alpha:1.0)
        
        case 228:
            self.backgroundColor=UIColor(red:0.81, green:0.51, blue:0.33, alpha:1.0)
        
        case 229:
            self.backgroundColor=UIColor(red:0.79, green:0.53, blue:0.35, alpha:1.0)// De C98659-C4B6AA
        case 230:
            self.backgroundColor=UIColor(red:0.78, green:0.54, blue:0.37, alpha:1.0)
        
            
        case 231:
            self.backgroundColor=UIColor(red:0.78, green:0.55, blue:0.39, alpha:1.0)
        
        case 232:
            self.backgroundColor=UIColor(red:0.78, green:0.56, blue:0.41, alpha:1.0)
        
        case 233:
            self.backgroundColor=UIColor(red:0.78, green:0.57, blue:0.43, alpha:1.0)
        
        case 334:
            self.backgroundColor=UIColor(red:0.78, green:0.58, blue:0.45, alpha:1.0)
        
        case 235:
            self.backgroundColor=UIColor(red:0.78, green:0.59, blue:0.47, alpha:1.0)
        
            
        case 236:
            self.backgroundColor=UIColor(red:0.78, green:0.60, blue:0.49, alpha:1.0)
        
        case 237:
            self.backgroundColor=UIColor(red:0.78, green:0.62, blue:0.51, alpha:1.0)
        
        case 238:
            self.backgroundColor=UIColor(red:0.77, green:0.63, blue:0.53, alpha:1.0)
        
        case 239:
            self.backgroundColor=UIColor(red:0.77, green:0.64, blue:0.55, alpha:1.0)
        
        case 240:
            self.backgroundColor=UIColor(red:0.77, green:0.65, blue:0.57, alpha:1.0)
        
    
        case 241:
            self.backgroundColor=UIColor(red:0.77, green:0.66, blue:0.59, alpha:1.0)
        
        case 242:
            self.backgroundColor=UIColor(red:0.77, green:0.67, blue:0.61, alpha:1.0)
        
        case 243:
            self.backgroundColor=UIColor(red:0.77, green:0.68, blue:0.63, alpha:1.0)
        
        case 244:
            self.backgroundColor=UIColor(red:0.77, green:0.69, blue:0.65, alpha:1.0)
       
        case 245:
            self.backgroundColor=UIColor(red:0.77, green:0.71, blue:0.67, alpha:1.0) //Termina C98659-C4B6AA
        case 246:
            self.backgroundColor=UIColor(red:0.76, green:0.71, blue:0.68, alpha:1.0) // De C4B6AA a BBC2CE
        
        case 247:
            self.backgroundColor=UIColor(red:0.76, green:0.71, blue:0.69, alpha:1.0)
        
       case 248:
            self.backgroundColor=UIColor(red:0.75, green:0.72, blue:0.71, alpha:1.0)
        
        case 249:
            self.backgroundColor=UIColor(red:0.75, green:0.73, blue:0.73, alpha:1.0)
        
        case 250:
            self.backgroundColor=UIColor(red:0.74, green:0.73, blue:0.75, alpha:1.0)
        
        case 251:
            self.backgroundColor=UIColor(red:0.74, green:0.74, blue:0.77, alpha:1.0)
        
            
            
        case 252:
            self.backgroundColor=UIColor(red:0.73, green:0.75, blue:0.79, alpha:1.0)
        
        case 253:
            self.backgroundColor=UIColor(red:0.73, green:0.76, blue:0.81, alpha:1.0) // Termina C4B6AA-BBC2CE
        case 254:
            self.backgroundColor=UIColor(red:0.72, green:0.76, blue:0.82, alpha:1.0)// De BBC2CE a B5C6E8
        case 255:
            self.backgroundColor=UIColor(red:0.72, green:0.76, blue:0.83, alpha:1.0)
        case 256:
            self.backgroundColor=UIColor(red:0.72, green:0.76, blue:0.84, alpha:1.0)
        case 257:
            self.backgroundColor=UIColor(red:0.72, green:0.76, blue:0.85, alpha:1.0)
        case 258:
            self.backgroundColor=UIColor(red:0.71, green:0.76, blue:0.86, alpha:1.0)
        case 259:
            self.backgroundColor=UIColor(red:0.71, green:0.77, blue:0.87, alpha:1.0)
        case 260:
            self.backgroundColor=UIColor(red:0.71, green:0.77, blue:0.88, alpha:1.0)
            
        case 261:
            self.backgroundColor=UIColor(red:0.71, green:0.77, blue:0.89, alpha:1.0)
        case 262:
            self.backgroundColor=UIColor(red:0.71, green:0.77, blue:0.90, alpha:1.0)
        case 263:
            self.backgroundColor=UIColor(red:0.71, green:0.78, blue:0.91, alpha:1.0) // Termina BBC2CE-B5C6E8
        case 264:
            self.backgroundColor=UIColor(red:0.70, green:0.77, blue:0.91, alpha:1.0)// De B5C6E8 a 8EB1FE
        case 265:
            self.backgroundColor=UIColor(red:0.69, green:0.76, blue:0.92, alpha:1.0)
        case 266:
            self.backgroundColor=UIColor(red:0.68, green:0.76, blue:0.92, alpha:1.0)
        case 267:
            self.backgroundColor=UIColor(red:0.67, green:0.75, blue:0.93, alpha:1.0)
        case 268:
            self.backgroundColor=UIColor(red:0.66, green:0.75, blue:0.94, alpha:1.0)
        case 269:
            self.backgroundColor=UIColor(red:0.65, green:0.74, blue:0.94, alpha:1.0)
        case 270:
            self.backgroundColor=UIColor(red:0.64, green:0.73, blue:0.95, alpha:1.0)
            
        case 271:
            self.backgroundColor=UIColor(red:0.63, green:0.73, blue:0.95, alpha:1.0)
        case 272:
            self.backgroundColor=UIColor(red:0.62, green:0.72, blue:0.96, alpha:1.0)
        case 273:
            self.backgroundColor=UIColor(red:0.61, green:0.72, blue:0.97, alpha:1.0)
        case 274:
            self.backgroundColor=UIColor(red:0.60, green:0.71, blue:0.97, alpha:1.0)
        case 275:
            self.backgroundColor=UIColor(red:0.59, green:0.70, blue:0.98, alpha:1.0)
        case 276:
            self.backgroundColor=UIColor(red:0.58, green:0.70, blue:0.98, alpha:1.0)
        case 277:
            self.backgroundColor=UIColor(red:0.57, green:0.69, blue:0.99, alpha:1.0)
        case 278:
            self.backgroundColor=UIColor(red:0.56, green:0.69, blue:1.00, alpha:1.0) //Termina B5C6E8-8EB1FE
        
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
        alien.zPosition = 2
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
          
            
            if self.livesArray.count > 0 {
                if (!self.player.hasActions()){
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                //self.livesArray.removeFirst()
                      self.run(SKAction.playSoundFileNamed("sfx_lose.wav", waitForCompletion: false))
                    
                    if self.livesArray.count == 0 {
                        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                        let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                        gameOver.score = self.score
                         self.view?.presentScene(gameOver, transition: transition)
                    }
                    
                    
                    self.player.run(self.blinkAnimation(),completion: {
                        if self.livesArray.count == 0{
                            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                            let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                            gameOver.score = self.score
                            self.timer.invalidate()
                            self.view?.presentScene(gameOver, transition: transition)
                            
                        }
                })
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
        vul=false
        return SKAction.repeat(blink, count: 4)
        
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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

