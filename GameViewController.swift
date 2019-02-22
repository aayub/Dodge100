//
//  GameViewController.swift
//  Dodge100
//
//  Created by Aayushi Baral on 2017-12-30.
//  Copyright © 2017 Leo's Apps. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SpriteKit
import AVFoundation

class GameViewController: UIViewController{
    
    var backingAudio = AVAudioPlayer()
    
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Background Audio plays throughout the game
        let filePath = Bundle.main.path(forResource: "Track1",ofType:"mp3")
        let audioNS_URL = NSURL(fileURLWithPath: filePath!)
        
        
        do{ backingAudio = try AVAudioPlayer(contentsOf: audioNS_URL as URL)
            backingAudio.numberOfLoops = -1
            backingAudio.play()}
        catch{ return print("No Audio Found")}
        

        // Load the SKScene from 'MainMenuScene.swift'
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        let skView = self.view as! SKView
        scene.scaleMode = .aspectFill
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        
        // Google Banner Ads
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID =  "ca-app-pub-8355047573696380/4206252830"
        bannerView.rootViewController = self
        //bannerView.load(GADRequest())
        
        // TEST: "ca-app-pub-3940256099942544/2934735716"
        // REAL: "ca-app-pub-8355047573696380/4206252830"
        
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

