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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldPulse = true
        //pulse()
    }
    
    @IBAction func showARSimulation(){
        print("Button Pressed")
        performSegue(withIdentifier: "showARSimulation", sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shouldPulse = false
    }

    func pulse(){
        startButton.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.startButton.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func unwindFromSimulation(segue: UIStoryboardSegue){
        //Do Nothing
    }


}

