//
//  IFHomeViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 4/11/24.
//

import UIKit

class IFHomeViewController: UIViewController {

    var controller: HomeController = HomeController(adsImageData: AdsData.bigTechPrograms)
    var helloLabel: IFTitleLabel!
    var subtitleLabel: IFTitleLabel!
    var profilePicture: IFImageView!
    let searchBar = IFTextField(placeholder: "Buscar")
    
    let maginifyingGlassIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let adsView = UIView()
    let urgentJobView = UIView()
    let urgentJobLabel = IFTitleLabel(text: "Urgentes", font: .systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    let recentJobView = UIView()
    let scrollToTopButton = IFCircleButton(symbol: "arrow.up.to.line", backgroundColor: UIColor.main.withAlphaComponent(0.6))
    let recentJobLabel = IFTitleLabel(text: "Listados Recientes", font: .systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        configureNavigationController()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        controller.matchFavoriteInternships()
        updateUI()
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func updateUI() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let savedImage = UIImage(data: imageData) {
            profilePicture.image = savedImage
        } else {
            profilePicture.setImageWithResources("chanchito-feliz")
        }
        let name = UserDefaultsManager.shared.get(forKey: "name")
        helloLabel.text = "Hola, \n\(name ?? "Amigo")"
    }
    // MARK: SetupUI
    func setupUI() {
        
        configureScrollView()
        configureTitle()
        configureSearchBar()
        configureAdsView()
        configureUrgentView()
        configureRecentView()
        
    }
    // MARK: ScrollView
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
    
    // MARK: ADD VIEWS
    func configureAdsView() {
        adsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adsView)
        addChildViewController(childVC: IFAdsViewController(controller: controller), to: adsView)
        adsView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            adsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: padding),
            adsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            adsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            adsView.heightAnchor.constraint(equalToConstant: 175)
        ])
    }
    // MARK: URGENT VIEW
    func configureUrgentView() {
        urgentJobView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(urgentJobView)
        contentView.addSubview(urgentJobLabel)
        
        addChildViewController(childVC: IFUrgentJobsViewController(controller: controller), to: urgentJobView)
        
        NSLayoutConstraint.activate([
            urgentJobLabel.topAnchor.constraint(equalTo: adsView.bottomAnchor, constant: padding),
            urgentJobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            urgentJobLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            urgentJobLabel.heightAnchor.constraint(equalToConstant: 20),
            
            urgentJobView.topAnchor.constraint(equalTo: urgentJobLabel.bottomAnchor, constant: padding),
            urgentJobView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            urgentJobView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            urgentJobView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    // MARK: RecentView
    func configureRecentView() {
        recentJobView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recentJobView)
        contentView.addSubview(recentJobLabel)
        contentView.addSubview(scrollToTopButton)
        scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
        let screenSize = UIScreen.main.bounds.size
        let screenHeight = screenSize.height
        addChildViewController(childVC: IFRecentJobsViewController(controller: controller), to: recentJobView)
        
        NSLayoutConstraint.activate([
            recentJobLabel.topAnchor.constraint(equalTo: urgentJobView.bottomAnchor, constant: padding),
            recentJobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            recentJobLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            recentJobLabel.heightAnchor.constraint(equalToConstant: 20),
            
            recentJobView.topAnchor.constraint(equalTo: recentJobLabel.bottomAnchor, constant: padding),
            recentJobView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            recentJobView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            recentJobView.heightAnchor.constraint(equalToConstant: screenHeight),
            recentJobView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            scrollToTopButton.bottomAnchor.constraint(equalTo: recentJobView.bottomAnchor, constant: 5),
            scrollToTopButton.trailingAnchor.constraint(equalTo: recentJobView.trailingAnchor, constant: 5),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 50),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Header
    func configureTitle() {
        helloLabel = IFTitleLabel(text: "Hola, \n\(controller.user.name)", font: UIFont.systemFont(ofSize: 22, weight: .bold), textAlignment: .left)
        subtitleLabel = IFTitleLabel(text: "Encuentra hoy el trabajo de tus sueños", font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
        contentView.addSubview(helloLabel)
        contentView.addSubview(subtitleLabel)
        
        profilePicture = IFImageView()
        
        contentView.addSubview(profilePicture)
        profilePicture.layer.cornerRadius = 30
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            helloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            helloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 3),
            helloLabel.heightAnchor.constraint(equalToConstant: 54),
            
            subtitleLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding * 3),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 48),
            
            profilePicture.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            profilePicture.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            profilePicture.heightAnchor.constraint(equalToConstant: 60),
            profilePicture.widthAnchor.constraint(equalToConstant: 60)
        ])
        addTapToProfilePicture()
    }
    
    // MARK: Search Bar
    func configureSearchBar() {
        let iconContainerView = UIView()
        iconContainerView.addSubview(maginifyingGlassIcon)
        
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        maginifyingGlassIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconContainerView.widthAnchor.constraint(equalToConstant: 35),
            iconContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            maginifyingGlassIcon.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            maginifyingGlassIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            maginifyingGlassIcon.widthAnchor.constraint(equalToConstant: 20),
            maginifyingGlassIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        searchBar.leftView = iconContainerView
        searchBar.leftViewMode = .always
        searchBar.backgroundColor = .systemBackground
        
        let tapGestureOnSearchBar = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
        searchBar.addGestureRecognizer(tapGestureOnSearchBar)
        
        contentView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    // SearchBarTap
    @objc func searchBarTapped() {
        // TODO: añadir aqui algo para ir a la vista de buscar
        let searchController = SearchController()
        let searchViewController = IFSearchViewController(searchController: searchController, homeController: controller)
        navigationController?.pushViewController(searchViewController, animated: true)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: TAP on Profile pic
    func addTapToProfilePicture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnProfilePicture))
        profilePicture.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapOnProfilePicture() {
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    
    // MARK: Scroll To Top Button
    @objc func scrollToTopButtonTapped() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -50), animated: true)
    }
}
