//
//  OnboardingViewController.swift
//  
//
//  Created by Timothy Obeisun on 7/11/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var nextButtonDidTap: ((Int) -> Void)?
    var getStartedButtonDidTap: (() -> Void)?
    
    private var slides: [Slide]
    private var tintColor: UIColor?
    
    private lazy var transitionView: TransitionView = {
        let transitionView = TransitionView(slides: slides, viewTintColor: tintColor)
        return transitionView
    }()
    
    private lazy var buttonContainerView: ButtonContainerView = {
        let buttonContainerView = ButtonContainerView(viewTintColor: tintColor)
        buttonContainerView.nextButtonDidTap = { [weak self] in
            guard let self = self else {return}
            self.nextButtonDidTap?(self.transitionView.slideIndex)
            self.transitionView.handleTap(direction: .right)
        }
        
        buttonContainerView.getStartedButtonDidTap = getStartedButtonDidTap
        return buttonContainerView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [transitionView,
                                                       buttonContainerView])
        stackView.axis = .vertical
        return stackView
    }()
    
    init(slides: [Slide], tintColor: UIColor?) {
        self.slides = slides
        self.tintColor = tintColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionView.start()
    }
    
    func stopAnimation() {
        
    }
}

private extension OnboardingViewController {
    func setupViews() {
        view.backgroundColor = .white
        setupStackView()
        setupButtonContainerView()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func setupButtonContainerView() {
        buttonContainerView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
        transitionView.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewDidTap(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: view)
        let midPoint = view.frame.size.width / 2
        if point.x > midPoint {
            transitionView.handleTap(direction: .right)
        } else {
            transitionView.handleTap(direction: .left)
        }
        debugPrint(point)
    }
}
