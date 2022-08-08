//
//  TitleView.swift
//  
//
//  Created by Timothy Obeisun on 7/12/22.
//

import UIKit

class TitleView: UIView {
    private let themeFont: UIFont
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = themeFont
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    init(themeFont: UIFont ) {
        self.themeFont = themeFont
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
}

private extension TitleView {
    
    
    func layout() {
        setupTitlelabel()
    }
    
    func setupTitlelabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.bottom.equalTo(snp.bottom).offset(-36)
            make.leading.equalTo(snp.leading).offset(36)
            make.trailing.equalTo(snp.trailing).offset(-36)
        }
    }
}
