//
//  IFProfileViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 14/11/24.
//

import UIKit

class IFProfileViewController: UIViewController {
    
    var profileImage: IFImageView!
    var titleName: IFTitleLabel!
    var locationLabel: IFBodyLabel!
    var editButton: IFEditButton!
    var aboutMeView: IFIconTextActionView!
    var createNewInternshipButton: IFCircleButton!
    var addDocumentButton: IFCircleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationController()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        updateUI()
    }
    
    func updateUI() {
        titleName.text = UserDefaultsManager.shared.get(forKey: "name")
        locationLabel.text = UserDefaultsManager.shared.get(forKey: "location")
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let savedImage = UIImage(data: imageData) {
            profileImage.image = savedImage
        } else {
            profileImage.image = LocalStore.avatar(for: UserDefaultsManager.shared.get(forKey: "name"))
        }
    }
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        self.view.backgroundColor = .secondarySystemBackground
        setupProfileImage()
        setupNamesAndEditButton()
        setupSectionsStack()
        setupAddDocumentButton()
        setupCreateInternshipButton()
        hideCreateNewInternshipButtonAndAddDocument()
        
    }
    private func hideCreateNewInternshipButtonAndAddDocument() {
        
        let email = UserDefaultsManager.shared.get(forKey: "email")
        if !LocalStore.isAdmin(email: email) {
            createNewInternshipButton.isHidden = true
        }// else {
           // addDocumentButton.isHidden = true
        //}
    }
    
    private func setupAddDocumentButton() {
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "doc.badge.plus", withConfiguration: config)

        addDocumentButton = IFCircleButton(symbol: "", color: .accent, borderColor: .clear, backgroundColor: .clear)
        addDocumentButton.setImage(image, for: .normal)
        addDocumentButton.addTarget(self, action: #selector(addDocumentButtonTapped), for: .touchUpInside)
        
        view.addSubview(addDocumentButton)
        NSLayoutConstraint.activate([
            addDocumentButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addDocumentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addDocumentButton.heightAnchor.constraint(equalToConstant: 50),
            addDocumentButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupProfileImage() {
        profileImage = IFImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 60
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.borderColor = UIColor.systemGray.cgColor
        profileImage.layer.borderWidth = 1

        view.addSubview(profileImage)

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            profileImage.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    private func setupCreateInternshipButton() {
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "storefront", withConfiguration: config)

        createNewInternshipButton = IFCircleButton(symbol: "", color: .accent, borderColor: .clear, backgroundColor: .clear)
        createNewInternshipButton.setImage(image, for: .normal)
        createNewInternshipButton.addTarget(self, action: #selector(createNewInternshipButtonTapped), for: .touchUpInside)
        
        view.addSubview(createNewInternshipButton)
        NSLayoutConstraint.activate([
            createNewInternshipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            createNewInternshipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createNewInternshipButton.heightAnchor.constraint(equalToConstant: 50),
            createNewInternshipButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func setupNamesAndEditButton() {
        let name: String? = UserDefaultsManager.shared.get(forKey: "name")

        titleName = IFTitleLabel(
            text: name ?? "",
            font: UIFont.systemFont(ofSize: 16, weight: .bold),
            textAlignment: .left
        )

        locationLabel = IFBodyLabel(
            text: ""
        )
        
        editButton = IFEditButton(icon: "pencil.line", title: "Editar perfil")
        
        // Agregar a la vista
        view.addSubview(titleName)
        view.addSubview(locationLabel)
        view.addSubview(editButton)
        editButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        // Constraints
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            titleName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            locationLabel.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            editButton.centerYAnchor.constraint(equalTo: titleName.bottomAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupSectionsStack() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Agregar los componentes
        let sections: [(icon: String, title: String, selector: Selector)] = [
            ("person.circle", "Sobre mí", #selector(addSobreMi)),
            ("briefcase", "Experiencia laboral", #selector(addExperiencia)),
            ("graduationcap", "Educación", #selector(addEducacion)),
            ("atom", "Habilidades", #selector(addHabilidades)),
            ("character.cursor.ibeam", "Idiomas", #selector(addIdiomas))
        ]

        for section in sections {
            let sectionView = IFIconTextActionView(iconName: section.icon, title: section.title)
            sectionView.setAction(target: self, action: section.selector)
            stackView.addArrangedSubview(sectionView)
        }

        // Añadir el stackView a la vista principal
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        var config = UIButton.Configuration.plain()
        config.title = "Cerrar sesión"
        config.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        config.imagePadding = 8
        config.baseForegroundColor = .systemRed
        let logoutButton = UIButton(configuration: config)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Acciones
    @objc private func editProfileButtonTapped() {
        let profileEditViewController = IFProfileEditViewController()
        navigationController?.pushViewController(profileEditViewController, animated: true)
    }
    
    @objc private func createNewInternshipButtonTapped() {
        print("Tapped Internship button")
        let controller = InternshipAdminController()
        DispatchQueue.main.async{
            Task {
                await controller.initialize()
            }
        }
        
        let adminVC = IFAdminJobListViewController(controller: controller)
        navigationController?.pushViewController(adminVC, animated: true)
    }
    
    @objc func addSobreMi() {
        let editController = IFEditViewController()
        editController.setupSectionTitle("Sobre mí")
        editController.setupTextField(placeholder: "Cuentanos un poco de ti...")
        navigationController?.pushViewController(editController, animated: true)
        print("Presentar EditController Sobre mí")
    }
    
    @objc func addDocumentButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }

    @objc func logoutTapped() {
        let alert = UIAlertController(title: "Cerrar sesión",
                                      message: "¿Quieres salir de tu cuenta?",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive) { _ in
            LoginController.logout()
            AppRouter.showLogin()
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    @objc func addExperiencia() {
        print("Agregar Experiencia laboral")
    }

    @objc func addEducacion() {
        print("Agregar Educación")
    }

    @objc func addHabilidades() {
        print("Agregar Habilidades")
    }

    @objc func addIdiomas() {
        print("Agregar Idiomas")
    }
}

extension IFProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        
        do {
            let pdfData = try Data(contentsOf: selectedURL)
            UserDefaults.standard.set(pdfData, forKey: "cvPDF")
            print("PDF guardado exitosamente en UserDefaults")
        } catch {
            print("Error al cargar el PDF:", error)
        }
    }
}
