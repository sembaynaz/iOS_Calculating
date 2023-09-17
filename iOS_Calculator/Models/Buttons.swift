//
//  Buttons.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import Foundation
import UIKit

enum Buttons {
    case allClear
    case plusMinus
    case percentage
    case divide
    case multiply
    case minus
    case plus
    case equal
    case decimal
    case numbers(Int)
}

extension Buttons {
    var title: String {
        switch self {
        case .allClear:
            return "AC"
        case .plusMinus:
            return "+/-"
        case .percentage:
            return "%"
        case .divide:
            return "÷"
        case .multiply:
            return "x"
        case .minus:
            return "-"
        case .plus:
            return "+"
        case .equal:
            return "="
        case .numbers(let int):
            return int.description
        case .decimal:
            return ","
        }
    }
    
    var color: UIColor {
        switch self {
        case .allClear, .plusMinus, .percentage:
            return .lightGray
            
        case .divide, .multiply, .minus, .plus, .equal:
            return .systemOrange
            
        case .numbers, .decimal:
            return .darkGray
        }
    }
    
    var selectedColor: UIColor? {
        switch self {
        case .allClear, .plusMinus, .percentage, .equal, .numbers, .decimal:
            return nil
            
        case .divide, .multiply, .minus, .plus:
            return .white
        }
    }
}
