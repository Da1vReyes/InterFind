//
//  IFProfileEditViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

class IFProfileEditViewController: UIViewController {
    
    let backButton = IFCircleButton(symbol: "arrow.left", color: .white, borderColor: .clear, backgroundColor: .clear)
    var profileImage: IFImageView!
    var editImageButton: IFCircleButton!
    let saveButton = IFRoundedButton(text: "Save")
    
    let nameTitle = IFTitleLabel(text: "Full name", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
    let nameTextField: IFTextField = IFTextField()
    let emailLabel = IFTitleLabel(text: "Email", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
    let emailTextField: IFTextField = IFTextField()
    let birthdateLabel = IFTitleLabel(text: "Date of birth", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
    let phoneLabel = IFTitleLabel(text: "Phone", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
    let phoneTextField = IFTextField()
    let locationLabel = IFTitleLabel(text: "Location", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textAlignment: .left)
    let locationTextField = IFTextField()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let birthdateField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.borderStyle = .roundedRect
        tf.tintColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()
        picker.locale = Locale(identifier: "es_ES")
        return picker
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        setupKeyboardNotifications()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        updateUI()
    }
    
    func updateUI() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let savedImage = UIImage(data: imageData) {
            profileImage.image = savedImage
        } else {
            profileImage.image = LocalStore.avatar(for: UserDefaultsManager.shared.get(forKey: "name"))
        }
        birthdateField.placeholder = UserDefaultsManager.shared.get(forKey: "birthdate")
        phoneTextField.text = UserDefaultsManager.shared.get(forKey: "phone")
        locationTextField.text = UserDefaultsManager.shared.get(forKey: "location")
    }
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        setupScrollView()
        setupProfileImage()
        setupEditImageButton()
        setBackButton()
        dismissKeyboardGesture()
        setupName()
        setupBirthdateField()
        setupEmail()
        setupPhone()
        setupLocation()
        setupSaveButton()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupProfileImage() {
        profileImage = IFImageView()
        profileImage.image = LocalStore.avatar(for: UserDefaultsManager.shared.get(forKey: "name"))
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 60
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.borderColor = UIColor.systemGray.cgColor
        profileImage.layer.borderWidth = 1

        contentView.addSubview(profileImage)
        
        // Dark overlay above the image
        let darkOverlay = UIView()
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false
        darkOverlay.isUserInteractionEnabled = false // so it doesn't block the button

        profileImage.addSubview(darkOverlay)

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            
            darkOverlay.topAnchor.constraint(equalTo: profileImage.topAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            darkOverlay.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor)
        ])
    }
    
    private func setupEditImageButton() {
        editImageButton = IFCircleButton(symbol: "square.and.arrow.up", color: .white, borderColor: .accent, backgroundColor: .clear)
        
        editImageButton.addTarget(self, action: #selector(editImageButtonTapped), for: .touchUpInside)
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(editImageButton)
        
        NSLayoutConstraint.activate([
            editImageButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            editImageButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            editImageButton.heightAnchor.constraint(equalToConstant: 40),
            editImageButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func setupSaveButton() {
        contentView.addSubview(saveButton)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupName() {
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.backgroundColor = .white
        
        contentView.addSubview(nameTitle)
        contentView.addSubview(nameTextField)
        
        nameTextField.backgroundColor = .white
        nameTextField.layer.cornerRadius = 8
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.textColor = .label
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.delegate = self
        let name = UserDefaultsManager.shared.get(forKey: "name")
        nameTextField.text = name
        
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            nameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTitle.heightAnchor.constraint(equalToConstant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupEmail() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.backgroundColor = .white
        emailTextField.isEnabled = false
        emailTextField.delegate = self
        emailTextField.backgroundColor = .systemGray3
        emailTextField.layer.cornerRadius = 8
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.textColor = .label
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        emailTextField.leftViewMode = .always
        
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        
        let email = UserDefaultsManager.shared.get(forKey: "email")
        emailTextField.text = email
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: birthdateField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBirthdateField() {
        birthdateLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdateField.translatesAutoresizingMaskIntoConstraints = false

        birthdateField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(didSelectDate))
        toolbar.setItems([doneButton], animated: true)
        
        birthdateField.inputAccessoryView = toolbar
        
        // Calendario
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = UIColor(named: "Accent") ?? .systemIndigo
        icon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon.contentMode = .scaleAspectFit
        birthdateField.rightView = icon
        birthdateField.rightViewMode = .always
        
        birthdateField.delegate = self
        
        contentView.addSubview(birthdateLabel)
        contentView.addSubview(birthdateField)

        NSLayoutConstraint.activate([
            birthdateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            birthdateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthdateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            birthdateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            birthdateField.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 10),
            birthdateField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthdateField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            birthdateField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupPhone() {
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        
        phoneTextField.keyboardType = .phonePad
        phoneTextField.backgroundColor = .white
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        phoneTextField.leftViewMode = .always
        phoneTextField.font = UIFont.systemFont(ofSize: 15)
        phoneTextField.delegate = self
        
        contentView.addSubview(phoneLabel)
        contentView.addSubview(phoneTextField)

        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupLocation() {
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationTextField.backgroundColor = .white
        locationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        locationTextField.leftViewMode = .always
        locationTextField.font = UIFont.systemFont(ofSize: 15)
        locationTextField.delegate = self
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationTextField)

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
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
    private func dismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: ACTIONS
    @objc func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func editImageButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera

        present(picker, animated: true)
    }
    @objc func saveButtonDidTapped() {
        print("Save button tapped on EditController")
        UserDefaultsManager.shared.save(birthdateField.text!, forKey: "birthdate")
        UserDefaultsManager.shared.save(nameTextField.text!, forKey: "name")
        UserDefaultsManager.shared.save(phoneTextField.text!, forKey: "phone")
        UserDefaultsManager.shared.save(locationTextField.text!, forKey: "location")
        
        print("Date to save: \(birthdateField.text ?? "Vacia")")
        navigationController?.popViewController(animated: true)
    }
    @objc private func didSelectDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateStyle = .long
        
        let formatted = formatter.string(from: datePicker.date)
        birthdateField.text = formatted
        birthdateField.resignFirstResponder()
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let bottomInset = keyboardFrame.height + 20
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

extension IFProfileEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField != birthdateField
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}

extension IFProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage {
            profileImage.image = editedImage
            // Persist in UserDefaults
            if let imageData = editedImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "profileImageData")
            }
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImage.image = originalImage
        }
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
