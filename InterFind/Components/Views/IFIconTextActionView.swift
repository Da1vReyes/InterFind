import UIKit

class IFIconTextActionView: UIView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    init(iconName: String, title: String) {
        super.init(frame: .zero)
        setupUI(iconName: iconName, title: title)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(iconName: "person.circle", title: "Title")
    }

    private func setupUI(iconName: String, title: String) {
        backgroundColor = .white
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        let accentColor = UIColor(named: "Accent") ?? .orange

        // Leading icon
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = accentColor
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Title
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = UIColor(named: "MainTextColor") ?? .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Action button (+)
        let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13, weight: .bold))
        actionButton.setImage(plusImage, for: .normal)
        actionButton.tintColor = accentColor
        actionButton.backgroundColor = accentColor.withAlphaComponent(0.1)
        actionButton.layer.cornerRadius = 12
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 24),
            actionButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Stack: icon + text
        let leftStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        leftStack.axis = .horizontal
        leftStack.spacing = 12
        leftStack.alignment = .center
        leftStack.translatesAutoresizingMaskIntoConstraints = false

        // Outer stack
        let mainStack = UIStackView(arrangedSubviews: [leftStack, actionButton])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    func setAction(target: Any?, action: Selector) {
        actionButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
