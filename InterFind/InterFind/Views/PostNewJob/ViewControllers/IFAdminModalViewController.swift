//
//  IFAdminModalViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit
class IFAdminModalViewController: UIViewController {

    weak var delegate: IFAdminModalDelegate?
    
    let editButton = IFRoundedButton(text: "Editar", color: .white, backgroundColor: .main)
    let deleteButton = IFRoundedButton(text: "Eliminar", color: .main ,backgroundColor: .white)
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        setButtons()
        configureConstraints()
    }
    
    func configureConstraints() {
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            editButton.heightAnchor.constraint(equalToConstant: 45),
            
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 10),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setButtons() {
        func configureButton(_ button: UIButton, title: String, systemImageName: String, color: UIColor) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: systemImageName)?.withTintColor(color, renderingMode: .alwaysOriginal)
            configuration.imagePadding = 8
            configuration.imagePlacement = .leading
            configuration.title = title
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            button.configuration = configuration
            button.contentHorizontalAlignment = .leading
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }

        configureButton(editButton, title: "Editar", systemImageName: "pencil", color: .white)
        configureButton(deleteButton, title: "Eliminar", systemImageName: "trash", color: .systemRed)
        
        deleteButton.titleLabel?.textColor = .systemRed
        
        editButton.addTarget(self, action: #selector(isEditButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(isDeleteButtonTapped), for: .touchUpInside)
    }

    @objc func isEditButtonTapped() {
        dismiss(animated: true)
        delegate?.didTapEdit()
    }
    
    @objc func isDeleteButtonTapped() {
        dismiss(animated: true)
        delegate?.didTapDelete()
    }
}
