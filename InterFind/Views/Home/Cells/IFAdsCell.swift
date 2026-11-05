//
//  IFAdsCell.swift
//  InterFind
//
//  Created by Alex Diaz on 2/11/24.
//  InterFind: gradient text banner instead of an ad image.
//

import UIKit

class IFAdsCell: UICollectionViewCell {

    static let identifier = "IFAdsCell"

    private let gradientLayer = CAGradientLayer()
    private let tagLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let ctaLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }

    func configure(with banner: AdsData) {
        gradientLayer.colors = [banner.startColor.cgColor, banner.endColor.cgColor]
        titleLabel.text = banner.title
        subtitleLabel.text = banner.subtitle
        accessibilityLabel = "\(banner.title). \(banner.subtitle). Opens the careers page."
    }

    private func configure() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        isAccessibilityElement = true
        accessibilityTraits = .link

        tagLabel.text = "BIG TECH PROGRAM"
        tagLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        tagLabel.textColor = UIColor.white.withAlphaComponent(0.8)

        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.numberOfLines = 2

        ctaLabel.text = "See program →"
        ctaLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        ctaLabel.textColor = .white

        let stack = UIStackView(arrangedSubviews: [tagLabel, titleLabel, subtitleLabel, ctaLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.setCustomSpacing(10, after: subtitleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
