//
//  IFRecentJobsCell.swift
//  InterFind
//
//  Created by Alex Diaz on 12/11/24.
//

import UIKit

protocol IFRecentJobsCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: IFRecentJobsCell, index: Int)
}

class IFRecentJobsCell: UICollectionViewCell {
    
    weak var delegate: IFRecentJobsCellDelegate?
    
    static let identifier = "RecentJobsCell"
    
    var isFavoriteTapped: Bool = false
    var index: Int?
    
    let imageCompany = IFImageView()
    let jobTitleLabel = IFTitleLabel(text: "",font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    let companyAndLocationLabel = IFBodyLabel(text: "")
    let salaryLabel = IFBodyLabel(text: "")
    let jobBenefitsStackView = IFBenefitsView(benefits: "")
    let favoriteButton = IFPlainButton()
    let applyButton: IFRoundedButton = IFRoundedButton(text: "Apply", color: UIColor.subtitle, backgroundColor: UIColor.applyButton)
    
    let topBottomPadding: CGFloat = 12
    let leftRightPadding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    init(index: Int) {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        imageCompany.layer.cornerRadius = imageCompany.layer.frame.height / 2
    }
    // MARK: Configure
    func configure() {
        self.backgroundColor = .white
        
        jobTitleLabel.adjustsFontSizeToFitWidth = true
        jobTitleLabel.minimumScaleFactor = 0.7
        
        salaryLabel.textAlignment = .left
        salaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        companyAndLocationLabel.textColor = .label
        companyAndLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        companyAndLocationLabel.minimumScaleFactor = 0.6
        companyAndLocationLabel.adjustsFontSizeToFitWidth = true
        
        applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       
        [imageCompany, jobTitleLabel, companyAndLocationLabel, salaryLabel, jobBenefitsStackView, favoriteButton, applyButton].forEach { item in addSubview(item) }
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            imageCompany.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            imageCompany.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            imageCompany.heightAnchor.constraint(equalToConstant: 40),
            imageCompany.widthAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            jobTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            jobTitleLabel.leadingAnchor.constraint(equalTo: imageCompany.trailingAnchor, constant: leftRightPadding),
            jobTitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            companyAndLocationLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 5),
            companyAndLocationLabel.leadingAnchor.constraint(equalTo: imageCompany.trailingAnchor, constant: leftRightPadding),
            companyAndLocationLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            companyAndLocationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            jobBenefitsStackView.heightAnchor.constraint(equalToConstant: 25),
            jobBenefitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            jobBenefitsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            jobBenefitsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            
            salaryLabel.bottomAnchor.constraint(equalTo: jobBenefitsStackView.topAnchor, constant: -5),
            salaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            salaryLabel.heightAnchor.constraint(equalToConstant: 20),
            salaryLabel.widthAnchor.constraint(equalToConstant: 150),
            
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            applyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            applyButton.heightAnchor.constraint(equalToConstant: 25),
            applyButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setCell(internship: InternshipModel) {
        setButton()
        jobTitleLabel.text = internship.title
        self.jobBenefitsStackView.configure(benefits: internship.benefits, backgroundColor: .systemGray3)
        companyAndLocationLabel.text = internship.companyName + " - " + internship.location
        salaryLabel.attributedText = .stipend(internship.stipend)
        
        updateButton()
    }
    // MARK: BUTTON
    func setButton () {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    func updateButton() {
        if let image = UIImage(systemName: isFavoriteTapped ? "bookmark.fill" : "bookmark") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
            favoriteButton.setImage(resizeImage, for: .normal)
        }
    }
    
    @objc func favoriteButtonTapped() {
        guard let index else { return }
        
        DispatchQueue.main.async {
            self.delegate?.didTapFavoriteButton(cell: self, index: index)
            self.updateButton()
        }
    }
}


