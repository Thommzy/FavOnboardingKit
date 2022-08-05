//
//  File.swift
//  
//
//  Created by Timothy Obeisun on 7/11/22.
//

import UIKit
import SnapKit

class ButtonContainerView: UIView {
    
    var nextButtonDidTap: (() -> Void)?
    var getStartedButtonDidTap: (() -> Void)?
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.layer.borderColor = viewTintColor?.cgColor
        nextButton.layer.borderWidth = 2
        nextButton.setTitleColor(viewTintColor, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self,
                             action: #selector(nextbuttonTapped),
                             for: .touchUpInside)
        return nextButton
    }()
    
    private lazy var getStartedButton: UIButton = {
        let getStartedButton = UIButton()
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.setTitleColor(.white, for: .normal)
        getStartedButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        getStartedButton.backgroundColor = viewTintColor
        getStartedButton.layer.cornerRadius = 12
        getStartedButton.layer.borderColor = viewTintColor?.cgColor
        getStartedButton.layer.shadowOpacity = 0.5
        getStartedButton.layer.shadowOffset = .init(width: 4, height: 4)
        getStartedButton.layer.shadowRadius = 12
        getStartedButton.addTarget(self,
                                   action: #selector(getStartedButtonTapped),
                                   for: .touchUpInside)
        return getStartedButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nextButton,
                                                       getStartedButton])
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    
    private let viewTintColor: UIColor?
    
    init(viewTintColor: UIColor?) {
        self.viewTintColor = viewTintColor
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ButtonContainerView {
    func layout() {
        setupStackView()
        setupNextButton()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 24,
                                                        left: 24,
                                                        bottom: 36,
                                                        right: 24))
        }
    }
    
    func setupNextButton() {
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(getStartedButton.snp.width).multipliedBy(0.5)
        }
    }
    
    @objc func nextbuttonTapped() {
        guard let nextButtonDidTap = nextButtonDidTap else { return }
        nextButtonDidTap()
    }
    
    @objc func getStartedButtonTapped() {
        guard let getStartedButtonDidTap = getStartedButtonDidTap else { return }
        getStartedButtonDidTap()
        
    }
}
