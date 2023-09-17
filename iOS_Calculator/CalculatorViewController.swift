//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Nazerke Sembay on 17.09.2023.
//

import UIKit

class CalculatorViewController: UIViewController {
    //MARK: Variables
    let viewModel: CalculatorViewControllerViewModel
    
    //MARK: UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: Lifecycle
    init(_ viewModel: CalculatorViewControllerViewModel = CalculatorViewControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    //MARK: UI Setup
}

