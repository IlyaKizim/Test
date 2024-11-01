//
//  GiftTimerView.swift
//  TestAnimation
//
//  Created by Кизим Илья on 31.10.2024.
//

import UIKit

// MARK: - GiftTimerViewDelegate Protocol

protocol GiftTimerViewDelegate: AnyObject {
    func didTapGiftTimerView(_ giftTimerView: GiftTimerView)
}

// MARK: - GiftTimerView

final class GiftTimerView: UIView {
    
    // MARK: - Properties
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.circleColor
        view.layer.cornerRadius = circleSize.width / 2
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var giftImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constant.imageGift))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        let fontSize = circleSize.width * 0.15
        label.textAlignment = .center
        if let font = UIFont(name: ConstantsFont.SFProDisplaySemibold, size: fontSize) {
            label.font = font
        } else {
            label.font = UIFont.systemFont(ofSize: Constants.Sizes.timerFontSize)
        }
        label.textColor = Constants.Colors.timerTextColor
        
        let text = Constant.textTimer
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: Constants.Colors.strokeColor,
            .foregroundColor: Constants.Colors.timerTextColor,
            .strokeWidth: -3.0
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalTimeInSeconds: Int
    var circleSize: CGSize
    private lazy var starImageViews: [UIImageView] = []
    private var shakeTimer: Timer?
    private var starTimer: Timer?
    private var timer: DispatchSourceTimer?
    weak var delegate: GiftTimerViewDelegate?
    
    // MARK: - Initialization
    
    init(frame: CGRect, circleSize: CGSize, totalTimeInSeconds: Int) {
        self.circleSize = circleSize
        self.totalTimeInSeconds = totalTimeInSeconds
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.circleSize = CGSize(width: Constants.Sizes.circleDiameter, height: Constants.Sizes.circleDiameter)
        self.totalTimeInSeconds = 5
        super.init(coder: coder)
        setupUI()
    }
    
    deinit {
        stopShakeTimer()
        stopStarTimer()
        stopTimer()
        print("deinited")
    }
}

// MARK: - ExtensionSetuoUI

private extension GiftTimerView {
    
    func setupUI() {
        addSubviews()
        setupConstraints()
        setupGesture()
    }
    
    func addSubviews() {
        addSubview(circleView)
        circleView.addSubview(stackView)
        stackView.addArrangedSubview(giftImageView)
        stackView.addArrangedSubview(timerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: circleSize.width),
            circleView.heightAnchor.constraint(equalToConstant: circleSize.height),
            
            stackView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.7),
            stackView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.7)
        ])
    }
}

// MARK: - ExtensionAnimations

private extension GiftTimerView {
    
    func addStarsAroundGift() {
        startShakeGift()
        startStarGift()
        let starImage = UIImage(named: Constant.imageStar)
        let radius: CGFloat = stackView.bounds.width / 2.1
        let rotationAngle: CGFloat = 15 * (.pi / 180)
        for i in 0..<5 {
            let angle = CGFloat(i) * (.pi / 4) - rotationAngle
            let xOffset = radius * cos(angle)
            let yOffset = -radius * sin(angle)
            
            let starImageView = UIImageView(image: starImage)
            starImageView.frame.size = CGSize(width: circleSize.width / 10, height: circleSize.width / 10)
            starImageView.center = CGPoint(x: stackView.center.x + xOffset, y: stackView.center.y + yOffset)
            starImageView.alpha = 0.0
            
            circleView.addSubview(starImageView)
            starImageViews.append(starImageView)
        }
    }
    
    func startShakingAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [-0.05, 0.05, -0.05, 0.05, -0.05, 0.0]
        animation.duration = 0.5
        animation.repeatCount = 1
        giftImageView.layer.add(animation, forKey: "shakeAnimation")
    }
    
    func startStarAnimation() {
        let baseDelay: CFTimeInterval = 0.15
        
        let order = [4, 0, 1, 3, 2]
        
        for (index, starIndex) in order.enumerated() {
            let delay = baseDelay * Double(index)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if self.starImageViews.indices.contains(starIndex) {
                    let star = self.starImageViews[starIndex]
                    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
                    fadeAnimation.fromValue = 0.0
                    fadeAnimation.toValue = 1.0
                    fadeAnimation.duration = 0.8
                    fadeAnimation.autoreverses = true
                    fadeAnimation.repeatCount = 1
                    star.layer.add(fadeAnimation, forKey: "fadeAnimation\(starIndex)")
                }
            }
        }
    }
    
    func animateRemoveTimerLabel() {
        UIView.animate(withDuration: 0.7, animations: {
            self.timerLabel.alpha = 0.0
        }, completion: { _ in
            self.timerLabel.removeFromSuperview()
            UIView.animate(withDuration: 0.3, animations: {
                self.stackView.layoutIfNeeded()
            })
            self.addStarsAroundGift()
        })
    }
}

