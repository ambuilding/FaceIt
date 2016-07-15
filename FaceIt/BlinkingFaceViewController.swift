//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by WangQi on 16/7/14.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking: Bool = false {
        didSet {
            startBlinK()
        }
    }
    
    private struct BlinkRate {
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlinK() {
        if blinking {
            faceView.eyesOpen = false
            NSTimer.scheduledTimerWithTimeInterval(
                BlinkRate.ClosedDuration,
                target: self,
                selector: #selector(BlinkingFaceViewController.endBlink),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func endBlink() {
        faceView.eyesOpen = true
        NSTimer.scheduledTimerWithTimeInterval(
            BlinkRate.OpenDuration,
            target: self,
            selector: #selector(BlinkingFaceViewController.startBlinK),
            userInfo: nil,
            repeats: false
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        blinking = false
    }

}
