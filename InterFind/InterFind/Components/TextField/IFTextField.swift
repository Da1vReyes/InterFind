//
//  IFTextField.swift
//  InterFind
//
//  Created by Alex Diaz on 3/11/24.
//

import UIKit

class IFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(isSecure: Bool = false, placeholder: String, keyboard: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboard
        self.isSecureTextEntry = isSecure
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        textColor = .label
        font = .preferredFont(forTextStyle: .subheadline)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        borderStyle = .roundedRect
        autocorrectionType = .no
        autocapitalizationType = .none
        
    }
}
