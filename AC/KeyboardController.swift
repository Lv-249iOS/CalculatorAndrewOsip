//
//  KeyboardController.swift
//  AC
//
//  Created by AndreOsip on 6/28/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import UIKit

class KeyboardController: UIViewController {
    let input = InputAdapter.shared
    let output = OutputAdapter.shared
    
    var onNumTap: ((_ num: Int)->())?
    var onUtilityTap: ((_ symbol: Int)->())?
    
    @IBOutlet weak var dotButton: BounceBotton!
    @IBOutlet weak var piButton: BounceBotton!
    @IBOutlet weak var powButton: BounceBotton!
    
    override func viewDidLoad() {
        output.enablingButt = {[weak self] in self?.enabling()}
    }
    
    @IBAction func onNumericTap(button: UIButton) {
        onNumTap?(button.tag)
        
        enabling()
    }
    
    @IBAction func onUtilityTap(button: UIButton) {
        onUtilityTap?(button.tag)
        
        enabling()
        
    }
    
    
    func enablingDot () {
        let last = input.lastElementInBuffer()
        if !last.isEmpty {
            if last.characters.contains(".") || characterOperationBinary(input.buffer) || lastCharacterIsBracket(input.buffer) {
                dotButton.isEnabled = false
            } else {
                dotButton.isEnabled = true
            }
        }
    }
    
    func enablingPi () {
        let last = input.lastElementInBuffer()
        if !last.isEmpty {
            if last.characters.last! == "." || lastCharacterIsNum(input.buffer) || last.characters.last! == ")" {
                piButton.isEnabled = false
            } else {
                piButton.isEnabled = true
            }
        } else { piButton.isEnabled = true }
    }
    
    func enablingPow () {
        let last = input.lastElementInBuffer()
        if !last.isEmpty {
            if lastCharacterIsNum(input.buffer) || last.characters.last! == ")"{
                    powButton.isEnabled = true
            } else {
                powButton.isEnabled = false
            }
        } else {
        powButton.isEnabled = false
        }
    }
    func enabling() {
        enablingDot()
        enablingPi()
        enablingPow()
    }
}
