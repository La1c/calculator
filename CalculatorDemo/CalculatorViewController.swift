//
//  CalculatorViewController.swift
//  CalculatorDemo
//
//  Created by Vladimir on 19.09.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
  
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var additionButton: UIButton! //tag = 1
    @IBOutlet weak var multiplicationButton: UIButton! //tag = 2
    @IBOutlet weak var subtractionButton: UIButton! //tag = 3
    @IBOutlet weak var sqareRootButton: UIButton! //tag = 4
    @IBOutlet weak var powerButton: UIButton! //tag = 5
    @IBOutlet weak var divisionButton: UIButton! //tag = 6
    @IBOutlet weak var signButton: UIButton! // tag = 7
    
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var equalsButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    
    //indirect keyword allows storing by reference
    indirect enum Expression{
        case number(Double)
        case addition(Expression,Expression)
        case multiplication(Expression, Expression)
        case subtraction(Expression,Expression)
        case squareRoot(Expression)
        case power(Expression)
        case division(Expression, Expression)
    }
    
    
    var currentExpr: Expression = Expression.number(0) //expression to evalueate
    var binaryOperationIsActive: Bool = false // if we are waiting for the second operand
    var lastBinaryOperationTag: Int? = nil // saving last binary operation tag to perform the operation when we get second operand
    var userIsTyping: Bool = false
    var dotIsActive: Bool = false // should we work with reals?
    
    
    func evaluateExpression(_ expression:Expression) -> Double{
        switch expression {
        case let .number(value):
            return value
        case let .addition(left,right):
            return evaluateExpression(left) + evaluateExpression(right)
        case let .multiplication(left, right):
            return evaluateExpression(left) * evaluateExpression(right)
        case let .subtraction(left,right):
            return evaluateExpression(left) - evaluateExpression(right)
        case let .squareRoot(value):
            return sqrt(evaluateExpression(value))
        case let .power(value):
            return pow(evaluateExpression(value), 2)
        case let .division(divident, divisor):
            let div = evaluateExpression(divisor)
            if(div != 0){
                return evaluateExpression(divident) / div
            }
            else{
                return Double.infinity
            }
        }
    }
        
    
    
    @IBAction func equalsButtonPressed(_ sender: AnyObject) {
        
        if(binaryOperationIsActive){
            performBinaryOperation(with: lastBinaryOperationTag)
        }
        let result = evaluateExpression(currentExpr)
        displayLabel.text = String(Int(result))
        setDefaults()
    }
    
    @IBAction func clearButtonPressed(_ sender: AnyObject) {
        setDefaults()
        currentExpr = Expression.number(0)
        displayLabel.text = "0"
    }
    
    @IBAction func numberButtonPressed(_ sender: AnyObject) {
        let buttonPressed = sender as! UIButton
        
        
        guard let currentText = displayLabel.text else {
            print("No text on the label!")
            return
        }
        
        guard let buttonText = buttonPressed.titleLabel?.text else {
            print("No text on the button!")
            return
        }
        
        
        if(userIsTyping && displayLabel.text != "0"){
            displayLabel.text = currentText + buttonText
        }else{
            displayLabel.text = buttonText
            userIsTyping = true
        }
    }
    
    func performBinaryOperation(with tag: Int?){
        guard let tag = tag else {
            print("Tag is nil")
            return
        }
        
        switch tag {
        case 1:
            currentExpr = Expression.addition(Expression.number(Double(displayLabel.text!)!), currentExpr)
        case 3:
            currentExpr = Expression.subtraction(currentExpr, Expression.number(Double(displayLabel.text!)!))
        default:
            print("Do nothing")
        }
    }
    
    func performUnaryOperation(with tag: Int?){
        guard let tag = tag else {
            print("Tag is nil")
            return
        }
        
        switch tag{
        case 5:
            let num = Double(displayLabel.text!)!
            displayLabel.text = dotIsActive ? String(num*num) : String(Int(num * num))
        case 7:
            let num = Double(displayLabel.text!)!
            displayLabel.text = dotIsActive ? String(-num) : String(Int(-num))
        default:
            print("Do nothing")
        }
    }
    
    
    func setDefaults(){
        binaryOperationIsActive = false
        lastBinaryOperationTag  = nil
        userIsTyping = false
        dotIsActive = false
    }
    
    
    
   //Doesn't work yet
    @IBAction func unaryOperationButtonPressed(_ sender: AnyObject) {
//        let buttonPressed = sender as! UIButton
//        performUnaryOperation(with: buttonPressed.tag)
//        if(userIsTyping){
//            currentExpr = Expression.number(Double(displayLabel.text!)!)
//        }
    }
    
    
    @IBAction func binaryOperationButtonPressed(_ sender: AnyObject) {
        let buttonPressed = sender as! UIButton
        
        if(binaryOperationIsActive){
            performBinaryOperation(with: lastBinaryOperationTag)
            userIsTyping = false
        }
        
        if(userIsTyping){
            currentExpr = Expression.number(Double(displayLabel.text!)!)
            userIsTyping = false
        }
        
        binaryOperationIsActive = true
        lastBinaryOperationTag = buttonPressed.tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
        currentExpr = Expression.number(Double(displayLabel.text!)!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

