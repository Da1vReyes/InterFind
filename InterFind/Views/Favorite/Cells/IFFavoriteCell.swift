//
//  IFFavoriteCell.swift
//  InterFind
//
//  Created by Alex Diaz on 24/11/24.
//

import UIKit

protocol IFFavoriteCellDelegate: AnyObject {
    func didTapOptionButton(cell: IFFavoriteCell, index: Int)
}

class IFFavoriteCell: UICollectionViewCell {
    
    weak var delegate: IFFavoriteCellDelegate?
    
    static let identifier = "IFFavoriteCell"
    
    var index: Int?
    
    let imageCompany = IFImageView()
    let jobTitleLabel = IFTitleLabel(text: "",font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    let companyAndLocationLabel = IFBodyLabel(text: "")
    let salaryLabel = IFBodyLabel(text: "")
    let durationLabel = IFBodyLabel(text: "")
    let jobBenefitsStackView = IFBenefitsView(benefits: "")
    let optionButton = IFPlainButton()
    
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
        
        imageCompany.contentMode = .scaleAspectFill
        
        jobTitleLabel.adjustsFontSizeToFitWidth = true
        jobTitleLabel.minimumScaleFactor = 0.7
        
        salaryLabel.textAlignment = .right
        salaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        companyAndLocationLabel.textColor = .label
        companyAndLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        companyAndLocationLabel.minimumScaleFactor = 0.6
        companyAndLocationLabel.adjustsFontSizeToFitWidth = true
        
       
        [imageCompany, jobTitleLabel, companyAndLocationLabel, salaryLabel, jobBenefitsStackView, optionButton, durationLabel].forEach { item in addSubview(item) }
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            imageCompany.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            imageCompany.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            imageCompany.heightAnchor.constraint(equalToConstant: 40),
            imageCompany.widthAnchor.constraint(equalToConstant: 40),
            
            optionButton.topAnchor.constraint(equalTo: topAnchor, constant: topBottomPadding),
            optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            optionButton.heightAnchor.constraint(equalToConstant: 30),
            optionButton.widthAnchor.constraint(equalToConstant: 30),
            
            jobTitleLabel.topAnchor.constraint(equalTo: imageCompany.bottomAnchor, constant: topBottomPadding),
            jobTitleLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            jobTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            companyAndLocationLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 5),
            companyAndLocationLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            companyAndLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            companyAndLocationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            salaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            salaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            salaryLabel.heightAnchor.constraint(equalToConstant: 20),
            salaryLabel.widthAnchor.constraint(equalToConstant: 150),
            
            durationLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomPadding),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            durationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            
            jobBenefitsStackView.heightAnchor.constraint(equalToConstant: 30),
            jobBenefitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftRightPadding),
            jobBenefitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leftRightPadding),
            jobBenefitsStackView.bottomAnchor.constraint(equalTo: salaryLabel.topAnchor, constant: -10),
        ])
    }
    
    func setCell(internship: Internship) {
        setButton()
        jobTitleLabel.text = internship.title
        self.jobBenefitsStackView.configure(benefits: internship.benefits ?? "", backgroundColor: .systemGray3)
        companyAndLocationLabel.text = (internship.companyName ?? "") + " - " + (internship.location ?? "")
        durationLabel.text = internship.duration
        durationLabel.textColor = .systemGray3
        salaryLabel.attributedText = .stipend(internship.stipend)
        
    }
    // MARK: BUTTON
    func setButton () {
        optionButton.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
        
        if let image = UIImage(systemName: "ellipsis") {
            let resizeImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
            optionButton.setImage(resizeImage, for: .normal)
        }
        optionButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    
    @objc func optionButtonTapped() {
        guard let index else { return }
        
        self.delegate?.didTapOptionButton(cell: self, index: index)
    }
}


