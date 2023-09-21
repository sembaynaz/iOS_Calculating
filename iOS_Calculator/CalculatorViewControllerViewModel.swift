//
//  CalculatorViewControllerViewModel.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import Foundation

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CalculatorViewControllerViewModel {
    
    var updateViews: (()->Void)?
    
    let calcButtonCells: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .numbers(7), .numbers(8), .numbers(9), .multiply,
        .numbers(4), .numbers(5), .numbers(6), .minus,
        .numbers(1), .numbers(2), .numbers(3), .plus,
        .numbers(0), .decimal, .equal
    ]
    
    // MARK: - Normal Variables
    private(set) lazy var calcHeaderLabel: String = self.firstNumber ?? "0"
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil { didSet { self.calcHeaderLabel = self.firstNumber?.description ?? "0" } }
    private(set) var secondNumber: String? = nil { didSet { self.calcHeaderLabel = self.secondNumber?.description ?? "0" } }
    
    private(set) var operation: CalculatorOperation? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    
    // MARK: - Memory Variables
    private(set) var prevNumber: String? = nil
    private(set) var prevOperation: CalculatorOperation? = nil
}

extension CalculatorViewControllerViewModel {
    
    public func didSelectButton(with calcButton: Buttons) {
        
        switch calcButton {
        case .allClear: self.didSelectAllClear()
        case .plusMinus: self.didSelectPlusOrMinus()
        case .percentage: self.didSelectPercentage()
        case .divide: self.didSelectOperation(with: .divide)
        case .multiply: self.didSelectOperation(with: .multiply)
        case .minus: self.didSelectOperation(with: .minus)
        case .plus: self.didSelectOperation(with: .plus)
        case .equal: self.didSelectEqualsButton()
        case .numbers(let number): self.didSelectNumber(with: number)
        case .decimal: self.didSelectDecimal()
        }
        self.updateViews?()
    }
    
    private func didSelectAllClear() {
        self.calcHeaderLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.prevNumber = nil
        self.prevOperation = nil
    }
}

// MARK: - Selecting Numbers
extension CalculatorViewControllerViewModel {
    
    private func didSelectNumber(with number: Int) {
        
        if self.currentNumber == .firstNumber {
            
            if var firstNumber = self.firstNumber {
                
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.prevNumber = firstNumber
                
            } else {
                self.firstNumber = number.description
                self.prevNumber = number.description
            }
            
        } else {
            if var secondNumber = self.secondNumber {
                
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.prevNumber = secondNumber
                
            } else {
                self.secondNumber = number.description
                self.prevNumber = number.description
            }
        }
    }
}

// MARK: - Equals & Arithmetic Operations
extension CalculatorViewControllerViewModel {
    
    private func didSelectEqualsButton() {
        
        if let operation = self.operation,
           let firstNumber = self.firstNumber?.toDouble,
           let secondNumber = self.secondNumber?.toDouble {
            let result = self.getOperationResult(operation, firstNumber, secondNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            
            self.secondNumber = nil
            self.prevOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .firstNumber
        }
        else if let prevOperation = self.prevOperation,
                let firstNumber = self.firstNumber?.toDouble,
                let prevNumber = self.prevNumber?.toDouble {
                let result = self.getOperationResult(prevOperation, firstNumber, prevNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            
            self.firstNumber = resultString
        }
    }
    
    
    private func didSelectOperation(with operation: CalculatorOperation) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
            
        } else if self.currentNumber == .secondNumber {
            
            if let prevOperation = self.operation,
               let firstNumber = self.firstNumber?.toDouble,
               let secondNumber = self.secondNumber?.toDouble {
                
                let result = self.getOperationResult(prevOperation, firstNumber, secondNumber)
                let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
                
                self.secondNumber = nil
                self.firstNumber = resultString
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                self.operation = operation
            }
        }
    }
    
        // MARK: - Helper
    private func getOperationResult(_ operation: CalculatorOperation, _ firstNumber: Double?, _ secondNumber: Double?) -> Double {
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }
        
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
}

    // MARK: - Action Buttons
extension CalculatorViewControllerViewModel {
    
    private func didSelectPlusOrMinus() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            
            self.firstNumber = number
            self.prevNumber = number
            
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber?.toDouble {
            
            number /= 100
            
            if number.isInteger {
                self.firstNumber = number.toInt?.description
            } else {
                self.firstNumber = number.description
                self.firstNumberIsDecimal = true
            }
            
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber?.toDouble {
            
            number /= 100
            
            if number.isInteger {
                self.secondNumber = number.toInt?.description
            } else {
                self.secondNumber = number.description
                self.secondNumberIsDecimal = true
            }
            
        }
    }
    
    private func didSelectDecimal() {
        
        if self.currentNumber == .firstNumber {
            
            self.firstNumberIsDecimal = true
            
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            } else if self.firstNumber == nil {
                self.firstNumber = "0."
            }
            
        } else if self.currentNumber == .secondNumber {
            
            self.secondNumberIsDecimal = true
            
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            } else if self.secondNumber == nil {
                self.secondNumber = "0."
            }
        }
    }
}

extension Double {
    var toInt: Int? {
        return Int(self)
    }
}

extension String {
    var toDouble: Double? {
        return Double(self)
    }
}

extension FloatingPoint {
    var isInteger: Bool { return rounded() == self }
}
