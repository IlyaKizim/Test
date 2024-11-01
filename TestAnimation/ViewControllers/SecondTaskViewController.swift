//
//  SecondViewController.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

final class SecondTaskViewController: UIViewController {
        
    // MARK: - UI Elements
    
    private lazy var bannerView: BannerView = {
        let view = BannerView(cellHeights: [51, 23, 51, 23], frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


// MARK: - ExtensionSetupUI

private extension SecondTaskViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(bannerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bannerView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }
}
