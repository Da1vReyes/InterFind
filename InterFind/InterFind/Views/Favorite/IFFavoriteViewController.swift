//
//  IFFavoriteViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import UIKit

class IFFavoriteViewController: UIViewController {
    
    var isModalOptionShowing: Bool = false
    
    let containerEmptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerCollectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyStatePadding: CGFloat = 60
    
    let homeController: HomeController
    
    init(controller: HomeController) {
        self.homeController = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeController.getFavoriteInternships()
        setupUI()
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        configureNavigationController()
        
        homeController.favoriteInternships.isEmpty ? setupEmptyState() : setupCollectionView()
    }
    
    func setupCollectionView() {
        
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        let favoriteTitleLabel: IFTitleLabel = IFTitleLabel(text: "Favoritos", font: UIFont.systemFont(ofSize: 26, weight: .bold))
        
        view.addSubview(favoriteTitleLabel)
        view.addSubview(containerCollectionView)
        
        let collectionView = IFFavoriteCollectionViewController(controller: homeController)
        collectionView.delegate = self
        
        addChildViewController(childVC: collectionView, to: containerCollectionView)
        
        NSLayoutConstraint.activate([
            favoriteTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            favoriteTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoriteTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            containerCollectionView.topAnchor.constraint(equalTo: favoriteTitleLabel.bottomAnchor, constant: 20),
            containerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupEmptyState() {
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        view.addSubview(containerEmptyView)
        let emptyStateFavorite = IFFavoriteEmptyState()
        emptyStateFavorite.delegate = self
        addChildViewController(childVC: emptyStateFavorite, to: containerEmptyView)
        
        NSLayoutConstraint.activate([
            containerEmptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: emptyStatePadding * 3),
            containerEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: emptyStatePadding),
            containerEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -emptyStatePadding),
            containerEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: emptyStatePadding * -3)
        ])
    }
    
    func presentModalOptions() {
        let modalVC = IFModalViewController()
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        modalVC.delegate = self
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.custom { context in
                return context.maximumDetentValue * 0.20
            }]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(modalVC, animated: true)
    }
    
}

extension IFFavoriteViewController: IFFavoriteEmptyStateDelegate {
    func favoriteEmptyStateSearchJobButton() {
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 0
        }
    }
}

extension IFFavoriteViewController: IFFavoriteCollectionViewControllerDelegate {
    func favoriteOptionButtonTapped() {
        self.isModalOptionShowing = true
        
        presentModalOptions()   
    }
}
extension IFFavoriteViewController: IFModalDelegate {
    func didTapApply() {
        self.presentIFAlertOnMainThread(title: "Ha aplicado con éxito", message: "Hemos enviado su CV a la empresa", buttonTitle: "OK")
    }
    
    func didTapShare() {
        print("shared")
    }
    
    func didTapDelete() {
        #warning("hacer esto")
        print("deleted")
    }
    
}
