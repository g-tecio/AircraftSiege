//
//  GameOverScene.swift
//  SpacegameReloaded
//
//  Created by Herbeyg Robledo Reyes on 7/23/18.
//  Copyright © 2018 Training. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var score:Int = 0
    
    var scoreLabel:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    var mainMenu:SKSpriteNode!

    override func didMove(to view: SKView) {
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(score)"
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "Replay Button")
        
        mainMenu = self.childNode(withName: "btnMainMenu") as! SKSpriteNode
        mainMenu.texture = SKTexture(imageNamed: "Return Button")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touches = touches.first
        
        if let location = touches?.location(in: self){
            let node = self.nodes(at:location)
            
            if node[0].name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            if node[0].name == "btnMainMenu" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let menuScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                self.view?.presentScene(menuScene, transition: transition)
            }
        }
    }
}
