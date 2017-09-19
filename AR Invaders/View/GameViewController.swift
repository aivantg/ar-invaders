//
//  GameViewController.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 8/6/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import ReplayKit

struct PhysicsMask {
    static let playerBullet = 0
    static let enemyBullet = 1
    static let enemy = 2
}

enum LaserType  {
    case player
    case enemy
}

class GameViewController: UIViewController, GameDelegate{

    
    @IBOutlet var sceneView : ARSCNView!
    var aliens = [AlienNode]()
    var lasers = [LaserNode]()
    var game = Game()
    
    // Next 3 variables define how the score and such should be displayed on the screen
    
    lazy var paragraphStyle : NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        return style
    }()
    
    lazy var stringAttributes : [NSAttributedStringKey : Any] = [.strokeColor : UIColor.black, .strokeWidth : -4, .foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 20, weight: .bold), .paragraphStyle : paragraphStyle]
    
    lazy var titleAttributes : [NSAttributedStringKey : Any] = [.strokeColor : UIColor.black, .strokeWidth : -4, .foregroundColor: UIColor.white, .font : UIFont.systemFont(ofSize: 50, weight: .bold), .paragraphStyle : paragraphStyle]
    
    // Nodes for the scene itself
    var scoreNode : SKLabelNode!
    var livesNode : SKLabelNode!
    var winNode : SKLabelNode!
    var radarNode : SKShapeNode!
    
    let topPadding : CGFloat = 20
    let sidePadding : CGFloat = 5
    

    var isRecording = false // Used to toggle screen recording

    
    //MARK: GameDelegate Functions
    
    func scoreDidChange() {
        scoreNode.attributedText = NSMutableAttributedString(string: "Score: \(game.score)", attributes: stringAttributes)
        if game.score >= game.goalScore {
            game.winLoseFlag = true
            showFinish()
        }
    }
    
    func healthDidChange() {
        livesNode.attributedText = NSAttributedString(string: "Health: \(game.health)", attributes: stringAttributes)
        if game.health <= 0 {
            game.winLoseFlag = false
            showFinish()
        }
    }

    
    //MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupGestureRecognizers()
        game.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //Mark: UI Setup
    
    private func setupScene(){
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.overlaySKScene = SKScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene?.scaleMode = .resizeFill
        setupLabels()
        setupRadar()
    }
    
    private func configureScene(){
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }
    
    private func setupGestureRecognizers(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        let threeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleThreeFingerTap(sender:)))
        
        threeTapRecognizer.numberOfTouchesRequired = 3
        tapRecognizer.numberOfTouchesRequired = 1
        
        sceneView.addGestureRecognizer(tapRecognizer)
        sceneView.addGestureRecognizer(threeTapRecognizer)
    }
    
    private func setupRadar(){
        let size = sceneView.bounds.size

        radarNode = SKShapeNode(circleOfRadius: 40)
        radarNode.position = CGPoint(x: (size.width - 40) - sidePadding, y: 50 + sidePadding)
        radarNode.strokeColor = .black
        radarNode.glowWidth = 5
        radarNode.fillColor = .white
        sceneView.overlaySKScene?.addChild(radarNode)

        for i in (1...3){
            let ringNode = SKShapeNode(circleOfRadius: CGFloat(i * 10))
            ringNode.strokeColor = .black
            ringNode.glowWidth = 0.2
            ringNode.name = "Ring"
            ringNode.position = radarNode.position
            sceneView.overlaySKScene?.addChild(ringNode)
        }
        
        for _ in (0..<(game.maxAliens)){
            let blip = SKShapeNode(circleOfRadius: 5)
            blip.fillColor = .red
            blip.strokeColor = .clear
            blip.alpha = 0
            radarNode.addChild(blip)
        }
        
    }
    
    private func setupLabels(){
        let size = sceneView.bounds.size

        scoreNode = SKLabelNode(attributedText: NSAttributedString(string: "Score: \(game.score)", attributes: stringAttributes))
        livesNode = SKLabelNode(attributedText: NSAttributedString(string: "Health: \(game.health)", attributes: stringAttributes))
        winNode = SKLabelNode(text: "Default")
        winNode.alpha = 0
    
        
        scoreNode.position = CGPoint(x: (size.width - scoreNode.frame.width/2) - sidePadding, y: (size.height - scoreNode.frame.height) - topPadding)
        livesNode.position = CGPoint(x: sidePadding + livesNode.frame.width/2, y: (size.height - livesNode.frame.height) - topPadding )
        winNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        sceneView.overlaySKScene?.addChild(scoreNode)
        sceneView.overlaySKScene?.addChild(livesNode)
        sceneView.overlaySKScene?.addChild(winNode)
    }
    
    private func showFinish(){
        guard let hasWon = game.winLoseFlag else { return }
        winNode.alpha = 1
        winNode.attributedText = NSAttributedString(string: hasWon ? "You Win!" : "You Lose!", attributes: titleAttributes)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            if self.isRecording {
                self.handleThreeFingerTap(sender: UITapGestureRecognizer())
            }
            self.performSegue(withIdentifier: "unwind", sender: self)
        })
    }
    
    //Mark: UI Gesture Actions

    @objc func handleTap(recognizer: UITapGestureRecognizer){
        if game.playerCanShoot() {
            fireLaser(fromNode: sceneView.pointOfView!, type: .player)
        }
    }
    
    @objc func handleThreeFingerTap(sender: UITapGestureRecognizer){
        ScreenCaptureUtility.shared.toggleRecording()
    }
    
    //MARK: Game Actions
    
    func fireLaser(fromNode node: SCNNode, type: LaserType){
        guard game.winLoseFlag == nil else { return }
        let pov = sceneView.pointOfView!
        var position: SCNVector3
        var convertedPosition: SCNVector3
        var direction : SCNVector3
        switch type {
            
        case .enemy:
            // If enemy, shoot in the direction of the player
            position = SCNVector3Make(0, 0, 0.05)
            convertedPosition = node.convertPosition(position, to: nil)
            direction = pov.position - node.position
        default:
            // If player, shoot straight ahead
            position = SCNVector3Make(0, 0, -0.05)
            convertedPosition = node.convertPosition(position, to: nil)
            direction = convertedPosition - pov.position
        }
        
        let laser = LaserNode(initialPosition: convertedPosition, direction: direction, type: type)
        lasers.append(laser)
        sceneView.scene.rootNode.addChildNode(laser.node)
    }
    
    private func spawnAlien(alien: Alien){
        let pov = sceneView.pointOfView!
        let y = (Float(arc4random_uniform(60)) - 29) * 0.01 // Random Y Value between -0.3 and 0.3
        
        //Random X and Z value around the circle
        let xRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let zRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let length = Float(arc4random_uniform(6) + 4) * -0.3
        let x = length * sin(xRad)
        let z = length * cos(zRad)
        let position = SCNVector3Make(x, y, z)
        let worldPosition = pov.convertPosition(position, to: nil)
        let alienNode = AlienNode(alien: alien, position: worldPosition, cameraPosition: pov.position)
        
        aliens.append(alienNode)
        sceneView.scene.rootNode.addChildNode(alienNode.node)
    }

}

