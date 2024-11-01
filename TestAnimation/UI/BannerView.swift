//
//  BannerView.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

final class BannerView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.title
        
        if let font = UIFont(name: ConstantsFont.SFProDisplaySemibold, size: 17) {
            label.font = font
        } else {
            label.font = UIFont.systemFont(ofSize: Constants.Sizes.timerFontSize)
        }
        label.textColor = Constants.Colors.timerTextColor
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.description
        
        if let font = UIFont(name: ConstantsFont.SFProDisplayRegular, size: 13) {
            label.font = font
        } else {
            label.font = UIFont.systemFont(ofSize: Constants.Sizes.timerFontSize)
        }
        label.textColor = Constants.Colors.timerTextColor
        label.numberOfLines = 0
        label.layer.opacity = 0.5
        return label
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let collectionView: CustomCollectionView
    
    private let rectangleLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: ConstantsColor.gradientPurple)?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: ConstantsColor.gradientPurple)?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: ConstantsColor.gradientPurple)?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: ConstantsColor.gradientPink)?.cgColor ?? UIColor.clear.cgColor
        ]
        layer.startPoint = .init(x: 0, y: 0)
        layer.endPoint = .init(x: 1, y: 0.2)
        layer.cornerRadius = 10
        return layer
    }()
    
    // MARK: - Initialization
    
    init(cellHeights: [CGFloat], frame: CGRect) {
        self.collectionView = CustomCollectionView(cellHeights: cellHeights, frame: .zero)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCyrcle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rectangleLayer.frame = conteinerView.bounds
    }
}

// MARK: - ExtensionSetupUI

private extension BannerView {
    func setupView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        conteinerView.layer.addSublayer(rectangleLayer)
        addSubview(conteinerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        conteinerView.addSubview(stackView)
        conteinerView.addSubview(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            conteinerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            conteinerView.topAnchor.constraint(equalTo: topAnchor),
            conteinerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 22),
            stackView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -22),
           
            collectionView.widthAnchor.constraint(equalToConstant: 98),
            collectionView.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 13),
            collectionView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -19),
            collectionView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -15)
        ])
    }
}
