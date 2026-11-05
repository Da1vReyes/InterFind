//
//  IFModalViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 27/11/24.
//

import UIKit

protocol IFModalDelegate: AnyObject {
    func didTapApply()
    func didTapShare()
    func didTapDelete()
}

class IFModalViewController: UIViewController {

    weak var delegate: IFModalDelegate?
    
    let applyButton = IFRoundedButton(text: "Apply", color: .white, backgroundColor: .main)
    let shareButton = IFRoundedButton(text: "Share", color: .main, backgroundColor: .white)
    let deleteButton = IFRoundedButton(text: "Delete", color: .main ,backgroundColor: .white)
    
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
        
        view.addSubview(applyButton)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            applyButton.heightAnchor.constraint(equalToConstant: 45),
            
            shareButton.topAnchor.constraint(equalTo: applyButton.bottomAnchor),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            shareButton.heightAnchor.constraint(equalToConstant: 45),
            
            deleteButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor),
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

        // Configure the buttons
        configureButton(applyButton, title: "Apply", systemImageName: "checkmark.circle", color: .white)
        configureButton(shareButton, title: "Share", systemImageName: "arrowshape.turn.up.forward", color: .main)
        configureButton(deleteButton, title: "Delete", systemImageName: "trash", color: .systemRed)
        
        deleteButton.titleLabel?.textColor = .systemRed
        
        applyButton.addTarget(self, action: #selector(isApplyButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(isShareButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(isDeleteButtonTapped), for: .touchUpInside)
    }
        
    @objc func isApplyButtonTapped() {
        dismiss(animated: true)
        delegate?.didTapApply()
    }
    
    @objc func isShareButtonTapped() {
        dismiss(animated: true)
        delegate?.didTapShare()
    }
    
    @objc func isDeleteButtonTapped() {
        dismiss(animated: true)
        delegate?.didTapDelete()
    }
}
