//
//  FunController.swift
//  AC
//
//  Created by AndreOsip on 7/12/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import UIKit

class FunController: UIViewController {
    
    @IBOutlet weak var theGif: UIImageView!
    
    
    @IBOutlet weak var leafsStepper: UIStepper!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var snowSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    
    let animationController = "AnimationController"
    let snowController = "SnowController"
    
    var emitter = CAEmitterLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let animation = defaults.value(forKey: animationController) {
            animationSwitch.isOn = animation as! Bool
        }
        if let snow = defaults.value(forKey: snowController) {
            snowSwitch.isOn = snow as! Bool
        }
        if snowSwitch.isOn {
            snow()
        } else {
            leafsStepper.isEnabled = false
        }
        
        
        animationSwitch.onTintColor = UIColor(red: 0.9, green: 0.73, blue: 0.32, alpha: 1)
        animationSwitch.thumbTintColor = UIColor(red: 0.76, green: 0.49, blue: 0.18, alpha: 1)
        
        //initialazing the array of images for gif
        var imiges = [UIImage]()
        for i in 1...85 {
            imiges.append(UIImage(named: "giphy-\(i) (dragged).tiff")!)
        }
        theGif.animationImages = imiges
        theGif.animationDuration = 6.0
        
    }
    
    //changing the emitter when rotating
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            emitter.emitterSize = CGSize(width: view.frame.height, height: 2)
            emitter.emitterPosition = CGPoint(x: view.frame.height / 2, y: 0)
            emitter.emitterCells?.first?.birthRate = 2
        } else {
            
            view.layer.sublayers?.removeLast()
            snow()
            emitter.emitterCells?.first?.birthRate = 1.5
        }
    }
    
    @IBAction func animationSwitchChanged(_ sender: UISwitch) {
        if animationSwitch.isOn {
            theGif.startAnimating()
        } else {
            theGif.stopAnimating()
        }
        defaults.set(animationSwitch.isOn, forKey: animationController)
    }
    
    @IBAction func snowSwitchChanged(_ sender: UISwitch) {
        if snowSwitch.isOn {
            snow()
            leafsStepper.isEnabled = true
        } else {
            view.layer.sublayers?.removeLast()
            leafsStepper.isEnabled = false
        }
        defaults.set(snowSwitch.isOn, forKey: snowController)
    }
    
    
    //increasing the lifs count
    @IBAction func StepperChanged(_ sender: UIStepper) {
        view.layer.sublayers?.removeLast()
        snow()
        emitter.emitterCells?.first?.birthRate = Float(sender.value)
        
    }
    
    //define the emitter
    func snow() {
        emitter = Emitter.get(with: #imageLiteral(resourceName: "learn-2"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    
}
