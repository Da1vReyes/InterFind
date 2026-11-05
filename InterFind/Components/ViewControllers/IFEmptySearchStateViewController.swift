//
//  IFEmptySearchStateViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 27/11/24.
//

import UIKit

class IFEmptySearchStateViewController: UIViewController {
    
    let imageView = IFImageView()
    let titleLabel = IFTitleLabel(text: "No results", font: UIFont.systemFont(ofSize: 22, weight: .semibold))
    let subtitleLabel = IFBodyLabel(text: "Nothing matched. Check the spelling or try another word.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI() {
        subtitleLabel.textAlignment = .center
        
        [imageView, titleLabel, subtitleLabel].forEach { item in
            view.addSubview(item)
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        imageView.setImageWithResources("search-empty-state")
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 26),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
}
