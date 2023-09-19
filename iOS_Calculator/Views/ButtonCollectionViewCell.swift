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
    var calculatorButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configure
    func configure (button: Buttons) {
        calculatorButton.text = button.title
        buttonView.backgroundColor = button.color
        switch button {
        case .allClear, .plusMinus, .percentage:
            calculatorButton.textColor = .black
        default:
            calculatorButton.textColor = .white
        }
        setupUI()
    }
    
    public func setOperationSelected() {
        calculatorButton.textColor = .systemOrange
        buttonView.backgroundColor = .white
    }
    // MARK: - UI Setup
    func setupUI() {
        addSubview(buttonView)
        buttonView.addSubview(calculatorButton)
        
        switch calculatorButton {
        case let calculatorButton where calculatorButton.text == "0":
            buttonView.layer.cornerRadius = 36
            NSLayoutConstraint.activate([
                calculatorButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
                calculatorButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: frame.height/3)
            ])
        default:
            buttonView.layer.cornerRadius = frame.size.width/2
            
            NSLayoutConstraint.activate([
                calculatorButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
                calculatorButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
           buttonView.centerXAnchor.constraint(equalTo: centerXAnchor),
           buttonView.centerYAnchor.constraint(equalTo: centerYAnchor),
           buttonView.heightAnchor.constraint(equalTo: heightAnchor),
           buttonView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.calculatorButton.removeFromSuperview()
    }
}
