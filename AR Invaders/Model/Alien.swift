//
//  Alien.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 9/3/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import UIKit

enum AlienType {
    case small
    case medium
    case large
    
    func getImages() -> (front: UIImage, back: UIImage){
        switch self {
        case .small: return (#imageLiteral(resourceName: "small_invader"), #imageLiteral(resourceName: "small_invader_back"))
        case .medium: return ( #imageLiteral(resourceName: "med_invader"), #imageLiteral(resourceName: "med_invader_back"))
        case .large: return (#imageLiteral(resourceName: "large_invader"), #imageLiteral(resourceName: "large_invader_back"))
        }
    }
}


class Alien {
    
    var health : Int
    let power : Int
    let scoreReward : Int
    var shotCount = 0
    let shotFreq : Int // How often it tries to shoot
    var shotProb : Int { //What's the chance it succeeds in shooting (Chance = 1/shotProb)
        return closeQuarters ? shotProbHigh : shotProbLow
    }
    private let shotProbHigh : Int
    private let shotProbLow : Int
    
    var closeQuarters = false // Whether it is in the goldilocks zone
    let frontImage : UIImage
    let backImage : UIImage
    
    init(health: Int, power: Int, shotFreq: Int, shotProbHigh: Int, shotProbLow: Int, type: AlienType){
        
        self.health = health
        self.scoreReward = health * 10
        self.power = power
        self.shotFreq = shotFreq
        self.shotProbLow = shotProbLow
        self.shotProbHigh = shotProbHigh
        
        let images = type.getImages()
        self.frontImage = images.front
        self.backImage = images.back
        
    }
    
    func shouldShoot() -> Bool { // runs 60 fps
        shotCount += 1
        if(shotCount == shotFreq){
            shotCount = 0
            return arc4random_uniform(UInt32(shotProb)) == 0
        }
        return false
    }
}
