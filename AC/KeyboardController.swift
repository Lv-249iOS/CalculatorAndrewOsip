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
    
    var onNumTap: ((_ num: Int)->())?
    var onUtilityTap: ((_ symbol: Int)->())?
    
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var piButton: BounceBotton!
    @IBOutlet weak var powButton: BounceBotton!
    
    @IBAction func onNumericTap(button: UIButton) {
        onNumTap?(button.tag)
        
        enablingDot() //turning off the buttons if needed
        enablingPi()
        enablingPow()
    }
    
    @IBAction func onUtilityTap(button: UIButton) {
        onUtilityTap?(button.tag)
        
        enablingDot()
        enablingPi()
        enablingPow()
        
    }
    
    
    func enablingDot () {
        let last = input.lastElementInBuffer()
        if last.isEmpty {
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
            if last.characters.contains(".") || lastCharacterIsNum(input.buffer) || last.characters.last! == ")" {
                piButton.isEnabled = false
            } else {
                piButton.isEnabled = true
            }
        }
    }
    
    func enablingPow () {
        let last = input.lastElementInBuffer()
        if !last.isEmpty {
            if !lastCharacterIsNum(input.buffer) {
                if last.characters.last! == ")" {
                    powButton.isEnabled = true
                } else {
                    powButton.isEnabled = false
                }
            } else {
                powButton.isEnabled = true
            }
        }
    }
}
