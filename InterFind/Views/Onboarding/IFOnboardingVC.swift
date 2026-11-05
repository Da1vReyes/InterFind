//
//  IFOnboardingVC.swift
//  InterFind
//
//  Created by Alex Diaz on 3/11/24.
//

import UIKit

class IFOnboardingVC: UIViewController {
    
    let onboardingInfo: [OnboardingInfo] = [
        OnboardingInfo(firstTitle: "Find your ", highlightTitle: "Dream Internship", lastTitle: " Here!", description: "Explore internships picked for your interests and your field of study.", image: "onboarding-image-1"),
        OnboardingInfo(firstTitle: "Apply with a ", highlightTitle: "Single Tap", lastTitle: "", description: "Send your application in one tap and skip the busywork.", image: "onboarding-image-2"),
        OnboardingInfo(firstTitle: "Get ", highlightTitle: "Alerts", lastTitle: "\nfor New Openings", description: "Get alerts for new internships that fit you and never miss an opening.", image: "onboarding-image-2")
    ]
    
    let brandLabel = IFTitleLabel(text: "InterFind", font: UIFont.systemFont(ofSize: 18, weight: .bold), textAlignment: .left)
    let skipButton = IFPlainButton(title: "Skip", color: .subtitle)
    let onboardingImage = IFImageView()
    var titleLabel: IFStyledLabel!
    var subtitleLabel: IFBodyLabel!
    let nextButton = IFCircleButton(symbol: "arrow.right",color: .white, borderColor: .main)
    let backButton = IFCircleButton(symbol: "arrow.left", color: .secondaryLabel, borderColor: .systemGray4 ,backgroundColor: .systemGray6)
    var index = 0
    var pageControl: IFPageControl!
    
    let padding: CGFloat = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureNavigationController()
        setButton()
        setSwipeGesture()
    }
    
    func configureNavigationController() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        titleLabel = IFStyledLabel(firstText: onboardingInfo[index].firstTitle, highlightedText: onboardingInfo[index].highlightTitle, lastText: onboardingInfo[index].lastTitle)
        subtitleLabel = IFBodyLabel(text: onboardingInfo[index].description)
        pageControl = IFPageControl(selectedAt: index, elementAmount: onboardingInfo.count)
        onboardingImage.setImageWithResources(onboardingInfo[index].image)
        
        [brandLabel, skipButton, onboardingImage, titleLabel, subtitleLabel, nextButton, backButton, pageControl].forEach { item in view.addSubview(item) }
        setConstraints()
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    func updateUI() {
        titleLabel.firstText = onboardingInfo[index].firstTitle
        titleLabel.highlightedText = onboardingInfo[index].highlightTitle
        titleLabel.lastText = onboardingInfo[index].lastTitle
        titleLabel.configure()
        
        subtitleLabel.text = onboardingInfo[index].description
        onboardingImage.image = UIImage(named: onboardingInfo[index].image)
        
        pageControl.setSelectedPage(index)
    }
    // Transition animations.
    func animateUI(transitionDirection: CATransitionSubtype) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = transitionDirection
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        view.layer.add(transition, forKey: kCATransition)

        updateUI()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            brandLabel.heightAnchor.constraint(equalToConstant: 22),
            brandLabel.widthAnchor.constraint(equalToConstant: 97),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            skipButton.heightAnchor.constraint(equalToConstant: 22),
            skipButton.widthAnchor.constraint(equalToConstant: 50),
            
            onboardingImage.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: padding * 3),
            onboardingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            onboardingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            onboardingImage.heightAnchor.constraint(equalToConstant: 290),
            
            titleLabel.topAnchor.constraint(equalTo: onboardingImage.bottomAnchor, constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 160),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            backButton.heightAnchor.constraint(equalToConstant: padding * 3),
            backButton.widthAnchor.constraint(equalToConstant: padding * 3),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nextButton.heightAnchor.constraint(equalToConstant: padding * 3),
            nextButton.widthAnchor.constraint(equalToConstant: padding * 3),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding - 30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 95),
            pageControl.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    // Swipe gestures
    func setSwipeGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }

    func setButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        if index <= 0 { return } else {
            index -= 1
            DispatchQueue.main.async {
                self.animateUI(transitionDirection: .fromLeft)
            }
        }
    }
    
    @objc func nextButtonTapped() {
        if index >= onboardingInfo.count - 1 {
            
            navigateToLogin()
            return
        } else {
            index += 1
            DispatchQueue.main.async {
                self.animateUI(transitionDirection: .fromRight)
            }
        }
    }
    
    @objc func skipButtonTapped() {
        navigateToLogin()
    }
    
    func navigateToLogin() {
        UserDefaults.standard.set(true, forKey: Constants.hasSeenOnboardingKey)
        let loginVC = IFLoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
