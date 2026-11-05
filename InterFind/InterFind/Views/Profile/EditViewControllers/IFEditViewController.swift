//
//  IFEditViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

class IFEditViewController: UIViewController {
    
    let backButton = IFCircleButton(symbol: "arrow.left", color: .white, borderColor: .clear, backgroundColor: .clear)
    var sectionTitle = IFTitleLabel(text: "Sobre mí", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textAlignment: .left)
    let saveButton = IFRoundedButton(text: "Guardar")
    
    let sectionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.cornerRadius = 8
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.05
        textView.layer.shadowOffset = CGSize(width: 0, height: 4)
        textView.layer.shadowRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        setBackButton()
        setupSaveButton()
        
    }
    // se debe implementar desde el controlar que lo invoca.
    func setupSectionTitle(_ title: String = "Sobre mí") {
        sectionTitle.text = title
        view.addSubview(sectionTitle)
        
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            sectionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sectionTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
    
    func setupTextField(placeholder: String) {
        placeholderLabel.text = placeholder
        
        view.addSubview(sectionTextView)
        view.addSubview(placeholderLabel)
        sectionTextView.delegate = self

        NSLayoutConstraint.activate([
            sectionTextView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 30),
            sectionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sectionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sectionTextView.heightAnchor.constraint(equalToConstant: 160),

            placeholderLabel.topAnchor.constraint(equalTo: sectionTextView.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: sectionTextView.leadingAnchor, constant: 16)
        ])
    }
    
    private func dismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 60),
        ])
        
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        
        if let image = UIImage(systemName: "arrow.left") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
            backButton.setImage(resizeImage, for: .normal)
            backButton.tintColor = .title
        }
    }
    // MARK: ACTIONS
    @objc func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonDidTapped() {
        print("Save button tapped on EditController")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension IFEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
