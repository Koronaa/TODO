//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addNewCategoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noRecordsLabel: SmallTitleLabel!
    
    let addTaskVM = AddTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue)
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(addCategotyLabelOnTapped))
        addNewCategoryLabel.addGestureRecognizer(categoryTapGesture)
        
    }
    
    fileprivate func setupUI(){
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        
        if addTaskVM.categories.count > 0{
            UIHelper.hide(view: noRecordsLabel)
            UIHelper.show(view: collectionView)
        }else{
            UIHelper.show(view: noRecordsLabel)
            UIHelper.hide(view: collectionView)
        }
        
        
    }
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func addCategotyLabelOnTapped(){
        let categoryModelVC = UIHelper.makeViewController(viewControllerName: .CategoriesVC) as! CategoriesViewController
        self.modalPresentationStyle = .currentContext
        self.present(categoryModelVC, animated: true, completion: nil)
        
    }
}

extension AddTaskViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addTaskVM.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = addTaskVM.categories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue, for: indexPath) as! CategoriesCollectionViewCell
        cell.category = category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = addTaskVM.categories[indexPath.row]
        for category in addTaskVM.categories{
            if category == selectedCategory{
                category.isSelected = true
            }else{
                category.isSelected = false
            }
        }
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectedCategory = addTaskVM.categories[indexPath.row]
        let font = UIFont(name: "Montserrat-Bold", size: 11.0)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let initialSize = (selectedCategory.name as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: initialSize.width + 10, height: initialSize.height + 10)
    }
    

    
    
}
