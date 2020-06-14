//
//  QueryViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateHeaderLabel: BodyLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTaskLabel: SmallTitleLabel!
    @IBOutlet weak var navigationTitleLabel: BodyLabel!
    @IBOutlet weak var collectionViewHolderViewHeightConstraint: NSLayoutConstraint!
    
    let queryVM = QueryViewModel()
    
    var categoryName:String!
    var selectedUIType:HomeUIType!
    var selectedFeature:Featured!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstant.Cell.TaskTableViewCell.rawValue)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CalenderCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.CalenderCollectionViewCell.rawValue)
        setupUI()
    }
    
    fileprivate func setupData(){
        if selectedUIType == HomeUIType.CATEGORIES{
            queryVM.tasks = queryVM.getTaks(for: categoryName)
        }else{
            queryVM.getFeaturedTasks(for: selectedFeature.type)
        }
    }
    
    fileprivate func setupUI(){
        titleLabel.text = queryVM.title
        dateHeaderLabel.text = queryVM.dateTitle
        navigationTitleLabel.text = queryVM.navigationTitle
        if selectedUIType == HomeUIType.CATEGORIES || selectedFeature.type == .Favourite || selectedFeature.type == .Month || selectedFeature.type == .Week{
            collectionViewHolderViewHeightConstraint.constant = 0
        }else{
            collectionViewHolderViewHeightConstraint.constant = 70
        }
        
        if queryVM.tasks?.count ?? 0 > 0{
            UIHelper.hide(view: noTaskLabel)
            UIHelper.show(view: tableView)
        }else{
            UIHelper.show(view: noTaskLabel)
            UIHelper.hide(view: tableView)
        }
        
    }
    
    @IBAction func sortButtonOnTapped(_ sender: Any) {
        let sortAlertController = UIAlertController(title: "Sort Tasks", message: "Please select the sorting criteria.", preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "By Name", style: .default) { _ in
            if self.selectedUIType == HomeUIType.CATEGORIES{
                self.queryVM.tasks = self.queryVM.getTaks(for: self.categoryName,isSortingEnabled: true,sortType: .BY_NAME)
            }else{
                self.queryVM.getFeaturedTasks(for: self.selectedFeature.type,isSortingEnabled: true,sortType: .BY_NAME)
            }
            self.tableView.reloadData()
        }
        let dateAction = UIAlertAction(title: "By Date", style: .default) { _ in
            if self.selectedUIType == HomeUIType.CATEGORIES{
                self.queryVM.tasks = self.queryVM.getTaks(for: self.categoryName,isSortingEnabled: true,sortType: .BY_DATE)
            }else{
                self.queryVM.getFeaturedTasks(for: self.selectedFeature.type,isSortingEnabled: true,sortType: .BY_DATE)
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sortAlertController.addAction(nameAction)
        sortAlertController.addAction(dateAction)
        sortAlertController.addAction(cancelAction)
        self.present(sortAlertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonOnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func newTaskButtonOnTapped(_ sender: Any) {
        let addTaskModalVC = UIHelper.makeViewController(viewControllerName: .AddTaskVC) as! AddTaskViewController
        addTaskModalVC.uiType = .CREATE
        addTaskModalVC.addTaskViewControllerDelegate = self
        self.modalPresentationStyle = .currentContext
        self.present(addTaskModalVC, animated: true, completion: nil)
    }
    
    
}

extension QueryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryVM.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = queryVM.tasks?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.TaskTableViewCell.rawValue, for: indexPath) as! TaskTableViewCell
        cell.task = task
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = queryVM.tasks?[indexPath.row]
        let updateTaskVC = UIHelper.makeViewController(viewControllerName: .AddTaskVC) as! AddTaskViewController
        updateTaskVC.addTaskViewControllerDelegate = self
        updateTaskVC.uiType = .UPDATE
        updateTaskVC.addTaskVM.currentTask = task
        self.present(updateTaskVC, animated: true, completion: nil)
    }
}

extension QueryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryVM.days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = queryVM.days?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CalenderCollectionViewCell.rawValue, for: indexPath) as! CalenderCollectionViewCell
        cell.day = day
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentDay = queryVM.days?[indexPath.row]
        queryVM.getTasksForSpecificDate(dateString: currentDay!.dateString){
            self.setupUI()
            self.tableView.reloadData()
        }
        for day in queryVM.days!{
            if day == currentDay{
                day.isSelected = true
            }else{
                day.isSelected = false
            }
        }
        collectionView.reloadData()
    }
}

extension QueryViewController:AddTaskViewControllerDelegate{
    func taskUpdated() {
        setupData()
        self.tableView.reloadData()
    }
}
