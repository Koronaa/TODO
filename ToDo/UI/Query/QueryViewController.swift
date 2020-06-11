//
//  QueryViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tasksHeaderLabel: UILabel!
    @IBOutlet weak var noTaskLabel: SmallTitleLabel!
    
    let queryVM = QueryViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstant.Cell.TaskTableViewCell.rawValue)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CalenderCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: UIConstant.Cell.CalenderCollectionViewCell.rawValue)
        setupUI()
    }
    
    fileprivate func setupUI(){
        if queryVM.getTasks.count > 0{
            UIHelper.hide(view: noTaskLabel)
            UIHelper.show(view: tableView)
        }else{
            UIHelper.show(view: noTaskLabel)
            UIHelper.hide(view: tableView)
        }
        
    }
    
    @IBAction func backButtonOnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func newTaskButtonOnTapped(_ sender: Any) {
        let addTaskModalVC = UIHelper.makeViewController(viewControllerName: .AddTaskVC) as! AddTaskViewController
        self.modalPresentationStyle = .currentContext
        self.present(addTaskModalVC, animated: true, completion: nil)
    }
    
    
}

extension QueryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryVM.getTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = queryVM.getTasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.TaskTableViewCell.rawValue, for: indexPath) as! TaskTableViewCell
        cell.task = task
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension QueryViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryVM.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = queryVM.days[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstant.Cell.CalenderCollectionViewCell.rawValue, for: indexPath) as! CalenderCollectionViewCell
        cell.day = day
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentDay = queryVM.days[indexPath.row]
        for day in queryVM.days{
            if day == currentDay{
                day.isSelected = true
            }else{
                day.isSelected = false
            }
        }
        collectionView.reloadData()
    }
    
    
}
