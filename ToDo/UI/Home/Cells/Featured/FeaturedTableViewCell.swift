//
//  FeaturedTableViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

protocol FeaturedCollectionViewDelegate {
    func didSelectFeatured(for featured:Featured)
}

class FeaturedTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let homeVM = HomeViewModel()
    var featuredCollectionView:UICollectionView!
    var delegate:FeaturedCollectionViewDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        homeVM.getFeaturedItems()
        setupFeaturedCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupFeaturedCollectionView(){
        let featuredLayout = UICollectionViewFlowLayout()
        featuredLayout.scrollDirection = .horizontal
        featuredLayout.itemSize = CGSize(width: 200.0, height: 160.0)
        
        featuredCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180), collectionViewLayout: featuredLayout)
        featuredCollectionView.backgroundColor = .TODOYellow
        featuredCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        featuredCollectionView.isScrollEnabled = true
        featuredCollectionView.showsHorizontalScrollIndicator = false
        featuredCollectionView.contentMode = .center
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.FeaturedCollectionViewCell.rawValue)
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        self.addSubview(featuredCollectionView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.featuredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let featuredItem = homeVM.featuredItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.FeaturedCollectionViewCell.rawValue, for: indexPath) as! FeaturedCollectionViewCell
        cell.featuredCollectionViewViewModel = FeaturedCollectionViewViewModel(featuredItem: featuredItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let featuredItem = homeVM.featuredItems[indexPath.row]
        delegate.didSelectFeatured(for: featuredItem)
    }
}
