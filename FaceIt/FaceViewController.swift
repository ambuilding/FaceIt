//
//  ViewController.swift
//  FaceIt
//
//  Created by WangQi on 16/5/19.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    // MARK: Model
    
    var expression =  FacialExpression(eyes: .Closed, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI() // Model changed, so update the view
        }
    }
    
    // MARK: View
    
    // the didSet here is called only once
    // when the outlet is connected up by iOS
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,action: #selector(FaceView.changeScale(_:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(FaceViewController.changeBrows(_:))
                ))
            
            updateUI() // View connected for first time, update if from Model
        }
    }
    
    /*
     gesture handler for taps
     
     toggle the open/closed state of the eyes in the Model
     and all changes to the Model automatically updateUI()
     (see the didSet for the Model var expression above)
     so our faceView will also change its eyes
     
     this handler was added directly in the storyboard
     by dragging a UITapGestureHandler onto the faceView
     then ctrl-dragging from the tap gesture
     (at the top of the scene in the storyboard)
     here to our Controller
     (so there's no need to call addGestureRecognizer)
     */
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break // we don't know how to toggle "Squinting"
            }
        }
    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeDuration = 0.5
    }
    
    @IBAction func headShake(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(
            Animation.ShakeDuration,
            animations: {
                self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            },
            completion: { finished in
                if finished {
                    UIView.animateWithDuration(
                        Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle*2)
                        },
                        completion: { finished in
                            if finished {
                                UIView.animateWithDuration(
                                    Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                                    },
                                    completion: { finished in
                                        if finished {
                                            
                                        }
                                    }
                                )

                            }
                        }
                    )

                }
            }
        )
    }
    
    
    // here the Controller is doing its job
    // of interpreting the Model (expression) for the View (faceView)
    
    private func updateUI() {

        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    private var mouthCurvatures = [
        FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0
    ]
    private var eyeBrowTilts = [
        FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0
    ]
    
    // MARK: Gesture Handlers
    
    // gesture handler for swipe to increase/decrease happiness
    // changes the Model (which will, in turn, updateUI())
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    // gesture handler to change the Model's brows with a rotation gesture
    func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            if recognizer.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        }
    }
    
    //let instance = getFaceMVCinstanceCount()
    
}

