//
//  MenuControls.swift
//  AircraftSiege
//
//  Created by Herbeyg Robledo Reyes on 7/25/18.
//  Copyright © 2018 TeamLynx. All rights reserved.
//

import SpriteKit

class MenuControls {
    
    let btnStartGame: SKSpriteNode
    //let btnCloseGame: SKSpriteNode
    //let btnInstructions: SKSpriteNode
    
    init(inThisScene: MenuScene) {
    
        btnStartGame = SKSpriteNode.init(imageNamed: "newGameButton")
        btnStartGame.name = "buttonSprite-Start"
        btnStartGame.zPosition = 3
        btnStartGame.position = CGPoint(x: inThisScene.size.width/2, y: (inThisScene.size.height*2/15))
        
    }
}
