//
//  IFTabBarViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import UIKit

class IFTabBarController: UITabBarController {
    
    var homeViewController: IFHomeViewController
    
    init(homeViewController: IFHomeViewController) {
        self.homeViewController = homeViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
        createTabBar()
    }
    func createTabBar() {
        UITabBar.appearance().tintColor = .accent
        
        viewControllers = [createHomeNavigationController(),
                           createProfileNavigationController(),
                           createFavoriteListNavigationController()
        ]
    }
    
    
    private func createHomeNavigationController() -> UINavigationController {
        let homeController = HomeController(adsImageData: AdsData.bigTechPrograms)
        
        // pensar en poner aqui in DispatchQueue.main.async { }
        DispatchQueue.main.async {
            Task {
                await homeController.initialize()
            }
        }
        
        
        homeViewController.controller = homeController
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        return UINavigationController(rootViewController: homeViewController)
    }
    
    private func createProfileNavigationController() -> UINavigationController {
        let profileViewController = IFProfileViewController()
        let profileIcon = UIImage(systemName: "person")
        profileIcon?.withTintColor(.main)
        profileViewController.tabBarItem = UITabBarItem(title: "Perfil", image: profileIcon, tag: 1)
        return UINavigationController(rootViewController: profileViewController)
    }
    
    private func createFavoriteListNavigationController() -> UINavigationController {
        let homeController = HomeController(adsImageData: AdsData.bigTechPrograms)
        
        DispatchQueue.main.async {
            Task {
                await homeController.initialize()
            }
        }
        
        let favoriteViewController = IFFavoriteViewController(controller: homeController)
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "bookmark"), tag: 2)
        return UINavigationController(rootViewController: favoriteViewController)
    }
}
