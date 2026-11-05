//
//  StyledLabel.swift
//  InterFind
//
//  Created by Alex Diaz on 31/10/24.
//

import UIKit

class IFStyledLabel: UILabel {

    var firstText: String!
    var highlightedText: String!
    var lastText: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(firstText: String, highlightedText: String, lastText: String = "") {
        super.init(frame: .zero)
        self.firstText = firstText
        self.highlightedText = highlightedText
        self.lastText = lastText
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        // basic settings
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textAlignment = .left
        
        let attributedText = NSMutableAttributedString()
        
        let standardPartAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40, weight: .heavy),
            .foregroundColor: UIColor.label,
        ]
        
        attributedText.append(NSAttributedString(string: firstText, attributes: standardPartAttributes))
        
        let highlightedPartAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40, weight: .heavy),
            .foregroundColor: UIColor.accent,
            .underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
            .underlineColor: UIColor.accent
        ]
        attributedText.append(NSAttributedString(string: highlightedText, attributes: highlightedPartAttributes))
        
        attributedText.append(NSAttributedString(string: lastText, attributes: standardPartAttributes))
        
        self.attributedText = attributedText
    }
}
