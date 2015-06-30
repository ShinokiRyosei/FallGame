//
//  ViewController.swift
//  FallGame
//
//  Created by 椎木亮成 on 2015/06/29.
//  Copyright (c) 2015年 shinokiryosei. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet var balls: [UIView]!
    @IBOutlet var walls: [UIView]!
    @IBOutlet var obstacles: [UIView]!
    
    let motionManager = CMMotionManager()
    
    var dynamicAnimator: UIDynamicAnimator!
    
    var deviceMotion = CMDeviceMotion()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame() {
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 10
        
        let gravityBehavior = UIGravityBehavior(items: self.balls)
        let collisionBehavior = UICollisionBehavior(items: self.balls)
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(collisionBehavior)
        
        for wall in walls {
            collisionBehavior.addBoundaryWithIdentifier(wall.description, forPath: UIBezierPath(rect: wall.frame))
        }
        
        for obstacle in obstacles {
            collisionBehavior.addItem(obstacle)
        }
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
            (deviceMotion: CMDeviceMotion!, error: NSError!) in
            let x = CGFloat(deviceMotion.attitude.roll)
            let y = CGFloat(deviceMotion.attitude.pitch)
            
            gravityBehavior.gravityDirection = CGVectorMake(x, y)
            gravityBehavior.magnitude = 0.5
            
        })
    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint){
        NSLog("衝突しました")
    }

}

