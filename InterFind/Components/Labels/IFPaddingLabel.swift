//
//  IFPaddingLabel.swift
//  InterFind
//
//  Created by Alex Diaz on 10/11/24.
//

import UIKit

class IFPaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8), backgroundColor: UIColor = .white) {
        self.padding = padding
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
    
    func configure() {
        self.font = .systemFont(ofSize: 12, weight: .medium)
        self.textColor = .subtitle
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}

