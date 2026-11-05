//
//  IFTextFieldView.swift
//  InterFind
//
//  Created by Alex Diaz on 3/11/24.
//

import UIKit

class IFTextFieldView: UIView {

    var textField: IFTextField
    let label: IFTitleLabel
    
    init(labelText: String, isSecure: Bool, placeholder: String, keyboard: UIKeyboardType = .default) {
        self.label = IFTitleLabel(text: labelText, font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
        self.textField = IFTextField(isSecure: isSecure, placeholder: placeholder, keyboard: keyboard)
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        [textField, label].forEach { item in
            addSubview(item)
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            textField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
}

extension IFTextFieldView {
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
}
