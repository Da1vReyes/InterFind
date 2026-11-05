//
//  TitleLabel.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//

import UIKit

class IFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String, font: UIFont = UIFont.systemFont(ofSize: 32, weight: .heavy), textAlignment: NSTextAlignment = .center) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.text = text
        self.font = font
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor.title
        numberOfLines = 0
        adjustsFontSizeToFitWidth = true
    }
    
    
}
