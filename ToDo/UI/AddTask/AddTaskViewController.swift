//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate {
    func taskUpdated()
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: TitleLabel!
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
    @IBOutlet weak var addTaskButton: CustomButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    let addTaskVM = AddTaskViewModel()
    var uiType:AddTaskUIType!
    var addTaskViewControllerDelegate:AddTaskViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskVM.getCategories{
            
        }
        loadData()
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
    
    func loadData(){
        if uiType == AddTaskUIType.UPDATE{
            if let task = addTaskVM.currentTask{
                addTaskVM.updateData(from: task)
                setupUI(for: .UPDATE)
            }
        }else{
            setupUI(for: .CREATE)
        }
    }
    
    fileprivate func setupUI(for type:AddTaskUIType){
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        if addTaskVM.categories?.count ?? 0 > 0{
            UIHelper.hide(view: noRecordsLabel)
            UIHelper.show(view: collectionView)
        }else{
            UIHelper.show(view: noRecordsLabel)
            UIHelper.hide(view: collectionView)
        }
        
        if type == .CREATE{
            titleLabel.text = "Add Task"
            dateTimeLabel.text = datePicker.date.formatted
            pickerViewTitleLabel.text = "Set date and time"
            addTaskButton.setTitle("Add Task", for: .normal)
            UIHelper.hide(view: deleteButton)
        }else{
            dateTimeLabel.text = addTaskVM.selectedDate?.formatted
            taskNameTextField.text = addTaskVM.taskTitle
            reminderSwitch.setOn(addTaskVM.isReminder, animated: true)
            addTaskVM.isFavourite ? favouriteButton.setImage(UIImage(named: "favourite_filled"), for: .normal) : favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
            addTaskButton.setTitle("Update Task", for: .normal)
            UIHelper.show(view: deleteButton)
            titleLabel.text = "Update Task"
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
    
    @IBAction func deleteButtonOnTapped(_ sender: Any) {
        let deleteAlertController = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.addTaskVM.deleteTask()
            self.addTaskViewControllerDelegate.taskUpdated()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        self.present(deleteAlertController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addTaskButtonOnTapped(_ sender: Any) {
        addTaskVM.taskTitle = taskNameTextField.text!
        if uiType == AddTaskUIType.CREATE{
            addTaskVM.addTask()
        }else{
            addTaskVM.updateTask()
        }
        addTaskViewControllerDelegate.taskUpdated()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showPickerView(){
        pickerViewBottomConstraint.constant = 0
        refreshView()
    }
    
    @objc func addCategotyLabelOnTapped(){
        let categoryModelVC = UIHelper.makeViewController(viewControllerName: .CategoriesVC) as! CategoriesViewController
        categoryModelVC.categoriesViewControllerDelegate = self
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

extension AddTaskViewController:CategoriesViewControllerDelegate{
    func categoriesUpdated() {
        addTaskVM.getCategories{
            self.collectionView.reloadData()
        }
    }
}
