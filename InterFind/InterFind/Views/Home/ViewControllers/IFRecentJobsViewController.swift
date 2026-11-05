//
//  IFRecentJobsViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 12/11/24.
//

import UIKit

class IFRecentJobsViewController: UIViewController {

    var recentCollectionView: UICollectionView!
    var recentCollectionViewLayout: UICollectionViewFlowLayout!
    let controller: HomeController
    
    init(controller: HomeController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUrgentCollectionView()
        Task {
            await controller.getInterships()
            recentCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recentCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recentCollectionViewLayout.itemSize = CGSize(width: view.frame.width , height: 150)
    }
    
    func setupUrgentCollectionView() {
        recentCollectionViewLayout = UICollectionViewFlowLayout()
        recentCollectionViewLayout.scrollDirection = .vertical
        recentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: recentCollectionViewLayout)
        recentCollectionView.showsVerticalScrollIndicator = false
        recentCollectionView.backgroundColor = .clear
        recentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
        recentCollectionView.register(IFRecentJobsCell.self, forCellWithReuseIdentifier: IFRecentJobsCell.identifier)
        
        view.addSubview(recentCollectionView)
        
        NSLayoutConstraint.activate([
            recentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            recentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }
}

extension IFRecentJobsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let internship = controller.internships[indexPath.row]
        let detailViewController = IFJobDetailViewController(internship: internship, index: indexPath.row, controller: controller)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension IFRecentJobsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.internships.count > 5 ? 5 : controller.internships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IFRecentJobsCell.identifier, for: indexPath) as! IFRecentJobsCell
        let internship = controller.internships[indexPath.row]
        cell.isFavoriteTapped = controller.internships[indexPath.row].isFavorite
        cell.index = indexPath.row
        cell.setCell(internship: internship)
        Task {
            if let image = await controller.getImageData(urlString: internship.imageUrl, companyName: internship.companyName) {
                cell.imageCompany.image = image
            }
        }
        cell.delegate = self
        return cell
    }
    
}

extension IFRecentJobsViewController: IFRecentJobsCellDelegate {
    func didTapFavoriteButton(cell: IFRecentJobsCell, index: Int) {
        // toguear el favorito.
        self.controller.internships[index].isFavorite.toggle()
        cell.isFavoriteTapped = controller.internships[index].isFavorite
        
        self.controller.internships[index].isFavorite ? controller.saveInternshipAsFavorite(internship: controller.internships[index]) : controller.deleteInternshipFromFavorite(internship: controller.internships[index])
    }
}
