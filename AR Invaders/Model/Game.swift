//
//  Game.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 8/13/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import Foundation


class Game {
    
    var delegate : GameDelegate?
    
    let cooldown = 0.3 // Player shot cooldown in number of seconds
    let power = 1 // How much power a player bullet has
    var health = 10  { // How much health the player has
        didSet{
            delegate?.healthDidChange()
        }
    }
    
    var lastShot : TimeInterval = 0 // Stores the last time user shot
    
    func playerCanShoot() -> Bool { // runs 60 fps
        let curTime = Date().timeIntervalSince1970
        if(curTime - lastShot > cooldown){
            lastShot = curTime
            return true
        }
        return false
    }
    
    var spawnCount = 0 // Counter to trigger the spawn
    let spawnFreq = 60 // How often it will try to spawn an alien
    let spawnProb : UInt32 = 3 // Gives a 1 in (n + 1) chance it will spawn an alien when it tries.
    
    let maxAliens = 20 // Max number of aliens that can be spawned.
    let alienPower = 2 // How much health an alien bullet takes away
    let alienHealth = 5 // How much health an alien has
        
    var winLoseFlag : Bool? // optional for whether player has win, lost, or neither
    
    var goalScore = 10 // The score needed to win

    var score = 0 { // Stores the current score
        didSet{
            delegate?.scoreDidChange()
        }
    }
    
    var lastPowerUp : TimeInterval = 0
    
    func spawnAlien(numAliens: Int) -> Alien?{ // Decides whether an alien should be spawned
        guard numAliens < maxAliens else { return nil }
        spawnCount += 1
        if(spawnCount == spawnFreq){
            spawnCount = 0
            if(arc4random_uniform(spawnProb) == 0){
                return Alien(health: 1, power: 1, shotFreq: 60, shotProbHigh: 10, shotProbLow: 2, type: .medium)
            }
        }
        return nil
    }
}

protocol GameDelegate {
    func scoreDidChange()
    func healthDidChange()
}

