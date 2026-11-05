//
//  IFPlainButton.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//

import UIKit

class IFPlainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    init(title: String, color: UIColor, font: UIFont = .systemFont(ofSize: 16, weight: .medium)) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
