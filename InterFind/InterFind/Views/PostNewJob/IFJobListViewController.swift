//
//  IFJobListViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

class IFAdminJobListViewController: UIViewController {
    
    var isModalOptionShowing: Bool = false
    
    let containerCollectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let adminController: InternshipAdminController
    
    init(controller: InternshipAdminController) {
        self.adminController = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            Task {
                await self.adminController.getInterships()
            }
            self.setupUI()
        }
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        configureNavigationController()
        setupNavigationButtons()
        setupCollectionView()
    }
    
    func setupNavigationButtons() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .accent
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupCollectionView() {
        
        let titleLabel = IFTitleLabel(text: "Pasantías Disponibles", font: UIFont.systemFont(ofSize: 26, weight: .bold))
        
        view.addSubview(titleLabel)
        view.addSubview(containerCollectionView)
        
        let collectionView = IFAdminInternshipListViewController(controller: adminController)
        addChildViewController(childVC: collectionView, to: containerCollectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            containerCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            containerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // func setupEmptyState() {
    //     view.subviews.forEach { $0.removeFromSuperview() }
    //
    //     view.addSubview(containerEmptyView)
    //
    //     let emptyState = IFEmptyStateAdmin()
    //     addChildViewController(childVC: emptyState, to: containerEmptyView)
    //
    //     NSLayoutConstraint.activate([
    //         containerEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: emptyStatePadding * 3),
    //         containerEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: emptyStatePadding),
    //         containerEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -emptyStatePadding),
    //         containerEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -emptyStatePadding * 3)
    //     ])
    // }
    
    func presentModalOptions(for internship: Internship) {
        let modalVC = IFAdminModalViewController()
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        modalVC.delegate = self
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.custom { $0.maximumDetentValue * 0.25 }]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(modalVC, animated: true)
    }
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleAdd() {
        let controller = InternshipAdminController()
        let createVC = IFCreateInternshipViewController()
        createVC.controller = controller
        navigationController?.pushViewController(createVC, animated: true)
    }
}

// MARK: - IFModalDelegate

protocol IFAdminModalDelegate: AnyObject {
    func didTapEdit()
    func didTapDelete()
}

extension IFAdminJobListViewController: IFAdminModalDelegate {
    
    func didTapEdit() {
        
    }

    func didTapDelete() {
       
        print("Admin eliminó una práctica")
        self.presentIFAlertOnMainThread(title: "Práctica eliminada", message: "Se eliminó correctamente.", buttonTitle: "OK")
    }
}
