//
//  MenuScene.swift
//  SpacegameReloaded
//
//  Created by Herbeyg Robledo Reyes on 7/23/18.
//  Copyright © 2018 Training. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var newGameButtonNode = SKSpriteNode()
    var menuScreenNode:SKSpriteNode!
    var kmScore:SKSpriteNode!
    var lifeBar:SKSpriteNode!
    var gasIcon:SKSpriteNode!
    var menuBackgroundNode = SKSpriteNode()
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
        secondsText.insert(separator: "   ", every: 1)
        scoreLabel.text=String(secondsText)
        self.addChild(scoreLabel)

        menuBackgroundNode.texture = SKTexture(imageNamed: "background")
        menuBackgroundNode.zPosition = 2
        menuBackgroundNode.position = CGPoint(x: self.frame.size.width*5/10, y: self.size.height*5/10)
        //menuBackgroundNode.size = CGSize(width:(menuBackgroundNode.size.width)*(self.size.width/menuBackgroundNode.size.width)/(0.3/3),  height: menuBackgroundNode.size.height * (self.size.height/menuBackgroundNode.size.height)/(0.3/3))
        menuBackgroundNode.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        self.addChild(menuBackgroundNode)
        
        logoNode = SKSpriteNode(imageNamed: "Logo")
        logoNode.zPosition = 6
        logoNode.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.80)
        logoNode.size = CGSize(width:(logoNode.size.width)*(frame.size.width/logoNode.size.width),  height: frame.size.height * 0.12)
        self.addChild(logoNode)

        
        newGameButtonNode = SKSpriteNode(imageNamed: "menuButton")
        newGameButtonNode.zPosition = 4
        newGameButtonNode.name = "newGameButton"
        newGameButtonNode.position = CGPoint(x: self.frame.size.width*5/10, y: self.size.height*1/10)
        //newGameButtonNode.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.10)
        newGameButtonNode.size = CGSize(width:(newGameButtonNode.size.width)*(frame.size.width/newGameButtonNode.size.width * 0.2),  height: frame.size.height * 0.12)
        self.addChild(newGameButtonNode)
   
        
        kmScore = SKSpriteNode(imageNamed: "kmScore")
        kmScore.zPosition = 4
        kmScore.size = CGSize(width: 152, height: 40)
        kmScore.position = CGPoint(x: self.frame.size.width / 4.5, y: kmScore.size.height / 2)
        kmScore.size = CGSize(width:(kmScore.size.width)*(frame.size.width/kmScore.size.width * 0.375),  height: frame.size.height * 0.050)
        self.addChild(kmScore)
        
        lifeBar = SKSpriteNode(imageNamed: "life3")
        lifeBar.zPosition = 4
        //lifeBar.size = CGSize(width: 40, height: 30)
        lifeBar.size = CGSize(width:(lifeBar.size.width)*(frame.size.width/lifeBar.size.width * 0.12),  height: frame.size.height * 0.050)
        lifeBar.position = CGPoint(x: self.frame.size.width / 1.10, y: lifeBar.size.height / 1.70)
        self.addChild(lifeBar)
        
        gasIcon = SKSpriteNode(imageNamed: "lifeGauge")
        gasIcon.zPosition = 4
        //gasIcon.size = CGSize(width: 20, height: 20)
        gasIcon.position = CGPoint(x: self.frame.size.width / 1.045, y: gasIcon.size.height / 2)
         gasIcon.size = CGSize(width:(newGameButtonNode.size.width)*(frame.size.width/newGameButtonNode.size.width * 0.050),  height: frame.size.height * 0.030)
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

