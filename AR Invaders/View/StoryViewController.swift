//
//  StoryViewController.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 1/8/18.
//  Copyright © 2018 aivantgoyal. All rights reserved.
//

import UIKit
import AGTypewriterLabel

class StoryViewController: UIViewController, AGTypewriterLabelDelegate {

    @IBOutlet weak var storyTypingLabel: AGTypewriterLabel!
    
    var labelText = "Hello Soldier. Welcome to the battlefield. The aliens have began their attack on earth, so we're going to have to beam you down. It's a strange world out there so be careful. If they destroy your ship's defenses, we'll automatically bring you back, but try and fend off the attack. The world is counting on you."
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Appeared")
        storyTypingLabel.addAnimation(.text(string: "Hello...", interval: 0.2))
        //storyTypingLabel.addAnimation(.flash(string: ".", onInterval: 0.1, offInterval: 0.1, length: 3.0))
        storyTypingLabel.addAnimation(.pause(length: 1.0))
        storyTypingLabel.addAnimation(.text(string: "World", interval: 0.1))
        storyTypingLabel.addAnimation(.pause(length: 1.0))
        storyTypingLabel.addAnimation(.text(string: "?", interval: 0))
        storyTypingLabel.delegate = self
        storyTypingLabel.startAnimation()
    }

    func didFinishAnimating(label: AGTypewriterLabel) {
        Thread.sleep(forTimeInterval: 2)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
