//
//  UrgentJobsViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 6/11/24.
//

import UIKit

class IFUrgentJobsViewController: UIViewController {

    var urgentCollectionView: UICollectionView!
    var urgentCollectionViewLayout: UICollectionViewFlowLayout!
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
            urgentCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        urgentCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        urgentCollectionViewLayout.itemSize = CGSize(width: view.frame.width * 0.9, height: view.frame.height)
    }
    
    func setupUrgentCollectionView() {
        urgentCollectionViewLayout = UICollectionViewFlowLayout()
        urgentCollectionViewLayout.scrollDirection = .horizontal
        urgentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: urgentCollectionViewLayout)
        urgentCollectionView.showsHorizontalScrollIndicator = false
        urgentCollectionView.backgroundColor = .clear
        urgentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        urgentCollectionView.dataSource = self
        urgentCollectionView.delegate = self
        urgentCollectionView.register(IFUrgentJobsCell.self, forCellWithReuseIdentifier: IFUrgentJobsCell.identifier)
        
        view.addSubview(urgentCollectionView)
        
        NSLayoutConstraint.activate([
            urgentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            urgentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            urgentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            urgentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }
}

extension IFUrgentJobsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let internship = controller.internships[indexPath.row]
        let detailViewController = IFJobDetailViewController(internship: internship, index: indexPath.row, controller: controller)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

extension IFUrgentJobsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.internships.count > 5 ? 5 : controller.internships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IFUrgentJobsCell.identifier, for: indexPath) as! IFUrgentJobsCell
        let internship = controller.internships[indexPath.row]
        cell.index = indexPath.row
        cell.isFavoriteTapped = controller.internships[indexPath.row].isFavorite
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

extension IFUrgentJobsViewController: UrgentJobsCellDelegate {
    func didTapFavoriteButton(cell: IFUrgentJobsCell, index: Int) {
        
        self.controller.internships[index].isFavorite.toggle()
        cell.isFavoriteTapped = controller.internships[index].isFavorite
        
        self.controller.internships[index].isFavorite ? controller.saveInternshipAsFavorite(internship: controller.internships[index]) : controller.deleteInternshipFromFavorite(internship: controller.internships[index])
    }
}
