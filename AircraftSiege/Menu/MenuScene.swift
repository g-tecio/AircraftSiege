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
    var difficultyButtonNode:SKSpriteNode!
    var difficultyLabelNode:SKLabelNode!
    var instructions:SKSpriteNode!
    var exitButtonNode:SKSpriteNode!
    var menuScreenNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
    
        menuScreenNode = self.childNode(withName: "MenuScreen") as! SKSpriteNode
        menuScreenNode.texture = SKTexture(imageNamed: "Menu Screen")
        menuScreenNode.zPosition = 2
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "Play_Button")
        newGameButtonNode.zPosition = 3

        
        instructions = self.childNode(withName: "instructions") as! SKSpriteNode
        instructions.texture = SKTexture(imageNamed: "Instruction_Button")
        instructions.zPosition = 3
        
        exitButtonNode = self.childNode(withName: "exitButton") as! SKSpriteNode
        exitButtonNode.texture = SKTexture(imageNamed: "Exit_Button")
        exitButtonNode.zPosition = 3

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
            
            if nodesArray.first?.name == "instructions" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let instructionsScene = SKScene(fileNamed: "InstructionsScene") as! InstructionsScene
                self.view?.presentScene(instructionsScene, transition: transition)
                
            }
            
            if nodesArray.first?.name == "exitButton" {
                exit(0)
            }
                
        }
    }
}

