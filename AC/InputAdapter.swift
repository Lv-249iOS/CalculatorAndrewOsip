//
//  InputAdapter.swift
//  AC
//
//  Created by AndreOsip on 6/28/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import Foundation

class InputAdapter: InputProtocol {
    static let shared = InputAdapter()
    let brain = Brain.shared
    var thereIsStartedNum = true
    var operationClicked = false
    var pickerIsScroling = false
    var buffer: String = "0"
    var resultCollection: [String] = []
    
    
    
    func enterNum(_ number: Int) {
        if buffer == "" || buffer == "0" || thereIsStartedNum {
            buffer = String(number)
            thereIsStartedNum = false
            
        } else if buffer.characters.last == "." || lastCharacterIsNum(buffer) {
            if pickerIsScroling {                                       //in this case we have to replace last operand with input
                BufferRemoveSubRange()
                buffer+=" "
                pickerIsScroling = false
            }
            buffer = buffer + "\(number)"
        } else {
            buffer = buffer + " \(number)"
        }
        brain.procces(buffer)
    }
    
    func enterUtility(_ symbol: Operation) {
        operationClicked = true
        
        if OperationBinary(symbol) {
            if characterOperationBinary(buffer) {
                buffer.characters.removeLast()
                switch symbol {
                case .pls: buffer += "+"
                case .mns: buffer += "-"
                case .mul: buffer += "×"
                case .div: buffer += "÷"
                default: break
                }
            } else if lastCharacterIsNum(buffer) || buffer.characters.last == ")" {
                switch symbol {
                case .pls: buffer += " +"
                case .mns: buffer += " -"
                case .mul: buffer += " ×"
                case .div: buffer += " ÷"
                default: break
                }
            }
            thereIsStartedNum = false
        }
        if symbol == .leftBracket {
            if lastCharacterIsNum(buffer) && !thereIsStartedNum{
                buffer += " × ("
            } else if thereIsStartedNum{
                buffer = "("
                thereIsStartedNum = false
            } else {
                buffer += " ("
            }
            brain.countOfLeftParentheses += 1
        }
        if symbol == .rightBracket {
            if !characterOperationBinary(buffer) && brain.countOfLeftParentheses > brain.countOfRightParentheses {
                buffer += " )"
                brain.countOfRightParentheses += 1
            }
        }
        
        if symbol == .equal {
            
            brain.EnterEquation(equation: buffer)
            brain.equal()
            
            resultCollection.insert((buffer + " = \(brain.getRessult)"), at: 0)
            buffer = "\(brain.getRessult)"
            thereIsStartedNum = true
            
            OutputAdapter.shared.reloadPicker()
            
            operationClicked = false
        }
        
        if symbol == .dot {
            if thereIsStartedNum && buffer.characters.contains(".") {
                buffer = "0."
            } else {
                buffer = buffer + "."
            }
            thereIsStartedNum = false
        }
        
        if symbol == .pi {
            if thereIsStartedNum {
                buffer = "3.14"
            } else {
                buffer += " 3.14"
            }
        }
        if symbol == .pow {
            buffer += " ^"
            if thereIsStartedNum {
                thereIsStartedNum = false
            }
        }
        
        if symbol == .clear {
            buffer = "0.0"
            resultCollection = []
            OutputAdapter.shared.reloadPicker()
            brain.procces(buffer)
            thereIsStartedNum = true
            
        }
        
        if symbol == .clearLast {
            if !buffer.isEmpty {
                buffer.characters.removeLast()
            }
        }
        
        if OperationUnary(symbol) {
            if lastCharacterIsNum(buffer) && !thereIsStartedNum || buffer.characters.last! == ")" {
                brain.countOfLeftParentheses += 1
                switch symbol {
                case .sin: buffer += " × sin ("
                case .cos: buffer += " × cos ("
                case .sqrt: buffer += " × √ ("
                case .log: buffer += " × ln ("
                default: break
                }
            } else if buffer.characters.last! == "(" || characterOperationBinary(buffer) {
                brain.countOfLeftParentheses += 1
                switch symbol {
                case .sin: buffer += " sin ("
                case .cos: buffer += " cos ("
                case .sqrt: buffer += " √ ("
                case .log: buffer += " ln ("
                default: break
                }
            } else if thereIsStartedNum {
                brain.countOfLeftParentheses += 1
                thereIsStartedNum = false
                switch symbol {
                case .sin: buffer = "sin ("
                case .cos: buffer = "cos ("
                case .sqrt: buffer = "√ ("
                case .log: buffer = "ln ("
                default: break
                }
            }
        }
        
        brain.procces(buffer)
    }
    
    
    
    
    func BufferRemoveSubRange () {
        let lastSpaceIndex = buffer.range(of: " ", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound
        let ending = buffer.index(before: buffer.endIndex)
        if buffer != "" && lastSpaceIndex != nil {
            buffer.removeSubrange(lastSpaceIndex!...ending)}
    }
    
    func lastElementInBuffer() -> (String) {
        let lastSpaceIndex = buffer.range(of: " ", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound
        let resultStr = buffer.substring(from: lastSpaceIndex ?? buffer.startIndex)
        
        return resultStr
    }
    
    
}
func OperationBinary (_ symbol: Operation) ->Bool {
    switch symbol {
    case .pls: fallthrough
    case .mns: fallthrough
    case .mul: fallthrough
    case .div: return true
    default: return false
        
    }
}

func OperationUnary (_ symbol: Operation) ->Bool {
    switch symbol {
    case .sin: fallthrough
    case .cos: fallthrough
    case .sqrt: fallthrough
    case .log: return true
    default: return false
        
    }
}
func characterOperationBinary (_ symbol: String) ->Bool {
    if !symbol.isEmpty {
        switch symbol.characters.last! {
        case "+": fallthrough
        case "-": fallthrough
        case "×": fallthrough
        case "÷": return true
        default: break
        }
    }
    return false
}
func lastCharacterIsNum (_ str: String) -> Bool {
    if !str.isEmpty {
        if str.characters.last! >= "0" && str.characters.last! <= "9" {
            return true
        }
    }
    return false
}
func lastCharacterIsBracket (_ str: String) -> Bool {
    if !str.isEmpty {
        if str.characters.last! == "(" || str.characters.last! == ")" {
            return true
        }
    }
    return false
}


