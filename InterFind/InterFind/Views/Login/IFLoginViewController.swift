//
//  IFLoginViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 4/11/24.
//

import UIKit

class IFLoginViewController: UIViewController {

    // MARK: Components
    let titleLabel = IFTitleLabel(text: "Bienvenido", font: .systemFont(ofSize: 32, weight: .bold))
    let subtitleLabel = IFBodyLabel(text: "Inicia sesión para descubrir muchas oportunidades de pasantía adecuadas a tu carrera y habilidades")
    let emailTextField = IFTextFieldView(labelText: "Email", isSecure: false, placeholder: "tu@correo.com", keyboard: .emailAddress)
    let passwordTextField = IFTextFieldView(labelText: "Contraseña", isSecure: true, placeholder: "Password")
    let forgotPasswordButton = IFPlainButton(title: "¿Olvidaste la contraseña?", color: .subtitle, font: UIFont.systemFont(ofSize: 14))
    let loginButton = IFRoundedButton(text: "Iniciar Sesión")
    let signUpLabel = IFBodyLabel(text: "¿No tienes una cuenta aún?")
    let signUpButton = IFPlainButton(title: "Registrarse", color: .accent)
    let signUpView = UIView()
    let demoButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Entrar como \(Constants.DemoAccount.name) (demo)"
        config.image = UIImage(systemName: "person.crop.circle.badge.checkmark")
        config.imagePadding = 8
        config.baseForegroundColor = .main
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let controller = LoginController()
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createDismissKeyboardTapGesture()
        setupUI()
    }
    
    func setupUI() {
        configureNavigationController()
        setupConstraints()
        configureButtons()
    }
    // MARK: NavigationController
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
        forgotPasswordButton.titleLabel?.textAlignment = .right
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, subtitleLabel, emailTextField, passwordTextField, forgotPasswordButton, loginButton, signUpView, signUpButton, demoButton].forEach { item in
            view.addSubview(item)
        }
        [signUpLabel].forEach { item in
            signUpView.addSubview(item)
        }
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding * 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 75),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 75),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 180),
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: padding * 3),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: padding / 1.5),
            signUpView.widthAnchor.constraint(equalToConstant: 270),
            signUpView.heightAnchor.constraint(equalToConstant: 20),
            signUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpLabel.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor),
            signUpLabel.widthAnchor.constraint(equalToConstant: 180),
            signUpLabel.heightAnchor.constraint(equalToConstant: 20),
            
            signUpButton.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: signUpLabel.trailingAnchor),
            signUpButton.topAnchor.constraint(equalTo: signUpView.topAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: signUpView.bottomAnchor),

            demoButton.topAnchor.constraint(equalTo: signUpView.bottomAnchor, constant: padding * 1.5),
            demoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            demoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            demoButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    // MARK: Button Func
    
    func configureButtons() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButttonTapped), for: .touchUpInside)
        demoButton.addTarget(self, action: #selector(demoTapped), for: .touchUpInside)
    }

    @objc func demoTapped() {
        performLogin(email: Constants.DemoAccount.email, password: Constants.DemoAccount.password)
    }
    
    // MARK: LOGIN
    @objc func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            presentIFAlertOnMainThread(
                title: LoginError.emailEmpty.errorDescription ?? "Algo salió mal",
                message: LoginError.emailEmpty.recoverySuggestion ?? "Revisa tu email",
                buttonTitle: "OK"
            )
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

        performLogin(email: email, password: password)
    }

    private func performLogin(email: String, password: String) {
        Task {
            self.showLoadingView()
            // verificar que el login esta bien
            let loginSuccess = await controller.login(email: email, password: password)
            if !loginSuccess {
                presentIFAlertOnMainThread(
                    title: LoginError.invalidCredentials.errorDescription ?? "Algo salió mal",
                    message: LoginError.invalidCredentials.recoverySuggestion ?? "Verifica tus credenciales e inténtalo de nuevo.",
                    buttonTitle: "OK"
                )
                self.dismissLoadingView()
                return
            }
            // revisar que el usuario que envie a guardar en el LoginController se pueda recuperar desde aqui
            guard let _ = LoginController.getUser() else {
                presentIFAlertOnMainThread(
                    title: "Usuario no encontrado",
                    message: "Intente el login de nuevo",
                    buttonTitle: "OK"
                )
                self.dismissLoadingView()
                return
            }
            
            self.dismissLoadingView()
            
            navigateToHome()
        }
    }

    private func navigateToHome() {
        AppRouter.showHome()
    }
    
    @objc func signUpButttonTapped() {
        navigationController?.pushViewController(IFSignUpViewController(controller: controller), animated: true)
    }
}
