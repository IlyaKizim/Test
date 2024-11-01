//
//  PhotoCell.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//
//
import UIKit

final class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ExtensionSetupUI

private extension PhotoCell {
    
    func setupUI () {
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
