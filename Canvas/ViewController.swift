//
//  ViewController.swift
//  Canvas
//
//  Created by Raina Wang on 10/4/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet var parentView: UIView!
    var newlyCreatedFace: UIImageView!
    
    var faceOriginalCenter: CGPoint!

    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayOriginalCenter = trayView.center
        trayCenterWhenOpen = CGPoint(x: trayOriginalCenter.x, y: parentView.frame.height - (trayView.frame.height/2))
        trayCenterWhenClosed = CGPoint(x: trayOriginalCenter.x, y: parentView.frame.height + (trayView.frame.height/3))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        let panGestureRecognizer = sender 
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let translation = panGestureRecognizer.translation(in: parentView)
        let velocity = panGestureRecognizer.velocity(in: parentView)
        
        if panGestureRecognizer.state == .began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.0, options: [], animations: {
                if (velocity.y > 0) {
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenClosed.y)
                } else {
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenOpen.y)
                }
            }, completion: nil)
        }
    }

    @IBAction func onTrayTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.0, options: [], animations: {
                if (self.trayView.center == self.trayCenterWhenOpen) {
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenClosed.y)
                } else {
                    self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayCenterWhenOpen.y)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    @IBAction func onImagePanGesture(_ sender: UIPanGestureRecognizer) {
        let panGestureRecognizer = sender
        panGestureRecognizer.delegate = self

        let imageView = panGestureRecognizer.view as! UIImageView
        let translation = panGestureRecognizer.translation(in: parentView)

        if panGestureRecognizer.state == .began {
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.center = faceOriginalCenter
            parentView.addSubview(newlyCreatedFace)
            newlyCreatedFace.center.y += trayView.frame.origin.y
            faceOriginalCenter = newlyCreatedFace.center
        } else if panGestureRecognizer.state == .changed {
            newlyCreatedFace.center = CGPoint(x: faceOriginalCenter.x + translation.x, y: faceOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == .ended {
            newlyCreatedFace.center = CGPoint(x: faceOriginalCenter.x + translation.x, y: faceOriginalCenter.y + translation.y)
        }
    }
}

