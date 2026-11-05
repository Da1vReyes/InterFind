//
//  IFSearchViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 27/11/24.
//

import UIKit

class IFSearchViewController: UIViewController {

    enum Section { case main }

    var dataSource: UICollectionViewDiffableDataSource<Section, InternshipModel>!
    var collectionView: UICollectionView!
    var searchController: SearchController
    var homeController: HomeController
    
    let emptyStateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let padding: CGFloat = 20
    
    
    init(searchController: SearchController, homeController: HomeController) {
        self.searchController = searchController
        self.homeController = homeController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        setSearchBar()
        setupUI()
    }
    
    func setupUI() {
        configureCollectionView()
        configureDataSource()
        configureEmptyState()
        showResults(for: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationController()
        showResults(for: navigationItem.searchController?.searchBar.text ?? "")
    }

    /// Sin texto muestra todas las pasantías; con texto, las filtradas.
    func showResults(for query: String) {
        if query.isEmpty {
            searchController.filteredInternships = homeController.internships
        } else {
            searchController.filterInternships(with: query, internships: homeController.internships)
        }
        let results = searchController.filteredInternships
        emptyStateContainer.isHidden = !results.isEmpty
        collectionView.isHidden = results.isEmpty
        updateData(on: results)
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - padding * 2, height: 180)
        layout.minimumLineSpacing = padding

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(IFSearchCell.self, forCellWithReuseIdentifier: IFSearchCell.identifier)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, InternshipModel>(collectionView: collectionView) { (collectionView, indexPath, internship) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IFSearchCell.identifier, for: indexPath) as! IFSearchCell
            cell.setCell(internship: internship)
            Task {
                if let image = await self.homeController.getImageData(urlString: internship.imageUrl, companyName: internship.companyName) {
                    cell.imageCompany.image = image
                }
            }
            return cell
        }
    }

    private func updateData(on internships: [InternshipModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, InternshipModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(internships)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func configureEmptyState() {
        let searchEmptyStateViewController = IFEmptySearchStateViewController()
        self.addChildViewController(childVC: searchEmptyStateViewController, to: emptyStateContainer)
        view.addSubview(emptyStateContainer)

        NSLayoutConstraint.activate([
            emptyStateContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 3),
            emptyStateContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            emptyStateContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            emptyStateContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding * 3)
        ])
    }
    
    func setNavigationController() {
        let isRootOfTab = navigationController?.viewControllers.first === self
        if isRootOfTab {
            title = "Buscar"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.leftBarButtonItem = nil
            tabBarController?.tabBar.isHidden = false
        } else {
            let backButton = UIBarButtonItem(image: UIImage(systemName:"chevron.left"), style: .plain, target: self, action: #selector(didBackButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
        navigationController?.navigationBar.isHidden = false
    }
    
    func setSearchBar() {
        let searchBarController = UISearchController()
        searchBarController.searchResultsUpdater = self

        navigationItem.searchController = searchBarController
        searchBarController.searchBar.placeholder = "Buscar un trabajo..."
        
    }
    
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



extension IFSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        showResults(for: searchController.searchBar.text ?? "")
    }
}

extension IFSearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let internship = searchController.filteredInternships[indexPath.row]
        let detailViewController = IFJobDetailViewController(internship: internship, index: indexPath.row, controller: homeController)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

