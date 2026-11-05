//
//  IFNewJobViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

class IFCreateInternshipViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backButton = IFCircleButton(symbol: "arrow.left", color: .white, borderColor: .clear, backgroundColor: .clear)
    
    let titleLabel = IFTitleLabel(text: "Crear nueva práctica", font: UIFont.systemFont(ofSize: 26, weight: .bold), textAlignment: .left)
    
    let companyNameField = IFTextField(placeholder: "Nombre de la empresa")
    let titleField = IFTextField(placeholder: "Título del puesto")
    let descriptionField = IFTextField(placeholder: "Descripción")
    let durationField = IFTextField(placeholder: "Duración")
    let locationField = IFTextField(placeholder: "Ubicación")
    let requirementsField = IFTextField(placeholder: "Requisitos")
    let benefitsField = IFTextField(placeholder: "Beneficios")
    var selectedImage: UIImage?
    let imageView = UIImageView()
    
    
    let submitButton = IFRoundedButton(text: "Publicar práctica", color: .white, backgroundColor: .main)
    
    let padding: CGFloat = 20
    var controller: InternshipAdminController?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupLayout()
        setupActions()
        
        setBackButton()
        keyboardDismissGesture()
    }
    
    func keyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupLayout() {
        setupImagePickerUI()
        let fields = [
            companyNameField, titleField, descriptionField,
            durationField, locationField, requirementsField,
            benefitsField
        ]

        contentView.addSubview(titleLabel)
        fields.forEach { contentView.addSubview($0) }
        contentView.addSubview(submitButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        fields.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])

        var previousField: UIView = titleLabel
        for field in fields {
            NSLayoutConstraint.activate([
                field.topAnchor.constraint(equalTo: previousField.bottomAnchor, constant: 15),
                field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
                field.heightAnchor.constraint(equalToConstant: 50)
            ])
            previousField = field
        }

        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: previousField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
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
    
    private func setupImagePickerUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        contentView.addSubview(imageView)

        let imageButton = UIButton(type: .system)
        imageButton.setTitle("Seleccionar imagen", for: .normal)
        imageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            imageButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupActions() {
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height + 20
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height + 20
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func handleSubmit() {
        print("Boton ha sido presionado Submit")
        self.showLoadingView()
        guard let company = companyNameField.text, !company.isEmpty,
              let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let duration = durationField.text, !duration.isEmpty,
              let location = locationField.text, !location.isEmpty,
              let requirements = requirementsField.text, !requirements.isEmpty,
              let benefits = benefitsField.text, !benefits.isEmpty,
              let selectedImage = selectedImage else {
            self.presentIFAlertOnMainThread(title: "Campos vacíos", message: "Completa todos los campos antes de continuar.", buttonTitle: "OK")
            print("Tiene campos vacios")
            return
        }

        Task {
            do {
                // Guardar la imagen en el dispositivo
                let imageUrl = try LocalStore.shared.saveImage(selectedImage)
                let internship = InternshipModel(
                    id: UUID().uuidString,
                    companyName: company,
                    title: title,
                    description: description,
                    duration: duration,
                    location: location,
                    requirements: requirements,
                    benefits: benefits,
                    imageUrl: imageUrl
                )
                print("Llegamos aqui")
                print("\(internship)")
                let success = await self.controller?.createInternship(internship: internship)
                print(success ?? "no hay nada")
                self.dismissLoadingView()
                if success != nil {
                    self.presentIFAlertOnMainThread(title: "Éxito", message: "Práctica publicada exitosamente.", buttonTitle: "OK")
                    navigationController?.popViewController(animated: true)
                }

            } catch {
                self.presentIFAlertOnMainThread(title: "Error", message: "Ocurrió un problema al crear la práctica.", buttonTitle: "OK")
                self.dismissLoadingView()
            }
        }
        
    }
}

extension IFCreateInternshipViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
