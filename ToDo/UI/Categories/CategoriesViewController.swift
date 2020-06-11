//
//  CategoriesViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var noRecordsLabel: SmallTitleLabel!
    @IBOutlet weak var tableView: UITableView!
    
    let categoriesVM = CategoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"CategoriesTableViewCell" , bundle: .main), forCellReuseIdentifier: UIConstant.Cell.CategoriesTableViewCell.rawValue)
        
        
    }
    
    private func setupUI(){
        if categoriesVM.categories.count > 0{
            UIHelper.hide(view: noRecordsLabel)
        }else{
            UIHelper.show(view: noRecordsLabel)
        }
    }
    
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCategoryButtonOnTapped(_ sender: Any) {
        //TODO
    }
}

extension CategoriesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesVM.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoriesVM.categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.CategoriesTableViewCell.rawValue, for: indexPath) as! CategoriesTableViewCell
        cell.category = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
}
