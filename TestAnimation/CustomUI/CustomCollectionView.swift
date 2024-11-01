//
//  CustomCollectionView.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

class CustomCollectionView: UIView {
    
    // MARK: - Properties
    
    private let collectionView: UICollectionView
    private let images = [UIImage(named: Constant.imageOne), UIImage(named: Constant.imageTwo), UIImage(named: Constant.imageThree), UIImage(named: Constant.imageFour)]
    
    // MARK: - Initialization
    
    init(cellHeights: [CGFloat], frame: CGRect) {
        let layout = CustomLayout(cellHeights: cellHeights, cellPadding: 6)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ExtensionSetupUI

private extension CustomCollectionView {
    func setupUI() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: Constant.identifire)
        
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension CustomCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.identifire, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CustomCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
}
