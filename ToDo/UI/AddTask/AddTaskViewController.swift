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
    @IBOutlet weak var taskNameTextField: CustomTextField!
    @IBOutlet weak var pickerViewTitleLabel: TableHeaderLabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    let addTaskVM = AddTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskVM.getCategories()
        setupUI()
        taskNameTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue)
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(addCategotyLabelOnTapped))
        addNewCategoryLabel.addGestureRecognizer(categoryTapGesture)
        
        let dateTimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(showPickerView))
        dateTimeLabel.addGestureRecognizer(dateTimeTapGesture)
        
        datePicker.minimumDate = Date()
    }
    
    @IBAction func favouriteButtonOnTapped(_ sender: Any) {
        addTaskVM.isFavourite = !addTaskVM.isFavourite
        addTaskVM.isFavourite ? favouriteButton.setImage(UIImage(named: "favourite_filled"), for: .normal) : favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
    }
    
    
    @IBAction func datePickerDidChanged(_ sender: Any) {
        pickerViewTitleLabel.text = datePicker.date.formatted
    }
    
    fileprivate func setupUI(){
        dateTimeLabel.text = datePicker.date.formatted
        pickerViewTitleLabel.text = "Set date and time"
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        if addTaskVM.categories?.count ?? 0 > 0{
            UIHelper.hide(view: noRecordsLabel)
            UIHelper.show(view: collectionView)
        }else{
            UIHelper.show(view: noRecordsLabel)
            UIHelper.hide(view: collectionView)
        }
    }
    
    @IBAction func remonderSwitchValueChanged(_ sender: Any) {
        addTaskVM.isReminder = reminderSwitch.isOn
    }
    
    @IBAction func pickerViewSubmitButtonOnTapped(_ sender: Any) {
        pickerViewBottomConstraint.constant = -350
        addTaskVM.selectedDate = datePicker.date
        dateTimeLabel.text = datePicker.date.formatted
        refreshView()
    }
    
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addTaskButtonOnTapped(_ sender: Any) {
        addTaskVM.addTask(taskName: taskNameTextField.text!, isFavourite: addTaskVM.isFavourite, dateTime: addTaskVM.selectedDate ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showPickerView(){
        pickerViewBottomConstraint.constant = 0
        refreshView()
    }
    
    @objc func addCategotyLabelOnTapped(){
        let categoryModelVC = UIHelper.makeViewController(viewControllerName: .CategoriesVC) as! CategoriesViewController
        self.modalPresentationStyle = .currentContext
        self.present(categoryModelVC, animated: true, completion: nil)
    }
    
    private func refreshView(){
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AddTaskViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addTaskVM.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = addTaskVM.categories?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue, for: indexPath) as! CategoriesCollectionViewCell
        cell.category = category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = addTaskVM.categories?[indexPath.row]
        addTaskVM.selectedCategory = selectedCategory
        for category in addTaskVM.categories!{
            if category == selectedCategory{
                category.isSelected = true
            }else{
                category.isSelected = false
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectedCategory = addTaskVM.categories?[indexPath.row]
        let font = UIFont(name: "Montserrat-Bold", size: 11.0)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let initialSize = (selectedCategory!.name as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: initialSize.width + 10, height: initialSize.height + 10)
    }
}

extension AddTaskViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
