//
//  CalculatorModel.swift
//  CalculatorDemo
//
//  Created by Vladimir on 13.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation

class CalculatorModel{
    
    init(decimalDigits: Int) {
        self.decimalDigits = decimalDigits
        oparationalStack = Array()
    }
    
    
    var result : Double{
        get{
           return currentResult
        }
    }
    
    fileprivate var decimalDigits: Int
    fileprivate var currentResult: Double = 0
    fileprivate var newOperand: Double?
    fileprivate var currentPrecedence = Int.max
    fileprivate var binaryOperationIsWaiting = false
    fileprivate var waitingOperation: waitingBinaryOperation?
    fileprivate var oparationalStack: Array<waitingBinaryOperation>
    
    //indirect keyword allows storing by reference
    
    
    fileprivate struct waitingBinaryOperation{
        var function : (Double, Double) -> Double
        var left: Double
    }
    
    
    fileprivate enum OperationType{
        case number(Double)
        case binary((Double, Double) -> Double, Int)
        case unary((Double) -> Double)
        case equals
    }
    
    
    fileprivate var operations : Dictionary<String, OperationType> = [
        "+" : OperationType.binary(+, 0),
        "-" : OperationType.binary(-, 0),
        "*" : OperationType.binary(*, 1),
        "/" : OperationType.binary(/, 1),
        "x²" : OperationType.unary({ pow($0, 2) }),
        "±" : OperationType.unary({-$0}),
        "√" : OperationType.unary(sqrt),
        "=" : OperationType.equals
    ]
    
    func setNewOperand(operand newOperand: Double?){
            currentResult = newOperand!
    }
    
    fileprivate func performWaitingOperations(){
        while !oparationalStack.isEmpty{
            let curOp = oparationalStack.popLast()!
            currentResult = curOp.function(curOp.left, currentResult)
        }
    }
    
    func performOperation(symbol nextOperation: String){
        if let curentOperation = operations[nextOperation]{
            switch curentOperation {
            case .binary(let function, let precedence):
                if precedence <= currentPrecedence{
                     performWaitingOperations()
                }

                let newWaitingOperation = waitingBinaryOperation(function: function, left: currentResult)
                oparationalStack.append(newWaitingOperation)
                currentPrecedence = precedence
            case .unary(let function):
                currentResult = function(currentResult)
            case .equals:
                performWaitingOperations()
            default:
                return
            }
        }
    }
}
