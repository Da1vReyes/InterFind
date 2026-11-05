//
//  IFAdminInternshipCell.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit

protocol IFAdminInternshipCellDelegate: AnyObject {
    func didTapOptionButton(for internship: InternshipModel, index: Int)
}

class IFAdminInternshipCell: UICollectionViewCell {

    static let identifier = "IFAdminInternshipCell"
    private var currentInternship: InternshipModel?
    
    weak var delegate: IFAdminInternshipCellDelegate?
    var index: Int?
    
    let optionButton = IFPlainButton()
    
    let imageCompany = IFImageView()
    let jobTitleLabel = IFTitleLabel(text: "", font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    let companyAndLocationLabel = IFBodyLabel(text: "")
    let durationLabel = IFBodyLabel(text: "")
    let jobBenefitsStackView = IFBenefitsView(benefits: "")
    
    let editButton = IFPlainButton()
    let deleteButton = IFPlainButton()
    
    let padding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        imageCompany.layer.cornerRadius = imageCompany.frame.height / 2
    }

    func configure() {
        backgroundColor = .white
        layer.cornerRadius = 10
        imageCompany.contentMode = .scaleAspectFill
        
        jobTitleLabel.adjustsFontSizeToFitWidth = true
        jobTitleLabel.minimumScaleFactor = 0.7

        companyAndLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        companyAndLocationLabel.textColor = .label
        companyAndLocationLabel.adjustsFontSizeToFitWidth = true

        durationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        durationLabel.textColor = .systemGray

        [imageCompany, jobTitleLabel, companyAndLocationLabel, jobBenefitsStackView, durationLabel, optionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageCompany.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageCompany.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageCompany.heightAnchor.constraint(equalToConstant: 40),
            imageCompany.widthAnchor.constraint(equalToConstant: 40),

            optionButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            optionButton.widthAnchor.constraint(equalToConstant: 30),
            optionButton.heightAnchor.constraint(equalToConstant: 30),

            jobTitleLabel.topAnchor.constraint(equalTo: imageCompany.bottomAnchor, constant: padding),
            jobTitleLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            jobTitleLabel.trailingAnchor.constraint(equalTo: optionButton.leadingAnchor, constant: -padding),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 22),

            companyAndLocationLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 4),
            companyAndLocationLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            companyAndLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            companyAndLocationLabel.heightAnchor.constraint(equalToConstant: 18),

            jobBenefitsStackView.topAnchor.constraint(equalTo: companyAndLocationLabel.bottomAnchor, constant: 10),
            jobBenefitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            jobBenefitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            jobBenefitsStackView.heightAnchor.constraint(equalToConstant: 30),

            durationLabel.topAnchor.constraint(equalTo: jobBenefitsStackView.bottomAnchor, constant: 6),
            durationLabel.leadingAnchor.constraint(equalTo: imageCompany.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            durationLabel.heightAnchor.constraint(equalToConstant: 18)
        ])

        setOptionButton()
    }
    func setOptionButton() {
        optionButton.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
        if let image = UIImage(systemName: "ellipsis") {
            let resizedImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
            optionButton.setImage(resizedImage, for: .normal)
        }
        optionButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }

    @objc func optionButtonTapped() {
        guard let index = index, let internship = currentInternship else { return }
        delegate?.didTapOptionButton(for: internship, index: index)
    }
    func setCell(internship: InternshipModel) {
        self.currentInternship = internship
        jobTitleLabel.text = internship.title
        companyAndLocationLabel.text = (internship.companyName) + " - " + (internship.location)
        durationLabel.text = internship.duration
        jobBenefitsStackView.configure(benefits: internship.benefits, backgroundColor: .systemGray4)
    }
    
}
