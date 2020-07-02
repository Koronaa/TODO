//
//  CategoriesViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit
import RxSwift

class CategoriesViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var addCategoryButton: CustomButton!
    @IBOutlet weak var noRecordsLabel: SmallTitleLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryNameTextField: CustomTextField!
    
    let categoriesVM = CategoriesViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setObservables()
        setupUI()
        categoryNameTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"CategoriesTableViewCell" , bundle: .main), forCellReuseIdentifier: UIConstant.Cell.CategoriesTableViewCell.rawValue)
    }
    
    private func setupUI(){
        mainView.backgroundColor = .BackgroundColor
        tableView.backgroundColor = .BackgroundColor
        UIHelper.disableView(view: addCategoryButton)
        if categoriesVM.categories.value.count > 0{
            UIHelper.hide(view: noRecordsLabel)
        }else{
            UIHelper.show(view: noRecordsLabel)
        }
    }
    
    private func loadData(){
        categoriesVM.getCategories()
    }
    
    private func setObservables(){
        categoriesVM.categories.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.setupUI()
            }).disposed(by: bag)
    }
    
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCategoryButtonOnTapped(_ sender: Any) {
        categoriesVM.addCategory(for: categoryNameTextField.text!).asObservable()
            .subscribe(onNext: { (isAdded,error) in
                if isAdded{
                    NotificationCenter.default.post(Notification(name: .categoriesUpdated))
                    self.dismiss(animated: true, completion: nil)
                }else{
                    UIHelper.makeBanner(error: error!)
                    self.categoryNameTextField.text = ""
                }
            }).disposed(by: bag)
    }
}

extension CategoriesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesVM.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoriesVM.categories.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.CategoriesTableViewCell.rawValue, for: indexPath) as! CategoriesTableViewCell
        cell.categoriesTableViewVM = CategoriesTableViewViewModel(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            categoriesVM.selectedCategory = categoriesVM.categories.value[indexPath.row]
            categoriesVM.deleteCategory().asObservable()
                .subscribe(onNext: { [weak self] (isDeleted,error) in
                    if isDeleted{
                        NotificationCenter.default.post(Notification(name: .categoriesUpdated))
                        self?.loadData()
                    }else{
                        UIHelper.makeBanner(error: error!)
                    }
                }).disposed(by: bag)
        }
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
            UIHelper.makeBanner(error: CustomError(title: nil, message: "Category cannot be empty"))
            UIHelper.disableView(view: addCategoryButton)
        }
    }
}
