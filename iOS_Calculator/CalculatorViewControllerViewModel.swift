//
//  CalculatorViewControllerViewModel.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import UIKit

class CalculatorViewControllerViewModel {
    let buttonsArray: [Buttons] = [
        .allClear, .plusMinus, .percentage, .divide,
        .numbers(7), .numbers(8), .numbers(9), .multiply,
        .numbers(4), .numbers(5), .numbers(6), .minus,
        .numbers(1), .numbers(2), .numbers(3), .plus,
        .numbers(0), .decimal, .equal
    ]
}
