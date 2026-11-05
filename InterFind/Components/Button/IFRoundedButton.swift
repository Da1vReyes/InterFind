//
//  IFRoundedButton.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//

import UIKit

class IFRoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    init(text: String, color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.main) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal) 
        self.backgroundColor = backgroundColor
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 8
    }
}
