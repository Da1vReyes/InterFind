//
//  IFImageView.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//

import UIKit

class IFImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
    }
    
    func setImageWithSystemName(symbol: String, color: UIColor) {
        self.image = UIImage(systemName: symbol)
        self.tintColor = color
    }
    
    func setImageWithResources( _ resource: String) {
        self.image = UIImage(named: resource)
    }
    
    func setImageWithData( _ data: Data) {
        self.image = UIImage(data: data)
    }
}
