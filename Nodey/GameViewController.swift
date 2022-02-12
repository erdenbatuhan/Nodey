//
//  GameViewController.swift
//  Nodey
//
//  Created by Batuhan Erden on 8/20/16.
//  Copyright © 2016 Batuhan Erden. All rights reserved.
//

import UIKit;
import SpriteKit;

internal class GameViewController : UIViewController {
    
    var scene : GameScene!

    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Configure the view
        let skView = view as! SKView;
        skView.multipleTouchEnabled = false;
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size);
        scene.scaleMode = .AspectFill;
        
        // Present the scene
        skView.presentScene(scene);
        
    }

    override func shouldAutorotate() -> Bool {
        return true;
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return .AllButUpsideDown;
        } else {
            return .All;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}
