//
//  QueryViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit
import RxSwift

class QueryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateHeaderLabel: BodyLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTaskLabel: SmallTitleLabel!
    @IBOutlet weak var navigationTitleLabel: BodyLabel!
    @IBOutlet weak var collectionViewHolderViewHeightConstraint: NSLayoutConstraint!
    
    let queryVM = QueryViewModel()
    let bag = DisposeBag()
    
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
        setObservable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTasksChanged(_:)), name: .tasksUpdated, object: nil)
        
    }
    
    private func setupData(){
        if selectedUIType == HomeUIType.CATEGORIES{
            queryVM.getTaks(for: categoryName)
        }else{
            queryVM.getFeaturedTasks(for: selectedFeature.type)
        }
    }
    
    private func setupUI(){
        titleLabel.text = queryVM.title
        dateHeaderLabel.text = queryVM.dateTitle
        navigationTitleLabel.text = queryVM.navigationTitle
        if selectedUIType == HomeUIType.CATEGORIES || selectedFeature.type == .Favourite || selectedFeature.type == .Month || selectedFeature.type == .Week{
            collectionViewHolderViewHeightConstraint.constant = 0
        }else{
            collectionViewHolderViewHeightConstraint.constant = 70
        }
        
        if queryVM.tasks.value.count > 0{
            UIHelper.hide(view: noTaskLabel)
            UIHelper.show(view: tableView)
        }else{
            UIHelper.show(view: noTaskLabel)
            UIHelper.hide(view: tableView)
        }
    }
    
    private func setObservable(){
        queryVM.tasks.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.setupUI()
            }).disposed(by: bag)
    }
    
    @IBAction func sortButtonOnTapped(_ sender: Any) {
        let sortAlertController = UIAlertController(title: "Sort Tasks", message: "Please select the sorting criteria.", preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "By Name", style: .default) { _ in
            if self.selectedUIType == HomeUIType.CATEGORIES{
                self.queryVM.getTaks(for: self.categoryName,isSortingEnabled: true,sortType: .BY_NAME)
            }else{
                self.queryVM.getFeaturedTasks(for: self.selectedFeature.type,isSortingEnabled: true,sortType: .BY_NAME)
            }
            
        }
        let dateAction = UIAlertAction(title: "By Date", style: .default) { _ in
            if self.selectedUIType == HomeUIType.CATEGORIES{
                self.queryVM.getTaks(for: self.categoryName,isSortingEnabled: true,sortType: .BY_DATE)
            }else{
                self.queryVM.getFeaturedTasks(for: self.selectedFeature.type,isSortingEnabled: true,sortType: .BY_DATE)
            }
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
        addTaskModalVC.addTaskVM = AddTaskViewModel(UIType: .CREATE)
        self.modalPresentationStyle = .currentContext
        self.present(addTaskModalVC, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tasksUpdated, object: nil)
    }
}

extension QueryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryVM.tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = queryVM.tasks.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.TaskTableViewCell.rawValue, for: indexPath) as! TaskTableViewCell
        cell.taskTableViewVM = TaskTableViewViewModel(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = queryVM.tasks.value[indexPath.row]
        let updateTaskVC = UIHelper.makeViewController(viewControllerName: .AddTaskVC) as! AddTaskViewController
        updateTaskVC.addTaskVM = AddTaskViewModel(UIType: .UPDATE)
        updateTaskVC.addTaskVM.currentTask = task
        self.present(updateTaskVC, animated: true, completion: nil)
    }
}

extension QueryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryVM.days.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = queryVM.days.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CalenderCollectionViewCell.rawValue, for: indexPath) as! CalenderCollectionViewCell
        cell.calenderCollectionViewVM = CalenderCollectionViewViewModel(day: day)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentDay = queryVM.days.value[indexPath.row]
        queryVM.getTasksForSpecificDate(dateString: currentDay.dateString)
        for day in queryVM.days.value{
            if day == currentDay{
                day.isSelected = true
            }else{
                day.isSelected = false
            }
        }
        collectionView.reloadData()
    }
}

extension QueryViewController{
    
    @objc func onTasksChanged(_ notification:Notification){
        setupData()
    }
}