// MARK: - ExtensionTimers

extension GiftTimerView {
    
    func startTimer() {
        timerLabel.text = formattedTime(totalTimeInSeconds)
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            if self.totalTimeInSeconds > 0 {
                self.totalTimeInSeconds -= 1
                DispatchQueue.main.async {
                    self.timerLabel.text = self.formattedTime(self.totalTimeInSeconds)
                }
            } else {
                self.timer?.cancel()
                self.timer = nil
                DispatchQueue.main.async {
                    self.addParticlesForDeleteCell()
                    self.animateRemoveTimerLabel()
                    self.isUserInteractionEnabled = true
                }
            }
        }
        timer?.resume()
    }
    
    private func startShakeGift() {
        stopShakeTimer()
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.startShakingAnimation()
        }
    }
    
    private func startStarGift() {
        stopStarTimer()
        starTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.startStarAnimation()
        }
    }
    
    private func stopShakeTimer() {
        shakeTimer?.invalidate()
        shakeTimer = nil
    }
    
    private func stopStarTimer() {
        starTimer?.invalidate()
        starTimer = nil
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

// MARK: - ExtensionTextFormatter

private extension GiftTimerView {
    func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - ExtensionGestureRecognizer

private extension GiftTimerView {
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = false
    }
    
    @objc private func handleTap() {
        delegate?.didTapGiftTimerView(self)
    }
}

// MARK: - ExtensionEmitterCell

extension GiftTimerView {
    func addParticlesForDeleteCell() {
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: timerLabel.bounds.midX, y: timerLabel.bounds.midY)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: timerLabel.bounds.width, height: timerLabel.bounds.height - 20)
        emitterLayer.emitterMode = .volume
        
        let cell = CAEmitterCell()
        cell.birthRate = Float(circleSize.width) * 2
        cell.lifetime = 0.8
        cell.velocity = -30
        cell.emissionLongitude = .pi / 4
        cell.emissionRange = .pi / 1
        cell.scale = 0.03
        cell.spin = .pi / 2
        
        cell.contents = UIImage(named: Constant.particles)?.cgImage
        cell.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        let cell2 = CAEmitterCell()
        cell2.birthRate = Float(circleSize.width) * 2
        cell2.lifetime = 0.8
        cell2.velocity = -30
        cell2.emissionLongitude = -.pi / 4
        cell2.emissionRange = .pi / 1
        cell2.scale = 0.03
        cell2.spin = .pi / 2
        cell2.contents = UIImage(named: Constant.particles)?.cgImage
        cell2.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        let cell1 = CAEmitterCell()
        cell1.birthRate = Float(circleSize.width) * 2
        cell1.lifetime = 1.0
        cell1.velocity = 30
        cell1.emissionLongitude = .pi / 4
        cell1.emissionRange = .pi / 1
        cell1.scale = 0.03
        cell1.spin = .pi / 2
        cell1.contents = UIImage(named: Constant.particles)?.cgImage
        cell1.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        let cell3 = CAEmitterCell()
        cell3.birthRate = Float(circleSize.width) * 2
        cell3.lifetime = 1.0
        cell3.velocity = 30
        cell3.emissionLongitude = .pi / 4
        cell3.emissionRange = .pi / 1
        cell3.scale = 0.03
        cell3.spin = .pi / 2
        cell3.contents = UIImage(named: Constant.particles)?.cgImage
        cell3.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        emitterLayer.emitterCells = [cell, cell2, cell1, cell3]
        timerLabel.layer.addSublayer(emitterLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            emitterLayer.birthRate = 0
        }
    }
}
