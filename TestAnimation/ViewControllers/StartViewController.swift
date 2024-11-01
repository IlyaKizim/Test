//
//  StartViewController.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

final class StartViewController: UIViewController, Routing {
    
    var router: Router?
    
    // MARK: - UI Elements
    
    private lazy var task1Button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.taskOne, for: .normal)
        return button
    }()
    
    private lazy var task2Button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.taskTwo, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stakView = UIStackView()
        stakView.translatesAutoresizingMaskIntoConstraints = false
        stakView.axis = .vertical
        stakView.spacing = 20
        stakView.alignment = .center
        return stakView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - ExtensionSetupUI

private extension StartViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        addSubViews()
        setConstraints()
        task1Button.addTarget(self, action: #selector(didTapFirstButton), for: .touchUpInside)
        task2Button.addTarget(self, action: #selector(didTapSecondButton), for: .touchUpInside)
    }
    
    func addSubViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(task1Button)
        stackView.addArrangedSubview(task2Button)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - ExtensionButtonActions

private extension StartViewController {
    
    @objc func didTapFirstButton() {
        router?.routeTo(.first)
    }
    
    @objc func didTapSecondButton() {
        router?.routeTo(.second)
    }
}
