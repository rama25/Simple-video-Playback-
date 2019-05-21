//
//  ViewController.swift
//  Simple-Video-Playback
//
//  Created by Ramapriya Ranganath on 7/5/17.
//  Copyright © 2017 Ramapriya Ranganath. All rights reserved.
//

import UIKit
import AVKit

let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM1W-vUOMe6RSA3pA6Vw-VWUNn5rL0lzQabvrI63-VjS93gVUugDlmBpHIxP16X8TSe5LSKM415UHeMBmxl7pqcwVY_AZ4yKFwIpZPvXE34TpXEYYcmulxJQAOvHbv2dpfq-S_cm"
let kViewControllerAccountID = "3636334163001"
let kViewControllerVideoID = "3666678807001"

class ViewController: UIViewController, BCOVPlaybackControllerDelegate {
    
    
    let playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)
    let avpvc = AVPlayerViewController()
    let playbackController :BCOVPlaybackController
    
    required init?(coder aDecoder: NSCoder)
    {
        let manager = BCOVPlayerSDKManager.shared()!
        playbackController = manager.createPlaybackController()
        
        super.init(coder: aDecoder)
        
        playbackController.analytics.account = kViewControllerAccountID;
        
        playbackController.delegate = self
        playbackController.isAutoAdvance = true
        playbackController.isAutoPlay = true
        
        //use the AVPlayerViewController instead of the BCOVPlaybackSession class' AVPlayerLayer
        //this is needed if you want to test in the simulator
        var mutableOptions = self.playbackController.options
        mutableOptions?[kBCOVAVPlayerViewControllerCompatibilityKey] = true
        self.playbackController.options = mutableOptions
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    func requestContentFromPlaybackService() {
        playbackService?.findVideo(withVideoID: kViewControllerVideoID, parameters: nil) {
            (video: BCOVVideo?, dict: [AnyHashable:Any]?, error: Error?) in
            if let v = video {
                self.playbackController.setVideos([v] as NSFastEnumeration!)
            } else {
                print("ViewController Debug - Error retrieving video: %@", error!)
            }
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!)
    {
        NSLog("ViewController Debug - Advanced to new session.")
        self.avpvc.player = session.player;
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!)
    {
        NSLog("Event: %@", lifecycleEvent.eventType)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func play(_ sender: Any) {
        self.addChildViewController(self.avpvc);
        self.avpvc.view.frame = self.view.bounds;
        self.avpvc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.avpvc.view);
        self.avpvc.didMove(toParentViewController: self)
        
        requestContentFromPlaybackService()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

