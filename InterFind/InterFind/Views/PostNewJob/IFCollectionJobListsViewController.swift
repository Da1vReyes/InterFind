//
//  IFViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 21/6/25.
//

import UIKit
import UIKit

protocol IFAdminInternshipListViewDelegate: AnyObject {
    func adminOptionButtonTapped()
}

class IFAdminInternshipListViewController: UIViewController, UICollectionViewDelegate {
    
    var selectedInternshipIndex: Int?
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    let controller: InternshipAdminController
    var delegate: IFAdminInternshipListViewDelegate?

    init(controller: InternshipAdminController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await controller.getInterships()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.itemSize = CGSize(width: view.frame.width, height: 205)
    }

    private func setupCollectionView() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IFAdminInternshipCell.self, forCellWithReuseIdentifier: IFAdminInternshipCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - DataSource
extension IFAdminInternshipListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.internships.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let internship = controller.internships[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IFAdminInternshipCell.identifier, for: indexPath) as! IFAdminInternshipCell

        cell.setCell(internship: internship)
        cell.delegate = self
        cell.index = indexPath.row

        let imageUrl = internship.imageUrl
        Task {
            if let image = await controller.getImageData(urlString: imageUrl, companyName: internship.companyName) {
                cell.imageCompany.image = image
            }
        }

        return cell
    }
}

// MARK: - Delegate
extension IFAdminInternshipListViewController: IFAdminInternshipCellDelegate {
    
    func didTapOptionButton(for internship: InternshipModel, index: Int) {
        
        selectedInternshipIndex = index
        let modalVC = IFAdminModalViewController()
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        modalVC.delegate = self

        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.custom { $0.maximumDetentValue * 0.25 }]
            sheet.prefersGrabberVisible = true
        }

        self.present(modalVC, animated: true)
    }
}

extension IFAdminInternshipListViewController: IFAdminModalDelegate {
    func didTapEdit() {
        print("hello")
    }
    
    func didTapDelete() {
        let alert = UIAlertController(title: "¿Estás seguro?", message: "Esta acción eliminará esta práctica permanentemente.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { [weak self] _ in
            Task {
                await self?.controller.deleteInternship(at: self?.selectedInternshipIndex! ?? 0)
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            self?.presentIFAlertOnMainThread(title: "Práctica eliminada", message: "Se eliminó correctamente.", buttonTitle: "OK")
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
}
