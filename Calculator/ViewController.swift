//
//  ViewController.swift
//  Calculator
//
//  Created by SongLing Dong on 7/30/16.
//  Copyright © 2016 Crazyrunner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    var userIsInTheMiddleOfcTyping = false
    
    @IBAction private func touchDigit(sender: UIButton, forEvent event: UIEvent) {
        let digit = sender.currentTitle!
        
        if (userIsInTheMiddleOfcTyping){
            let textCurrentlyDispay = display.text!
            if digit == "." && textCurrentlyDispay.containsString(".") {
                return
            }
            display.text = textCurrentlyDispay + digit
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfcTyping = true
        
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton, forEvent event: UIEvent) {
        if userIsInTheMiddleOfcTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfcTyping = false
        }
        if let mathmeaticalSybol = sender.currentTitle{
            brain.performOperation(mathmeaticalSybol)
        }
        displayValue = brain.result
    }
    
}

