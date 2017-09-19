//
//  Laser.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 8/7/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import UIKit
import ARKit

class LaserNode: SCNNodeContainer{
    
    
    var initialPosition : SCNVector3!
    var direction : SCNVector3!
    var type : LaserType
    var node : SCNNode!
    
    init(initialPosition: SCNVector3, direction: SCNVector3, type: LaserType){
        self.initialPosition = initialPosition
        self.direction = direction.normalized() // Makes sure the direction represents one meter
        self.type = type
        self.node = createNode()
        self.node.position = initialPosition
    }
    
    func createNode() -> SCNNode{
        
        // Creates geometry of a sphere and paints it red
        let geometry = SCNSphere(radius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = type == .player ? UIColor.red : UIColor.green
        geometry.materials = [material]
        let sphereNode = SCNNode(geometry: geometry)
        
        // The sphereNode has a static physics body so we can control it's position ourselves instad of using forces
        sphereNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        sphereNode.physicsBody?.contactTestBitMask = type == .player ? PhysicsMask.playerBullet : PhysicsMask.enemyBullet
        sphereNode.physicsBody?.isAffectedByGravity = false
        return sphereNode
    }
    
    /// Runs once every frame
    func move() -> Bool{
        
        self.node.position += direction/60 //Travels 1 m/s
        if self.node.position.distance(vector: initialPosition) > 3 {
            return false
        }
        return true
    }
}
