//
//  CategoriesViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate {
    func categoriesUpdated()
}

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var addCategoryButton: CustomButton!
    @IBOutlet weak var noRecordsLabel: SmallTitleLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryNameTextField: CustomTextField!
    
    let categoriesVM = CategoriesViewModel()
    var categoriesViewControllerDelegate:CategoriesViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        categoryNameTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"CategoriesTableViewCell" , bundle: .main), forCellReuseIdentifier: UIConstant.Cell.CategoriesTableViewCell.rawValue)
    }
    
    private func setupUI(){
        UIHelper.disableView(view: addCategoryButton)
        if categoriesVM.categories.count > 0{
            UIHelper.hide(view: noRecordsLabel)
        }else{
            UIHelper.show(view: noRecordsLabel)
        }
    }
    
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        categoriesViewControllerDelegate.categoriesUpdated()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCategoryButtonOnTapped(_ sender: Any) {
        categoriesVM.addCategory(for: categoryNameTextField.text!)
        categoriesViewControllerDelegate.categoriesUpdated()
        self.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            categoriesVM.selectedCategory = categoriesVM.categories[indexPath.row]
            categoriesVM.deleteCategory()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
        setupUI()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension CategoriesViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.validateText(validationType: .basic){
            UIHelper.enableView(view: addCategoryButton)
        }else{
            print("Category cannot be empty")
            UIHelper.disableView(view: addCategoryButton)
        }
    }
}
