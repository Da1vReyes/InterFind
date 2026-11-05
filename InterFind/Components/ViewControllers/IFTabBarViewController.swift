//
//  IFTabBarViewController.swift
//  PasaFinder
//
//  Created by Alex Diaz on 9/11/24.
//  InterFind: redesigned tabs (Home, Search, Saved, Profile).
//

import UIKit

class IFTabBarController: UITabBarController {

    var homeViewController: IFHomeViewController

    private enum Tab: Int, CaseIterable {
        case home, search, saved, profile

        var title: String {
            switch self {
            case .home: return "Home"
            case .search: return "Search"
            case .saved: return "Saved"
            case .profile: return "Profile"
            }
        }

        var symbol: String {
            switch self {
            case .home: return "house"
            case .search: return "magnifyingglass"
            case .saved: return "bookmark"
            case .profile: return "person.crop.circle"
            }
        }

        var selectedSymbol: String {
            switch self {
            case .search: return "magnifyingglass"
            default: return symbol + ".fill"
            }
        }

        var item: UITabBarItem {
            let config = UIImage.SymbolConfiguration(weight: .semibold)
            let item = UITabBarItem(title: title,
                                    image: UIImage(systemName: symbol, withConfiguration: config),
                                    selectedImage: UIImage(systemName: selectedSymbol, withConfiguration: config))
            item.tag = rawValue
            return item
        }
    }

    init(homeViewController: IFHomeViewController) {
        self.homeViewController = homeViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        createTabs()
    }

    private func configureAppearance() {
        tabBar.tintColor = .accent
        tabBar.unselectedItemTintColor = .subtitle

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        let titleFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
        [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance].forEach {
            $0.normal.titleTextAttributes = [.font: titleFont, .foregroundColor: UIColor.subtitle]
            $0.selected.titleTextAttributes = [.font: titleFont, .foregroundColor: UIColor.accent]
            $0.normal.iconColor = .subtitle
            $0.selected.iconColor = .accent
        }
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func createTabs() {
        // Home and Search share the same data.
        let homeController = HomeController(adsImageData: AdsData.bigTechPrograms)
        Task { await homeController.initialize() }

        homeViewController.controller = homeController
        homeViewController.tabBarItem = Tab.home.item

        let searchViewController = IFSearchViewController(searchController: SearchController(), homeController: homeController)
        searchViewController.tabBarItem = Tab.search.item

        let favoritesController = HomeController(adsImageData: AdsData.bigTechPrograms)
        Task { await favoritesController.initialize() }
        let favoriteViewController = IFFavoriteViewController(controller: favoritesController)
        favoriteViewController.tabBarItem = Tab.saved.item

        let profileViewController = IFProfileViewController()
        profileViewController.tabBarItem = Tab.profile.item

        viewControllers = [homeViewController, searchViewController, favoriteViewController, profileViewController]
            .map { UINavigationController(rootViewController: $0) }
    }
}
