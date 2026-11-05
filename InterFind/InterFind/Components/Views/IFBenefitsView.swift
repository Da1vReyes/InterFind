//
//  IFBenefitsView.swift
//  InterFind
//
//  Created by Alex Diaz on 9/11/24.
//

import UIKit

class IFBenefitsView: UIStackView {

    var benefitsArray: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    init(benefits: String) {
        super.init(frame: .zero)
        commonInit()
        configure(benefits: benefits)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.axis = .horizontal
        self.alignment = .leading
        self.spacing = 10
        self.distribution = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(benefits: String, backgroundColor: UIColor = .white) {

        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        self.handleString(benefits: benefits)
        
        for benefit in benefitsArray where !benefit.isEmpty {
            let labelBenefit = IFPaddingLabel(backgroundColor: backgroundColor)
            labelBenefit.text = benefit
            
            self.addArrangedSubview(labelBenefit)
        }
        
        if !benefitsArray.isEmpty {
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(spacer)
        }
    }
    
    private func handleString(benefits: String) {
        
        let partes = benefits.split(separator: " ")
        self.benefitsArray = Array(partes.prefix(3)).map { String($0) }
        
        while benefitsArray.count < 3 {
            benefitsArray.append("")
        }
    }
}
