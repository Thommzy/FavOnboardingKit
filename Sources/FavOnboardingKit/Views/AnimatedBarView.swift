//
//  AnimatedBarView.swift
//  
//
//  Created by Timothy Obeisun on 7/12/22.
//

import UIKit
import Combine

enum State {
    case clear
    case animating
    case filled
}

class AnimatedBarView: UIView {
    
    private let barColor: UIColor?
    @Published private var state: State = .clear
    private var subscribers = Set<AnyCancellable>()
    private var animator: UIViewPropertyAnimator!
    private lazy var backgroundBarView: UIView = {
        let backgroundBarView = UIView()
        backgroundBarView.backgroundColor = barColor?.withAlphaComponent(0.2)
        backgroundBarView.clipsToBounds = true
        return backgroundBarView
    }()
    
    private lazy var foregroundBarView: UIView = {
        let foregroundBarView = UIView()
        foregroundBarView.backgroundColor = barColor
        foregroundBarView.alpha = 0.0
        return foregroundBarView
    }()
    
    init(barColor: UIColor?) {
        self.barColor = barColor
        super.init(frame: .zero)
        setupAnimator()
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension AnimatedBarView {
    func layout() {
        setupBackgroundBarView()
        setupForegroundBarView()
    }
    
    func setupBackgroundBarView() {
        addSubview(backgroundBarView)
        backgroundBarView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setupForegroundBarView() {
        backgroundBarView.addSubview(foregroundBarView)
        foregroundBarView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundBarView)
        }
    }
}

private extension AnimatedBarView {
    func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 3.0,
                                          curve: .easeInOut,
                                          animations: {
            self.foregroundBarView.transform = .identity
        })
    }
    
    func observe() {
        $state.sink { [unowned self] state in
            switch state {
            case .clear:
                setupAnimator()
                foregroundBarView.alpha = 0.0
                animator.stopAnimation(false)
            case .animating:
                foregroundBarView.transform = .init(scaleX: 0, y: 1.0)
                foregroundBarView.transform = .init(translationX: -frame.size.width, y: 0)
                foregroundBarView.alpha = 1.0
                animator.startAnimation()
            case .filled:
                animator.stopAnimation(true)
                foregroundBarView.transform = .identity
            }
        }
        .store(in: &subscribers)
    }
}

extension AnimatedBarView {
    func startAnimating() {
        state = .animating
    }
    
    func reset() {
        state = .clear
    }
    
    func complete() {
        state = .filled
    }
}
