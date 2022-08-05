//  TransitionView.swift
//  Created by Timothy Obeisun on 7/11/22.

import UIKit

class TransitionView: UIView {
    
    private var slides: [Slide]
    private var viewTintColor: UIColor?
    private var timer: DispatchSourceTimer?
    private var index: Int = -1
    
    var slideIndex: Int {
        return index
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var barView: [AnimatedBarView] = {
        var barView: [AnimatedBarView] = []
        slides.forEach { _ in
            barView.append(AnimatedBarView(barColor: viewTintColor))
        }
        return barView
    }()
    
    private lazy var titleView: TitleView = {
        let titleView = TitleView()
        return titleView
    }()
    
    private lazy var barStackView: UIStackView = {
        let barStackView = UIStackView(arrangedSubviews: barView)
        barStackView.axis = .horizontal
        barStackView.spacing = 8
        barStackView.distribution = .fillEqually
        return barStackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView,
                                                       titleView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    init(slides: [Slide], viewTintColor: UIColor?) {
        self.slides = slides
        self.viewTintColor = viewTintColor
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(){
        buildTimerIfNeeded()
        timer?.resume()
    }
    func stop(){
        timer?.cancel()
        timer = nil
    }
    
    private func buildTimerIfNeeded() {
        guard timer == nil else {
            return
        }
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(),
                        repeating: .seconds(2),
                        leeway: .seconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.showNext()
            }
        })
    }
    
    private func showNext() {
        let nextImage: UIImage
        let nextTitle: String
        let nextBarView: AnimatedBarView
        
        if slides.indices.contains(index + 1) {
            nextImage = slides[index + 1].image ?? UIImage()
            nextTitle = slides[index + 1].title
            nextBarView = barView[index + 1]
            index += 1
        } else {
            index = 0
            nextImage = slides[index].image ?? UIImage()
            nextTitle = slides[index].title
            nextBarView = barView[index]
            barView.forEach { $0.reset() }
        }
        
        UIView.transition(with: imageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = nextImage
        }, completion: nil)
        self.titleView.setTitle(text: nextTitle)
        nextBarView.startAnimating()
    }
    
    func handleTap(direction: Direction) {
        switch direction {
        case .left:
            barView[index].reset()
            if slides.indices.contains(index + 1) {
                let minus = index - 1
                if minus < 0 {
                    barView[0].reset()
                } else {
                    barView[minus].reset()
                }
            }
            index -= 2
        case .right:
            barView[index].complete()
        }
        timer?.cancel()
        timer = nil
        start()
    }
}

private extension TransitionView {
    func layout() {
        setupStackView()
        setupBarStackView()
        setupImageView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setupBarStackView() {
        addSubview(barStackView)
        barStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.top.equalTo(snp.topMargin)
            make.height.equalTo(4)
        }
    }
    
    func setupImageView() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.8)
        }
    }
}

