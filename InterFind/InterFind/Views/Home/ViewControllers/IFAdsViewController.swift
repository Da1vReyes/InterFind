//
//  IFAdsViewController.swift
//  InterFind
//
//  Created by Alex Diaz on 5/11/24.
//

import UIKit


class IFAdsViewController: UIViewController {

    let layout = UICollectionViewFlowLayout()
    var adsCollectionView: UICollectionView!
    let controller: HomeController
    var pageControl: IFPageControl!
    var index = 0
    
    init(controller: HomeController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAdsCollectionView()
        setupPageControl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adsCollectionView.layer.cornerRadius = 10
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: Ads CollectionView
    func setupAdsCollectionView() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        adsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        adsCollectionView.backgroundColor = .clear
        adsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        adsCollectionView.showsHorizontalScrollIndicator = false
        adsCollectionView.isPagingEnabled = true
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        adsCollectionView.register(IFAdsCell.self, forCellWithReuseIdentifier: IFAdsCell.identifier)
        view.addSubview(adsCollectionView)
        
        NSLayoutConstraint.activate([
            adsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            adsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    func setupPageControl() {
        pageControl = IFPageControl(selectedAt: 0, elementAmount: controller.adsImageData.count)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: adsCollectionView.bottomAnchor, constant: 5),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: CGFloat(controller.adsImageData.count * 28)),
            pageControl.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
}


extension IFAdsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = controller.adsImageData[indexPath.row]?.url else { return }
        guard let url = URL(string: urlString) else { return }
        presentSafariViewController(with: url)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // busco lo que se ve sabiendo el offset del collectionview y su tamaño.
        let visibleRect = CGRect(origin: adsCollectionView.contentOffset, size: adsCollectionView.bounds.size)
        // obtengo el indice exacto del lugar donde lo ando buscando, busco los puntos medios.
        if let visibleIndexPath = adsCollectionView.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) {
            index = visibleIndexPath.item
            pageControl.setSelectedPage(index)
        }
    }
}

extension IFAdsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller.adsImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: IFAdsCell.identifier, for: indexPath) as! IFAdsCell
        if let banner = controller.adsImageData[indexPath.row] {
            cell.configure(with: banner)
        }
        return cell
    }
}


