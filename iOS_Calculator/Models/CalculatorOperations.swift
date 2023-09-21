//
//  CalculatorOperations.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 19.09.2023.
//

import Foundation

enum CalculatorOperation {
    case divide
    case multiply
    case minus
    case plus
    
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiply:
            return "x"
        case .minus:
            return "-"
        case .plus:
            return "+"
        }
    }
}
