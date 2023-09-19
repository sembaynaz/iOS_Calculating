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
    
    var firstNumber: Int? = nil {
        didSet {
            resultLabel = firstNumber?.description ?? "0"
        }
    }
    var secondNumber: Int? = nil {
        didSet {
            resultLabel = secondNumber?.description ?? "0"
        }
    }
    
    var operation: CalculatorOperation? = nil
    var currentNumber: CurrentNumber = .firstNumber
    
    //MARK: Memory Variables
    var previousResult: Int? = nil
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
        case .decimal: fatalError()
        }
        self.updateViews?()
    }
    
    private func didSelectNumber(number: Int) {
        if self.currentNumber == .firstNumber {
            if let firstNumber = self.firstNumber {
                var firstNumberString = firstNumber.description
                firstNumberString.append(number.description)
                self.firstNumber = Int(firstNumberString)
                self.previousResult = Int(firstNumberString)
            } else {
                self.firstNumber = Int(number)
                self.previousResult = Int(number)
            }
            
        } else {
            if let secondNumber = self.secondNumber {
                var secondNumberString = secondNumber.description
                secondNumberString.append(number.description)
                self.secondNumber = Int(secondNumberString)
                self.previousResult = Int(secondNumberString)
            } else {
                self.secondNumber = Int(number)
                self.previousResult = Int(number)
            }
        }
        
        print(firstNumber?.description)
        print(secondNumber?.description)
        print(currentNumber)
    }
    
    private func didSelectOperation(operation: CalculatorOperation) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
            
        } else if self.currentNumber == .secondNumber {
            
            if let previousOperation = self.operation, let firstNumber = self.firstNumber, let secondNumber = self.secondNumber {
                let result = self.getOperationResult(previousOperation, firstNumber, secondNumber)
                
                self.secondNumber = nil
                self.firstNumber = result
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                    // Else switch operation
                self.operation = operation
            }
        }
    }
    
    private func getOperationResult(_ operation: CalculatorOperation, _ firstNumber: Int, _ secondNumber: Int) -> Int {
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
        currentNumber = .firstNumber
        firstNumber = nil
        secondNumber = nil
        operation = nil
        previousResult = nil
        previousOperation = nil
    }
    
    private func didSelectEqualsButton() {
        if let operation = self.operation,
           let firstNumber = self.firstNumber,
           let secondNumber = self.secondNumber {
            let result = self.getOperationResult(operation, firstNumber, secondNumber)
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = result
            self.currentNumber = .firstNumber
        }
        else if let previousOperation = self.previousOperation,
                let firstNumber = self.firstNumber,
                let previousResult = self.previousResult {
            let result = self.getOperationResult(previousOperation, firstNumber, previousResult)
            self.firstNumber = result
        }
    }
    
    private func didSelectPlusMinus() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            
            number *= -1
            self.firstNumber = number
            self.previousResult = number
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            
            number *= -1
            self.secondNumber = number
            self.previousResult = number
        }
    }
    
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            
            number /= 100
            self.firstNumber = number
            self.previousResult = number
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            
            number /= 100
            self.secondNumber = number
            self.previousResult = number
        }
    }
}
