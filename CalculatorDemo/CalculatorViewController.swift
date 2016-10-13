//
//  CalculatorViewController.swift
//  CalculatorDemo
//
//  Created by Vladimir on 19.09.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var displayLabel: UILabel!
    
    //Constants
    fileprivate static let DecimalDigits = 6

    fileprivate var userIsTyping: Bool = false
    fileprivate var dotIsActive: Bool = false
    fileprivate var calcModel = CalculatorModel(decimalDigits: DecimalDigits)
    fileprivate let decimalSeparator = NumberFormatter().decimalSeparator!
    
    fileprivate var displayValue: Double?{
        get{
            if let text = displayLabel.text, let value = Double(text){
                return value
            }
            return nil
        }
        set{
            if let val = newValue{
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = CalculatorViewController.DecimalDigits
                displayLabel.text = formatter.string(from: NSNumber(value: val))
            }
            else{
                displayLabel.text = "0"
                setDefaults()
            }
        }
    }
    
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        if(userIsTyping){
            calcModel.setNewOperand(operand: displayValue)
            userIsTyping = false
        }
        if let operationSymbol = sender.titleLabel?.text{
            calcModel.performOperation(symbol: operationSymbol)
        }
        
        displayValue = calcModel.result
    }
    
    @IBAction func clearButtonPressed(_ sender: AnyObject) {
        setDefaults()
        displayValue = nil
        calcModel = CalculatorModel(decimalDigits: CalculatorViewController.DecimalDigits)
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        
        if let number = sender.titleLabel?.text{
            
            if(number == decimalSeparator){
                if dotIsActive{
                    return
                }
                
                dotIsActive = true
                if userIsTyping {
                     displayLabel.text = displayLabel.text! + number
                }
                else{
                    displayLabel.text = "0" + decimalSeparator
                    userIsTyping = true
                }
                return
            }
            
            if(userIsTyping){
                displayLabel.text = displayLabel.text! + number
            }else{
                displayLabel.text = number
                userIsTyping = true
            }
        }
    }
    
    func setDefaults(){
        userIsTyping = false
        dotIsActive = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

