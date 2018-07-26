//
//  InstructionsScene.swift
//  AircraftSiege
//
//  Created by Herbeyg Robledo Reyes on 7/26/18.
//  Copyright © 2018 TeamLynx. All rights reserved.
//

import SpriteKit

class InstructionsScene: SKScene {
    
    var backButtonNode:SKSpriteNode!
    var nextScreenNode:SKSpriteNode!
    var instructionsImageNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        backButtonNode = self.childNode(withName: "backButton") as! SKSpriteNode
        backButtonNode.texture = SKTexture(imageNamed: "Return Button")
        backButtonNode.zPosition = 3
        
        nextScreenNode = self.childNode(withName: "nextButton") as! SKSpriteNode
        nextScreenNode.texture = SKTexture(imageNamed: "Return Button")
        nextScreenNode.zPosition = 3
        
        instructionsImageNode = self.childNode(withName: "instructionsImage") as! SKSpriteNode
        instructionsImageNode.texture = SKTexture(imageNamed: "Instructions1")
        instructionsImageNode.zPosition = 2
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touches = touches.first
        
        if let location = touches?.location(in: self){
            let nodesArray = self.nodes(at:location)
            
            if nodesArray.first?.name == "nextButton" {
                instructionsImageNode.texture = SKTexture(imageNamed: "Instructions2")
            }
            if nodesArray.first?.name == "backButton" {
                if(instructionsImageNode.texture == SKTexture(imageNamed: "Instructions2")){
                    
                    instructionsImageNode.texture = SKTexture(imageNamed: "Instructions1")
                }else{
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    let menuScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                    self.view?.presentScene(menuScene, transition: transition)
                }
                    
            }
        }
    }
}
