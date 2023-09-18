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
    let headerViewModel: ResulLabelViewModel
    
        //MARK: UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        return collectionView
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 72, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.backgroundColor = .black
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
        //MARK: Lifecycle
    init(viewModel: CalculatorViewControllerViewModel = CalculatorViewControllerViewModel(), headerViewModel: ResulLabelViewModel = ResulLabelViewModel()) {
        self.viewModel = viewModel
        self.headerViewModel = headerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
    }
    
    //MARK: UI Setup

    func setupUI() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(collectionView)
        
        labelView.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        let topInset = max(view.safeAreaInsets.top, UIApplication.shared.statusBarFrame.height)
        let bottomInset = max(view.safeAreaInsets.bottom, UIApplication.shared.statusBarFrame.height)
        
        NSLayoutConstraint.activate([
            labelView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 40 - view.frame.size.width - topInset - bottomInset),
            collectionView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10),
            resultLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
        ])
    }
}
        
extension CalculatorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.buttonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ButtonCollectionViewCell.identifier,
            for: indexPath) as! ButtonCollectionViewCell
        let calcButton = self.viewModel.buttonsArray[indexPath.row]
        cell.configure(button: calcButton)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calcButton = viewModel.buttonsArray[indexPath.row]
        
        let screenWidth = UIScreen.main.bounds.width
        
        switch calcButton {
        case let .numbers(int) where int == 0:
            let width = (screenWidth / 5) * 2 + (screenWidth / 6) / 3 + 10
            return CGSize(width: width, height: screenWidth / 5)
        default:
            let width = screenWidth / 5
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (view.frame.width/6)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = viewModel.buttonsArray[indexPath.row]
        print(buttonCell.title)
    }
}
