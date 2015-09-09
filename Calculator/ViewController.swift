//
//  ViewController.swift
//  Calculator
//
//  Created by Xing Hui Lu on 8/15/15.
//  Copyright (c) 2015 Xing Hui Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var middleOfTyping: Bool = false
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get { return NSNumberFormatter().numberFromString(display.text!)?.doubleValue }
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = "0"
            }
            middleOfTyping = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        removeOperationCompletion()

        if (digit == "." && display.text?.rangeOfString(".") != nil) || (digit == "." && !middleOfTyping) { return }
        
        if !middleOfTyping {
            middleOfTyping = true
            display.text = digit
        } else {
            display.text = display.text! + digit
        }
    }
    
    @IBAction func appendVariable() {
        brain.pushOperand("M")
        if let evaluation = brain.evaluate() {
            display.text = "\(evaluation)"
        }
    }
    
    @IBAction func backspace() {
        if count(display.text!) > 0 {
            display.text = dropLast(display.text!)
        }
        
        if count(display.text!) == 0 {
            display.text = "0"
            middleOfTyping = false
        }
    }
    
    @IBAction func changeDisplaySign() {
        if middleOfTyping {
            if display.text!.hasPrefix("-") {
                display.text!.removeAtIndex(display.text!.startIndex)
            } else {
                display.text!.insert("-", atIndex: display.text!.startIndex)
            }
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        history.text = "History"
        brain = CalculatorBrain()
        
        middleOfTyping = false
    }
    
    @IBAction func enter() {
        middleOfTyping = false
        
        if let displayValue = displayValue {
            brain.pushOperand(displayValue)
            history.text = "\(brain)"
        } else { displayValue = nil }
    }
    
    @IBAction func operate(sender: UIButton) {
        if middleOfTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        history.text = "\(brain)"
        operationCompletion()
    }
    
    func operationCompletion() {
        history.text = history.text! + "="
        
    }
    
    func removeOperationCompletion() {
        if let range = history.text?.rangeOfString("=") {
            history.text!.removeRange(range)
        }
    }
    
    @IBAction func setVariable() {
        brain.variableValues["M"] = displayValue
        middleOfTyping = false
        
        if let evaluation = brain.evaluate() {
            display.text = "\(evaluation)"
        }
    }
}