//MARK: Scene Physics Contact Delegate

extension GameViewController : SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let maskA = contact.nodeA.physicsBody!.contactTestBitMask
        let maskB = contact.nodeB.physicsBody!.contactTestBitMask

        switch(maskA, maskB){
        case (PhysicsMask.enemy, PhysicsMask.playerBullet):
            hitEnemy(bullet: contact.nodeB, enemy: contact.nodeA)
        case (PhysicsMask.playerBullet, PhysicsMask.enemy):
            hitEnemy(bullet: contact.nodeA, enemy: contact.nodeB)
        default:
            break
        }
    }
    
    func hitEnemy(bullet: SCNNode, enemy: SCNNode){
        bullet.removeFromParentNode()
        enemy.removeFromParentNode()
        game.score += 1
    }
}

//MARK: AR SceneView Delegate
extension GameViewController : ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard game.winLoseFlag == nil else { return }

        // Lets the game object give an alien to spawn
        if let alien = game.spawnAlien(numAliens: aliens.count){
            spawnAlien(alien: alien)
        }
        
        for (i, alien) in aliens.enumerated().reversed() {
            
            // If alien isn't in the world any more, then remove it from our alien list
            guard alien.node.parent != nil else {
                aliens.remove(at: i)
                continue
            }
            
            // Move alien closer to where they need to go
            if alien.move(towardsPosition: sceneView.pointOfView!.position) == false {
                // If move function returned false, assume a crash and remove alien from world.
                alien.node.removeFromParentNode()
                aliens.remove(at: i)
                game.health -= alien.alien.health
            }else {
            
                if alien.alien.shouldShoot() {
                    fireLaser(fromNode: alien.node, type: .enemy)
                }
            }
        }
        
        // Draw aliens on the radar as an XZ Plane
        for (i, blip) in radarNode.children.enumerated() {
            if i < aliens.count {
                let alien = aliens[i]
                blip.alpha = 1
                let relativePosition = sceneView.pointOfView!.convertPosition(alien.node.position, from: nil)
                var x = relativePosition.x * 10
                var y = relativePosition.z * -10
                if x >= 0 { x = min(x, 35) } else { x = max(x, -35)}
                if y >= 0 { y = min(y, 35) } else { y = max(y, -35)}
                blip.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
            }else{
                // If there are less aliens than the max amount, hide the extra blips.
                // Note: SceneKit seemed to have a problem with dynmically adding and
                // removing blips so I removed that feature and stuck with a static maximum.
                blip.alpha = 0
            }
            
        }
        
        for (i, laser) in lasers.enumerated().reversed() {
            if laser.node.parent == nil {
                // If laser is no longer in the world, remove it from our list
                lasers.remove(at: i)
            }
            // Move the lasers and remove if necessary
            if laser.move() == false {
                laser.node.removeFromParentNode()
                lasers.remove(at: i)
            }else{
                // Check for a hit against the player
                if laser.node.physicsBody?.contactTestBitMask == PhysicsMask.enemyBullet
                    && laser.node.position.distance(vector: sceneView.pointOfView!.position) < 0.03{
                    laser.node.removeFromParentNode()
                    lasers.remove(at: i)
                    game.health -= 1
                }
            }
        }
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            print("Camera Not Available")
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                print("Camera Tracking State Limited Due to Excessive Motion")
            case .initializing:
                print("Camera Tracking State Limited Due to Initalization")
            case .insufficientFeatures:
                print("Camera Tracking State Limited Due to Insufficient Features")
                
            }
        case .normal:
            print("Camera Tracking State Normal")
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session Failed with error: \(error.localizedDescription)")
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session Interrupted")
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session no longer being interrupted")
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}


