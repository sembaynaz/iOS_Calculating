//
//  ButtonCollectionViewCell.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    static let identifier = "ButtonCell"
    
    // MARK: - UI Components
    var calculatorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        return button
    }()
    
    // MARK: - Configure
    func configure (button: Buttons) {
        calculatorButton.setTitle(button.title, for: .normal)
        calculatorButton.backgroundColor = button.color
        switch button {
        case .allClear, .plusMinus, .percentage:
            calculatorButton.setTitleColor(.black, for: .normal)
        default:
            calculatorButton.setTitleColor(.white, for: .normal)
        }
        
        setupUI()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        addSubview(calculatorButton)
        switch calculatorButton {
        case let calculatorButton where calculatorButton.titleLabel?.text == "0":
            calculatorButton.layer.cornerRadius = 36
            calculatorButton.contentHorizontalAlignment = .left
            calculatorButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: frame.height/3, bottom: 0, right: 0)
        default:
            calculatorButton.contentHorizontalAlignment = .center
            calculatorButton.layer.cornerRadius = self.frame.size.width/2
        }
        
        NSLayoutConstraint.activate([
            self.calculatorButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.calculatorButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.calculatorButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.calculatorButton.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
}
