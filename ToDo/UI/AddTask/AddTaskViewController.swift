//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit
import RxSwift

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
    
    
    var addTaskVM:AddTaskViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addObservables()
        
        taskNameTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue)
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(addCategotyLabelOnTapped))
        addNewCategoryLabel.addGestureRecognizer(categoryTapGesture)
        
        let dateTimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(showPickerView))
        dateTimeLabel.addGestureRecognizer(dateTimeTapGesture)
        datePicker.minimumDate = Date()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onCategoriesChanged(_:)), name: .categoriesUpdated, object: nil)
    }
    
    private func loadData(){
        addTaskVM.getReminders()
        addTaskVM.getTranslatedCategories()
        addTaskVM.setupDataForView()
        
        if addTaskVM.UIType == .UPDATE{
            if let task = addTaskVM.currentTask{
                addTaskVM.updateData(from: task)
                setupUI(for: .UPDATE)
            }
        }else{
            setupUI(for: .CREATE)
        }
    }
    
    private func setupUI(for type:AddTaskUIType){
        
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        titleLabel.text = addTaskVM.headerLabel
        addTaskButton.setTitle(addTaskVM.buttonTitle, for: .normal)
        
        
        if addTaskVM.UIType == .CREATE{
            UIHelper.disableView(view: addTaskButton)
            dateTimeLabel.text = datePicker.date.formatted
            UIHelper.hide(view: deleteButton)
        }else{
            dateTimeLabel.text = addTaskVM.selectedDate?.formatted
            taskNameTextField.text = addTaskVM.taskTitle
            reminderSwitch.setOn(addTaskVM.isReminder, animated: true)
            addTaskVM.isFavourite ? favouriteButton.setImage(UIImage(named: "favourite_filled"), for: .normal) : favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
            UIHelper.show(view: deleteButton)
            
        }
    }
    
    private func addObservables(){
        addTaskVM.translatedCategories.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.collectionView.reloadData()
                if self.addTaskVM.translatedCategoryCount > 0{
                    UIHelper.hide(view: self.noRecordsLabel)
                    UIHelper.show(view: self.collectionView)
                }else{
                    UIHelper.show(view: self.noRecordsLabel)
                    UIHelper.hide(view: self.collectionView)
                }
            }).disposed(by: bag)
    }
    
    
    
    @IBAction func favouriteButtonOnTapped(_ sender: Any) {
        addTaskVM.isFavourite = !addTaskVM.isFavourite
        addTaskVM.isFavourite ? favouriteButton.setImage(UIImage(named: "favourite_filled"), for: .normal) : favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
    }
    
    
    @IBAction func datePickerDidChanged(_ sender: Any) {
        pickerViewTitleLabel.text = datePicker.date.formatted
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
            self.addTaskVM.deleteTask().asObservable()
                .subscribe(onNext: { (isTaskDeleted,error) in
                    if isTaskDeleted{
                        NotificationCenter.default.post(Notification(name: .tasksUpdated))
                        self.dismiss(animated: true, completion: nil)
                    }
                    if let e = error{
                        UIHelper.makeBanner(error: e)
                    }
                }).disposed(by: self.bag)
            
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
        if addTaskVM.UIType == .CREATE{
            addTaskVM.addTask().asObservable()
                .subscribe(onNext: { (isTaskAdded,error) in
                    if isTaskAdded{
                        NotificationCenter.default.post(Notification(name: .tasksUpdated))
                        self.dismiss(animated: true, completion: nil)
                    }
                    if let e = error{
                        UIHelper.makeBanner(error: e)
                    }
                    
                }).disposed(by: bag)
        }else{
            addTaskVM.updateTask().asObservable()
                .subscribe(onNext: { (isTaskUpdated,error) in
                    if isTaskUpdated{
                        NotificationCenter.default.post(Notification(name: .tasksUpdated))
                        self.dismiss(animated: true, completion: nil)
                    }
                    if let e = error{
                        UIHelper.makeBanner(error: e)
                    }
                }).disposed(by: bag)
        }
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .categoriesUpdated, object: nil)
    }
}

extension AddTaskViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addTaskVM.translatedCategories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = addTaskVM.translatedCategories.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CategoriesCollectionViewCell.rawValue, for: indexPath) as! CategoriesCollectionViewCell
        cell.category = category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = addTaskVM.translatedCategories.value[indexPath.row]
        addTaskVM.selectedCategory = selectedCategory
        for category in addTaskVM.translatedCategories.value{
            if category == selectedCategory{
                category.isSelected = true
            }else{
                category.isSelected = false
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectedCategory = addTaskVM.translatedCategories.value[indexPath.row]
        let font = UIFont(name: "Montserrat-Bold", size: 11.0)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let initialSize = (selectedCategory.name as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: initialSize.width + 10, height: initialSize.height + 10)
    }
}

extension AddTaskViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.validateText(validationType: .basic) ? UIHelper.enableView(view: addTaskButton) : UIHelper.disableView(view: addTaskButton)
        if !textField.validateText(validationType: .basic){
            UIHelper.makeBanner(error: CustomError(title: nil, message: "Task cannot be empty"))
        }
    }
}

extension AddTaskViewController{
    @objc func onCategoriesChanged(_ notification:Notification){
        addTaskVM.getTranslatedCategories()
    }
}
