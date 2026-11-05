//
//  IFJobDetailViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 13/11/24.
//

import UIKit

class IFJobDetailViewController: UIViewController {
    
    var internship: InternshipModel
    
    // Header
    let backgroundImage = IFImageView()
    let companyImage = IFImageView()
    let headerContainerView = UIView()
    var jobTitleLabel: IFTitleLabel!
    var companyNameLabel: IFBodyLabel!
    var locationLabel: IFBodyLabel!
    var durationLabel: IFBodyLabel!
    let backButton = IFCircleButton(symbol: "arrow.left", color: .white, borderColor: .clear, backgroundColor: .clear)
    var basicInfoView: UIStackView!
    
    let index: Int
    let controller: HomeController
    
    // Content View
    let jobDescriptionTitleLabel: IFTitleLabel = IFTitleLabel(text: "About the role", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textAlignment: .left)
    var jobDescriptionLabel: IFBodyLabel!
    let requirementTitleLabel: IFTitleLabel = IFTitleLabel(text: "Requirements", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textAlignment: .left)
    var requirementLabel: IFBodyLabel!
    let benefitsTitleLabel: IFTitleLabel = IFTitleLabel(text: "Perks", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textAlignment: .left)
    var benefitsLabel: IFBodyLabel!
    
    // ScrollView
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // FOOTER
    let applyButton = IFRoundedButton(text: "Apply")
    let bookmarkButton = IFRoundedButton(text: "", color: UIColor.accent)
    let footerContainerView = UIView()
    
    let padding: CGFloat = 20
    
    init(internship: InternshipModel, index: Int, controller: HomeController) {
        self.internship = internship
        self.index = index
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        companyImage.layer.cornerRadius = companyImage.frame.height / 2
    }
    
    func setupUI() {
        setupViewController()
        setupScrollView()
        setupHeader()
        setupFooter()
        addLeftSwipeGesture()
        setupContentViewInfo()
        setBackButton()
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }
    // MARK: Scroll View
    func setupScrollView() {
        [scrollView, contentView].forEach { item in item.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        contentView.backgroundColor = .systemBackground
        
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
    
    // MARK: HEADER
    func setupHeader() {
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
       
        headerContainerView.backgroundColor = .secondarySystemBackground
        
        jobTitleLabel = IFTitleLabel(text: self.internship.title, font: UIFont.systemFont(ofSize: 22, weight: .bold))
        
        [backgroundImage, headerContainerView, companyImage].forEach { item in
            contentView.addSubview(item)
        }
        
        headerContainerView.addSubview(jobTitleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: 200),
            
            headerContainerView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -padding),
            headerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 115),
            
            companyImage.centerYAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: -padding),
            companyImage.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            companyImage.heightAnchor.constraint(equalToConstant: 85),
            companyImage.widthAnchor.constraint(equalToConstant: 85),
            
            jobTitleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: padding),
            jobTitleLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -padding),
            jobTitleLabel.topAnchor.constraint(equalTo: companyImage.bottomAnchor, constant: padding / 2),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 24),
            
        ])
        
        backgroundImage.setImageWithResources("background-placeholder")
        backgroundImage.contentMode = .scaleAspectFill
        companyImage.image = LocalStore.shared.image(for: internship.imageUrl, fallbackName: internship.companyName)
        companyImage.layer.cornerRadius = 43
        setBasicInfoView()
    }
    // MARK: Basic Info
    func setBasicInfoView() {
        
        locationLabel = IFBodyLabel(text: self.internship.location)
        companyNameLabel = IFBodyLabel(text: self.internship.companyName)
        durationLabel = IFBodyLabel(text: self.internship.duration)
        
        [locationLabel, companyNameLabel, durationLabel].forEach { item in
            item?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            item?.textColor = .main
            item?.minimumScaleFactor = 0.6
            item?.adjustsFontSizeToFitWidth = true
        }
        companyNameLabel.textAlignment = .right
        durationLabel.textAlignment = .left
        locationLabel.textAlignment = .center
        
        let separator = UILabel()
        separator.text = "•"
        separator.textAlignment = .center
        
        let separator1 = UILabel()
        separator1.text = "•"
        separator1.textAlignment = .center
    
        basicInfoView = UIStackView(arrangedSubviews: [companyNameLabel, separator1, locationLabel, separator, durationLabel])
        basicInfoView.axis = .horizontal
        basicInfoView.alignment = .center
        basicInfoView.distribution = .equalCentering
        basicInfoView.spacing = 0
        basicInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        headerContainerView.addSubview(basicInfoView)
        
        NSLayoutConstraint.activate([
            basicInfoView.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: padding / 2),
            basicInfoView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: padding),
            basicInfoView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -padding),
            basicInfoView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -padding)
        ])
    }
    // MARK: ContentView
    func setupContentViewInfo() {
        jobDescriptionLabel = IFBodyLabel(text: self.internship.description)
        jobDescriptionLabel.numberOfLines = 5
        jobDescriptionLabel.lineBreakMode = .byTruncatingTail
        
        requirementLabel = IFBodyLabel(text: self.internship.requirements)
        requirementLabel.numberOfLines = 10
        
        benefitsLabel = IFBodyLabel(text: self.internship.benefits)
        
        [jobDescriptionTitleLabel, jobDescriptionLabel, requirementLabel, requirementTitleLabel, benefitsLabel, benefitsTitleLabel].forEach { item in
            contentView.addSubview(item)
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            jobDescriptionTitleLabel.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: padding),
            jobDescriptionTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            jobDescriptionLabel.topAnchor.constraint(equalTo: jobDescriptionTitleLabel.bottomAnchor, constant: padding / 4),
            jobDescriptionLabel.heightAnchor.constraint(equalToConstant: 80),
            
            requirementTitleLabel.topAnchor.constraint(equalTo: jobDescriptionLabel.bottomAnchor, constant: 5),
            requirementTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            requirementLabel.topAnchor.constraint(equalTo: requirementTitleLabel.bottomAnchor, constant: padding / 4),
            requirementLabel.heightAnchor.constraint(equalToConstant: 80),
            
            benefitsTitleLabel.topAnchor.constraint(equalTo: requirementLabel.bottomAnchor, constant: 5),
            benefitsTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            benefitsLabel.topAnchor.constraint(equalTo: benefitsTitleLabel.bottomAnchor, constant: padding / 4),
            benefitsLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    // MARK: Footer
    func setupFooter() {
        footerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(footerContainerView)
        view.addSubview(applyButton)
        view.addSubview(bookmarkButton)
        
        applyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        setBookmarkButton()
        
        NSLayoutConstraint.activate([
            footerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainerView.heightAnchor.constraint(equalToConstant: 90),
            
            bookmarkButton.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: padding / 2),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 50),
            bookmarkButton.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor, constant: -padding - 10 ),
            
            applyButton.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 5),
            applyButton.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor, constant: -padding / 2),
            applyButton.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor, constant: -padding - 10 ),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Buttons
    @objc func backButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bookmarkButtonTapped() {
        self.internship.isFavorite.toggle()
        controller.internships[index].isFavorite.toggle()
        DispatchQueue.main.async {
            self.setBookmarkButton()
            self.controller.internships[self.index].isFavorite ? self.controller.saveInternshipAsFavorite(internship: self.internship) : self.controller.deleteInternshipFromFavorite(internship: self.internship)
        }
    }
    
    @objc func applyButtonTapped() {
        presentIFAlertOnMainThread(title: "CV sent", message: "Your CV was sent to \(internship.companyName)", buttonTitle: "OK")
    }
    
    func setBookmarkButton() {
        
        if let image = UIImage(systemName: internship.isFavorite ? "bookmark.fill" : "bookmark") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
            bookmarkButton.setImage(resizeImage, for: .normal)
        }
        bookmarkButton.tintColor = internship.isFavorite ? .white : .accent
        bookmarkButton.backgroundColor = internship.isFavorite ? .accent : .white
        bookmarkButton.layer.cornerRadius = 10
    }
    
    func setBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 60),
        ])
        
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        
        if let image = UIImage(systemName: "arrow.left") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
            backButton.setImage(resizeImage, for: .normal)
        }
    }
    
    // MARK: Gestures
    func addLeftSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonDidTapped))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
}
