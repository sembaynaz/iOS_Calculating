//
//  CalculatorViewControllerViewModel.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import UIKit

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CalculatorViewControllerViewModel {
    var updateViews: (()->Void)?
    
    let buttonsArray: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .numbers(7), .numbers(8), .numbers(9), .multiply,
        .numbers(4), .numbers(5), .numbers(6), .minus,
        .numbers(1), .numbers(2), .numbers(3), .plus,
        .numbers(0), .decimal, .equal
    ]
    
    // MARK: Normal Variables
    lazy var resultLabel: String = firstNumber?.description ?? "0"
    
    var firstNumber: String? = nil {
        didSet {
            resultLabel = firstNumber?.description ?? "0"
        }
    }
    var secondNumber: String? = nil {
        didSet {
            resultLabel = secondNumber?.description ?? "0"
        }
    }
    
    var firstNumberIsDecimal: Bool = false
    var secondNumberIsDecimal: Bool = false
    
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    
    var operation: CalculatorOperation? = nil
    var currentNumber: CurrentNumber = .firstNumber
    
    //MARK: Memory Variables
    var previousResult: String? = nil
    var previousOperation: CalculatorOperation? = nil
}


extension CalculatorViewControllerViewModel {
    
    public func didSelectButton(calcButton: Buttons) {
        switch calcButton {
        case .allClear: didSelectAllClear()
        case .plusMinus: didSelectPlusMinus()
        case .percentage: didSelectPercentage()
        case .divide: didSelectOperation(operation: .divide)
        case .multiply: didSelectOperation(operation: .multiply)
        case .minus: didSelectOperation(operation: .minus)
        case .plus: didSelectOperation(operation: .plus)
        case .equal: didSelectEqualsButton()
        case .numbers(let number): didSelectNumber(number: number)
        case .decimal: didSelectDecimal()
        }
        self.updateViews?()
    }
    
    private func didSelectNumber(number: Int) {
        if self.currentNumber == .firstNumber {
            if let firstNumber = self.firstNumber {
                
                var firstNumberString = firstNumber.description
                firstNumberString.append(number.description)
                self.firstNumber = firstNumberString
                self.previousResult = firstNumberString
                
            } else {
                self.firstNumber = String(number)
                self.previousResult = String(number)
            }
            
        } else {
            if let secondNumber = self.secondNumber {
                var secondNumberString = secondNumber.description
                secondNumberString.append(number.description)
                self.secondNumber = secondNumberString
                self.previousResult = secondNumberString
            } else {
                self.secondNumber = String(number)
                self.previousResult = String(number)
            }
        }
    }
    
    private func didSelectOperation(operation: CalculatorOperation) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
            
        } else if self.currentNumber == .secondNumber {
            
            if let previousOperation = self.operation,
                let firstNumber = Double(self.firstNumber ?? "0"),
                let secondNumber = Double(self.secondNumber ?? "0")
            {
                let result = self.getOperationResult(
                    previousOperation,
                    firstNumber,
                    secondNumber
                )
                let resultString = eitherNumberIsDecimal ? result.description : Int(result).description
            
                self.secondNumber = nil
                self.firstNumber = resultString
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                    // Else switch operation
                self.operation = operation
            }
        }
    }
    
    private func getOperationResult(_ operation: CalculatorOperation, _ firstNumber: Double, _ secondNumber: Double) -> Double {
        switch operation {
        case .divide:
            return (firstNumber / secondNumber)
        case .multiply:
            return (firstNumber * secondNumber)
        case .minus:
            return (firstNumber - secondNumber)
        case .plus:
            return (firstNumber + secondNumber)
        }
    }
    
    private func didSelectAllClear() {
        self.resultLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.previousResult = nil
        self.previousOperation = nil
    }
    
    private func didSelectEqualsButton() {
        if let operation = self.operation,
           let firstNumber = Double(self.firstNumber ?? "0"),
           let secondNumber = Double(self.secondNumber ?? "0") {
            
            let result = self.getOperationResult(
                operation,
                firstNumber,
                secondNumber
            )
            let resultString = eitherNumberIsDecimal ? result.description : Int(result).description
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .firstNumber
        }
        else if let previousOperation = self.previousOperation,
                let firstNumber = Double(self.firstNumber ?? "0"),
                let previousResult = Double(self.previousResult ?? "0") {
            let result = self.getOperationResult(
                previousOperation,
                firstNumber,
                previousResult
            )
            let resultString = eitherNumberIsDecimal ? result.description : Int(result).description
            self.firstNumber = resultString
        }
    }
    
    private func didSelectPlusMinus() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            
            self.firstNumber = String(number)
            self.previousResult = String(number)
        } else if self.currentNumber == .secondNumber, var number = secondNumber {
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            
            self.secondNumber = String(number)
            self.previousResult = String(number)
        }
    }
    
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = Double(self.firstNumber!) {
            
            number /= 100
            self.firstNumber = String(number)
            self.previousResult = String(number)
        }
        else if self.currentNumber == .secondNumber, var number = Double(secondNumber!) {
            
            number /= 100
            self.secondNumber = String(number)
            self.previousResult = String(number)
        }
    }
    
    private func didSelectDecimal() {
        if self.currentNumber == .firstNumber {
            if !firstNumberIsDecimal, let firstNumber = self.firstNumber {
                var firstNumberString = firstNumber
                firstNumberString.append(".")
                self.firstNumber = firstNumberString
                firstNumberIsDecimal = true
            } else if self.firstNumber == nil {
                self.firstNumber = "0."
                firstNumberIsDecimal = true
            }
        } else if self.currentNumber == .secondNumber {
            if !secondNumberIsDecimal, let secondNumber = self.secondNumber {
                var secondNumberString = secondNumber
                secondNumberString.append(".")
                self.secondNumber = secondNumberString
                secondNumberIsDecimal = true
            } else if self.secondNumber == nil {
                self.secondNumber = "0."
                secondNumberIsDecimal = true
            }
        }
    }

}
