//
//  IFFavoriteEmptyState.swift
//  InterFind
//
//  Created by Alex Diaz on 16/11/24.
//

import UIKit

final class IFFavoriteEmptyState: UIViewController {
    
    weak var delegate: IFFavoriteEmptyStateDelegate?
    
    let emptyStateImageView: IFImageView = IFImageView()
    let emptyStateTitleLabel: IFTitleLabel = IFTitleLabel(text: "No hay favoritos", font: UIFont.systemFont(ofSize: 22, weight: .bold))
    let emptyStateSubtitleLabel: IFBodyLabel = IFBodyLabel(text: "Aún no tienes favoritos. Explora y guarda lo que más te gusta para tenerlo siempre a mano.")
    let emptyStateSearchJobButton: IFRoundedButton = IFRoundedButton(text: "BUSCA UN TRABAJO")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        setupBasicConstraints()
        setupLabels()
        setImage()
        setSearchJobButton()
    }
    
    private func setupBasicConstraints() {
        
        [emptyStateTitleLabel, emptyStateSubtitleLabel, emptyStateImageView].forEach { item in
            view.addSubview(item)
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
    private func setupLabels() {
        
        emptyStateSubtitleLabel.numberOfLines = 3
        emptyStateSubtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emptyStateSubtitleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            emptyStateTitleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateTitleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            emptyStateSubtitleLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: 3),
            emptyStateSubtitleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setImage() {
        view.addSubview(emptyStateImageView)
        emptyStateImageView.image = UIImage(resource: .favoriteEmptyState)
        NSLayoutConstraint.activate([
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateSubtitleLabel.bottomAnchor),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 220)
        ])

    }
    private func setSearchJobButton() {
        view.addSubview(emptyStateSearchJobButton)
        emptyStateSearchJobButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        emptyStateSearchJobButton.addTarget(self, action: #selector(emptyStateSearchJobButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emptyStateSearchJobButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateSearchJobButton.heightAnchor.constraint(equalToConstant: 45),
            emptyStateSearchJobButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateSearchJobButton.widthAnchor.constraint(equalToConstant: 250)
            
        ])
    }
    
    @objc func emptyStateSearchJobButtonTapped() {
        delegate?.favoriteEmptyStateSearchJobButton()
    }
}

protocol IFFavoriteEmptyStateDelegate: AnyObject {
    func favoriteEmptyStateSearchJobButton()
}
