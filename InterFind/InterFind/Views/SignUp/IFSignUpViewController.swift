//
//  IFSignUpViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 17/11/24.
//

import UIKit

class IFSignUpViewController: UIViewController {
    
    // MARK: Components
    let titleLabel = IFTitleLabel(text: "Crea una Cuenta")
    let subtitleLabel = IFBodyLabel(text:  "Crea tu cuenta y accede a miles de oportunidades laborales ajustadas a tus habilidades y aspiraciones.")
    let nameTextField = IFTextFieldView(labelText: "Nombre completo", isSecure: false, placeholder: "Tu nombre")
    let emailTextField = IFTextFieldView(labelText: "Email", isSecure: false, placeholder: "tu@correo.com")
    let passwordTextField = IFTextFieldView(labelText: "Contraseña", isSecure: true, placeholder: "Password")
    let signUpButton = IFRoundedButton(text: "Registrarse")
    let loginLabel = IFBodyLabel(text: "¿Ya tienes una cuenta?")
    let loginButton = IFPlainButton(title: "Inciar Sesión", color: .accent)
    let loginView = UIView()
    
    let controller: LoginController
    
    let padding: CGFloat = 20.0
    
    init(controller: LoginController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error initializing view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        createDismissKeyboardTapGesture()
    }
    
    func setupUI() {
        configureNavigationController()
        setupConstraints()
        configureButtons()
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    // desactivar el teclado al hacer click a la pantalla
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func setupConstraints() {
        
        emailTextField.textField.returnKeyType = .next
        passwordTextField.textField.returnKeyType = .done
        loginView.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 3
        
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        loginLabel.textAlignment = .right
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        loginButton.titleLabel?.textAlignment = .left
        
        [titleLabel, subtitleLabel, emailTextField, nameTextField, passwordTextField, loginView, signUpButton, loginButton].forEach { item in view.addSubview(item) }
        
        loginView.addSubview(loginLabel)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding * 2),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 75),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 75),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding * 3),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: padding / 1.5),
            loginView.widthAnchor.constraint(equalToConstant: 250),
            loginView.heightAnchor.constraint(equalToConstant: 20),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            loginLabel.widthAnchor.constraint(equalToConstant: 150),
            loginLabel.heightAnchor.constraint(equalToConstant: 20),
            
            loginButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            loginButton.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: loginView.topAnchor),
            loginButton.bottomAnchor.constraint(equalTo: loginView.bottomAnchor)
            
        ])
    }
    
    func navigateToHome() {
        AppRouter.showHome()
    }
    // MARK: Buttons
    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func signUpButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            presentIFAlertOnMainThread(title: LoginError.nameEmpty.errorDescription ?? "Algo salió mal",
                                       message: LoginError.nameEmpty.recoverySuggestion ?? "Revisa tu nombre",
                                       buttonTitle: "OK")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            presentIFAlertOnMainThread(title: LoginError.emailEmpty.errorDescription ?? "Algo salió mal",
                                       message: LoginError.emailEmpty.recoverySuggestion ?? "Revisa tu email",
                                       buttonTitle: "OK")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentIFAlertOnMainThread(
                title: LoginError.passwordEmpty.errorDescription ?? "Algo salió mal",
                message: LoginError.passwordEmpty.recoverySuggestion ?? "Revisa tu contraseña",
                buttonTitle: "OK"
            )
            return
        }
        
        Task {
            self.showLoadingView()
            
            let (_, error) = await controller.signUp(name: name, email: email, password: password)
            if let error = error as? LocalStoreError {
                presentIFAlertOnMainThread(title: "No se pudo registrar", message: error.errorDescription ?? "Hubo un problema en el registro", buttonTitle: "OK")
                self.dismissLoadingView()
                return
            }
            
            self.dismissLoadingView()
            
            navigateToHome()
            return
        }
    }
    
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
