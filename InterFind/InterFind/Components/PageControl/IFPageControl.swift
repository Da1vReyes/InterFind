//
//  IFPageControl.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//
import UIKit

class IFPageControl: UIStackView {

    private var dots: [UIView] = []
    var selectedAt: Int = 0
    var elementAmount: Int!
    
    init(selectedAt: Int = 0, elementAmount: Int) {
        super.init(frame: .zero)
        self.elementAmount = elementAmount
        self.selectedAt = selectedAt
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 2
        translatesAutoresizingMaskIntoConstraints = false

        for i in 0..<elementAmount {
            let dot = UIView()
            dot.backgroundColor = i == selectedAt ? .main : .systemGray4
            dot.layer.cornerRadius = 5
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            addArrangedSubview(dot)
            dots.append(dot)
        }
    }

    func setSelectedPage(_ index: Int) {
        for (i, dot) in dots.enumerated() {
            dot.backgroundColor = i == index ? .main : .systemGray4
        }
    }
}
