//
//  MenuScene.swift
//  SpacegameReloaded
//
//  Created by Herbeyg Robledo Reyes on 7/23/18.
//  Copyright © 2018 Training. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var newGameButtonNode:SKSpriteNode!
    var menuScreenNode:SKSpriteNode!
    var kmScore:SKSpriteNode!
    var lifeBar:SKSpriteNode!
    var gasIcon:SKSpriteNode!
    var menuBackgroundNode:SKSpriteNode!
    var logoNode:SKSpriteNode!
    
    var seconds:Int = 0
    var scoreLabel:SKLabelNode!
    

    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(text: "0 0 0 0 0 0")
        scoreLabel = SKLabelNode(fontNamed: "November")
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: self.frame.size.width*2.2/10, y: self.size.height*0.08/10)
        scoreLabel.fontSize = 12.5
        scoreLabel.fontColor = UIColor.black

        var secondsText = String(format:"%06d", seconds)
//        print("Formato", seconds)
        secondsText.insert(separator: "   ", every: 1)
        scoreLabel.text=String(secondsText)
        self.addChild(scoreLabel)
        
        
       // scoreLabel.text = "\(seconds)"
        
        
        menuBackgroundNode = self.childNode(withName: "MenuBackgroundScreen") as! SKSpriteNode
        menuBackgroundNode.texture = SKTexture(imageNamed: "menuBackground")
        menuBackgroundNode.zPosition = 2
        menuBackgroundNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        menuBackgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        
        
        logoNode = self.childNode(withName: "MenuLogo") as! SKSpriteNode
        logoNode.texture = SKTexture(imageNamed: "logo")
        logoNode.zPosition = 6
//        logoNode.position =
        
        menuScreenNode = self.childNode(withName: "MenuScreen") as! SKSpriteNode
        menuScreenNode.texture = SKTexture(imageNamed: "menu")
        menuScreenNode.zPosition = 3
        
        
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "menuButton")
        newGameButtonNode.zPosition = 4


        kmScore = SKSpriteNode(imageNamed: "kmScore")
        kmScore.zPosition = 4
        kmScore.size = CGSize(width: 152, height: 40)
        kmScore.position = CGPoint(x: self.frame.size.width / 4.5, y: kmScore.size.height / 2)
        self.addChild(kmScore)
        
        
        lifeBar = SKSpriteNode(imageNamed: "life3")
        lifeBar.zPosition = 4
        lifeBar.size = CGSize(width: 40, height: 30)
        lifeBar.position = CGPoint(x: self.frame.size.width / 1.10, y: lifeBar.size.height / 2)
        self.addChild(lifeBar)
        
        gasIcon = SKSpriteNode(imageNamed: "lifeGauge")
        gasIcon.zPosition = 4
        gasIcon.size = CGSize(width: 20, height: 20)
        gasIcon.position = CGPoint(x: self.frame.size.width / 1.04, y: gasIcon.size.height / 2  + 20)
        self.addChild(gasIcon)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touches = touches.first
        
        if let location = touches?.location(in: self){
            let nodesArray = self.nodes(at:location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)

            }
        }
    }
}

