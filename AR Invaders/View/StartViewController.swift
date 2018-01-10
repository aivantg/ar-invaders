//
//  ViewController.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 8/3/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var startButton : UIButton!
    var shouldPulse = false

    @IBOutlet weak var logo: UILabel!

    @IBOutlet weak var hqButton: UIButton!
    @IBOutlet weak var battlefieldButton: UIButton!
    @IBOutlet weak var hangarButton: UIButton!
    
    // MARK - View Controller Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startButton.alpha = 0
        logo.alpha = 0
        hqButton.alpha = 0
        battlefieldButton.alpha = 0
        hangarButton.alpha = 0
    }
    
    //MARK - UI Actions
    @IBAction func startPressed() {
        UIView.animate(withDuration: 1.0, animations: {
            self.startButton.alpha = 0
        }) { (finished) in
            self.startButton.isEnabled = false
            Thread.sleep(forTimeInterval: 0.5)
            UIView.animate(withDuration: 1.0, animations: {
                self.battlefieldButton.alpha = 1
                self.hqButton.alpha = 1
                self.hangarButton.alpha = 1
            })
        }
    }
    
    @IBAction func battlefieldPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoryViewController")
        present(vc, animated: true, completion: nil)
    }
    @IBAction func hqPressed() {
    }
    @IBAction func hangarPressed() {
    }
    
    func introAnimation(){
        Thread.sleep(forTimeInterval: 0.25)
        UIView.animate(withDuration: 1.0, animations: {
            self.logo.alpha = 1
        }) { (finished) in
            Thread.sleep(forTimeInterval: 0.25)
            UIView.animate(withDuration: 1.0, animations: {
                self.startButton.alpha = 1
            })
        }
    }
    
    @IBAction func unwindFromSimulation(segue: UIStoryboardSegue){
        //Do Nothing
    }


}

