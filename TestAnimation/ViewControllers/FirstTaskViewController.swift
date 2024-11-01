//
//  ViewController.swift
//  TestAnimation
//
//  Created by Кизим Илья on 31.10.2024.
//

import UIKit

final class FirstTaskViewController: UIViewController, GiftTimerViewDelegate {

    // MARK: - Properties
    
    private lazy var giftTimerViews: GiftTimerView = {
        let view =  GiftTimerView(frame: .zero, circleSize: CGSize(width: 168, height: 168), totalTimeInSeconds: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        giftTimerViews.startTimer()
    }
}

// MARK: - extensionSetupUI

private extension FirstTaskViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        giftTimerViews.delegate = self
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(giftTimerViews)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            giftTimerViews.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftTimerViews.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            giftTimerViews.widthAnchor.constraint(equalToConstant: giftTimerViews.circleSize.width),
            giftTimerViews.heightAnchor.constraint(equalToConstant: giftTimerViews.circleSize.height)
        ])
    }
}
// MARK: - GiftTimerViewDelegate

extension FirstTaskViewController {
    func didTapGiftTimerView(_ giftTimerView: GiftTimerView) {
        print("GiftTimerView tapped with size: \(giftTimerView.circleSize)")
    }
}


