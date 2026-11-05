//
//  IFCircleButton.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//

import UIKit

class IFCircleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    init(symbol: String, color: UIColor = UIColor.white, borderColor: UIColor = .main, backgroundColor: UIColor = UIColor.main) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: symbol), for: .normal)
        tintColor = color
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = backgroundColor
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
