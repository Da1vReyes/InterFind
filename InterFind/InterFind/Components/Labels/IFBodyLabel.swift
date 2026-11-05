//
//  BodyLabel.swift
//  InterFind
//
//  Created by Alex Diaz on 1/11/24.
//

import UIKit

class IFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor.subtitle
        font = UIFont.systemFont(ofSize: 14)
        minimumScaleFactor = 0.6
        numberOfLines = 0
    }
}
