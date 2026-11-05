//
//  UrgentJobsCell.swift
//  InterFind
//
//  Created by Alex Diaz on 6/11/24.
//

import UIKit

protocol UrgentJobsCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: IFUrgentJobsCell, index: Int)
}

class IFUrgentJobsCell: UICollectionViewCell {
    
    weak var delegate: UrgentJobsCellDelegate?
    
    static let identifier = "UrgentJobsCell"
    
    var isFavoriteTapped: Bool = false
    var index: Int?
    
    let imageCompany = IFImageView()
    let jobTitleLabel = IFTitleLabel(text: "",font: UIFont.systemFont(ofSize: 22, weight: .bold), textAlignment: .left)
    let companyAndLocationLabel = IFBodyLabel(text: "")
    let salaryLabel = IFBodyLabel(text: "$50 - $70 / Ho")
    let jobBenefitsStackView =  IFBenefitsView(benefits: "")
    let favoriteButton = IFPlainButton()
    
    let topBottomPadding: CGFloat = 12
    let leftRightPadding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        imageCompany.layer.cornerRadius = imageCompany.layer.frame.height / 5
    }
    
    func configure() {
        self.backgroundColor = UIColor.backgroundUrgentCells
        
        jobTitleLabel.adjustsFontSizeToFitWidth = true
        jobTitleLabel.minimumScaleFactor = 0.8
        jobTitleLabel.textColor = .white
        
        salaryLabel.textAlignment = .right
        salaryLabel.textColor = .white
        salaryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        companyAndLocationLabel.textColor = .white
        companyAndLocationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
       
        [imageCompany, jobTitleLabel, companyAndLocationLabel, salaryLabel, jobBenefitsStackView, favoriteButton].forEach { item in addSubview(item) }
        
        NSLayoutConstraint.activate([
            imageCompany.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            imageCompany.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            imageCompany.heightAnchor.constraint(equalToConstant: 60),
            imageCompany.widthAnchor.constraint(equalToConstant: 60),
            
            jobTitleLabel.topAnchor.constraint(equalTo: imageCompany.bottomAnchor, constant: 10),
            jobTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            jobTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            companyAndLocationLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 5),
            companyAndLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            companyAndLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            companyAndLocationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            jobBenefitsStackView.heightAnchor.constraint(equalToConstant: 25),
            jobBenefitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            jobBenefitsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            jobBenefitsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            salaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            salaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            salaryLabel.heightAnchor.constraint(equalToConstant: 20),
            salaryLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setCell(internship: InternshipModel) {
        setButton()
        jobTitleLabel.text = internship.title
        self.jobBenefitsStackView.configure(benefits: internship.benefits)
        companyAndLocationLabel.text = internship.companyName + " - " + internship.location
        imageCompany.image = LocalStore.monogram(for: internship.companyName)
        
        updateButton()
    }
    
    func updateButton() {
        if let image = UIImage(systemName: isFavoriteTapped ? "bookmark.fill" : "bookmark") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24))
            favoriteButton.setImage(resizeImage, for: .normal)
        }
    }
    
    func setButton () {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc func favoriteButtonTapped() {
        
        guard let index else { return }
        DispatchQueue.main.async {
            self.delegate?.didTapFavoriteButton(cell: self, index: index)
            self.updateButton()
        }
    }
}
