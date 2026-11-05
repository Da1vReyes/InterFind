//
//  IFFavoriteCollectionViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 24/11/24.
//

import UIKit

protocol IFFavoriteCollectionViewControllerDelegate: AnyObject {
    func favoriteOptionButtonTapped()
}

class IFFavoriteCollectionViewController: UIViewController {

    var favoriteCollectionView: UICollectionView!
    var favoriteCollectionViewLayout: UICollectionViewFlowLayout!
    let controller: HomeController
    weak var delegate: IFFavoriteCollectionViewControllerDelegate?
    
    init(controller: HomeController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFavoriteCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteCollectionViewLayout.itemSize = CGSize(width: view.frame.width , height: 205)
    }
    
    func setupFavoriteCollectionView() {
        favoriteCollectionViewLayout = UICollectionViewFlowLayout()
        favoriteCollectionViewLayout.scrollDirection = .vertical
        favoriteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: favoriteCollectionViewLayout)
        favoriteCollectionView.showsVerticalScrollIndicator = false
        favoriteCollectionView.backgroundColor = .clear
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(IFFavoriteCell.self, forCellWithReuseIdentifier: IFFavoriteCell.identifier)
        
        view.addSubview(favoriteCollectionView)
        
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }
}

extension IFFavoriteCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let internship = controller.favoriteInternships[indexPath.row]
        let internshipModel = InternshipModel(id: internship.id!, companyName: internship.companyName!, title: internship.title!, description: internship.descriptionObject!, duration: internship.duration!, location: internship.location!, requirements: internship.requirements!, benefits: internship.benefits!, imageUrl: internship.imageUrl!, isFavorite: true)
        let detailViewController = IFJobDetailViewController(internship: internshipModel, index: indexPath.row, controller: controller)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension IFFavoriteCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.favoriteInternships.count > 5 ? 5 : controller.favoriteInternships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IFFavoriteCell.identifier, for: indexPath) as! IFFavoriteCell
        
        let internship = controller.favoriteInternships[indexPath.row]
        cell.index = indexPath.row
        cell.setCell(internship: internship)
        
        if let imageUrl = internship.imageUrl {
            
            Task {
                if let image = await controller.getImageData(urlString: imageUrl, companyName: internship.companyName) {
                    cell.imageCompany.image = image
                }
            }
            cell.delegate = self
        }
        return cell
    }
    
}

extension IFFavoriteCollectionViewController: IFFavoriteCellDelegate {
    func didTapOptionButton(cell: IFFavoriteCell, index: Int) {
        self.delegate?.favoriteOptionButtonTapped()
    }
}
