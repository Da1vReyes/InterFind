//
//  IFEditButton.swift
//  InterFind
//
//  Created by Alex Diaz on 20/6/25.
//

import UIKit

class IFEditButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    init(icon: String, title: String){
        super.init(frame: .zero)
        setupStyle(icon: icon, title: title)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle(icon: String = "pencil", title: String = "Edit") {
        setTitle(title, for: .normal)
        setImage(UIImage(systemName: icon), for: .normal)
        
        // Colors
        tintColor = UIColor(named: "TitleColor")
        setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        backgroundColor = UIColor(named: "TitleColor")?.withAlphaComponent(0.1)
        
        // Layout
        semanticContentAttribute = .forceRightToLeft
        
        // Styling
        layer.cornerRadius = 8
        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
