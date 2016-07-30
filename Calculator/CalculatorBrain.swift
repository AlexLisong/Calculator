//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by SongLing Dong on 7/30/16.
//  Copyright © 2016 Crazyrunner. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    //for MC MR M- M+
    private var valueInMemory = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E) ,
        "±": Operation.UnaryOperation({-$0}),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals,
        "M+" : Operation.MKeyBinaryOperation({$0 + $1}),
        "M-" : Operation.MKeyBinaryOperation({$0 - $1}),
        "MC" : Operation.MC,
        "MR" : Operation.MR
    
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case MKeyBinaryOperation((Double, Double) -> Double)
        case MR
        case MC
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value) :
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOpeation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOpeation()
            case .MKeyBinaryOperation(let function):
                executePendingBinaryOpeation()
                valueInMemory = function(accumulator, valueInMemory)
            case .MR:
                accumulator = valueInMemory
            case .MC:
                valueInMemory = 0.0
            }
        }
    }
    
    private func executePendingBinaryOpeation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
        
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand :Double
    }
        
    var result: Double{
        get {
            return accumulator
        }
    }
    
}
