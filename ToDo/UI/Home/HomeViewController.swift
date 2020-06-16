//
//  ViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit
import RxSwift

enum HomeUIType{
    case FEATURED
    case CATEGORIES
}

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: WelcomeLabel!
    
    var homeVM = HomeViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupUI()
        setObservables()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onCategoriesChanged(_:)), name: .categoriesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTasksChanged(_:)), name: .tasksUpdated, object: nil)
    }
    
    func loadData() {
        homeVM.getTodysTaskCount()
        homeVM.getcategoryInfo()
        homeVM.loadData()
    }
    
    func setObservables(){
        homeVM.categoryInfo
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: bag)
    }
    
    
    private func setupUI(){
        welcomeLabel.text = homeVM.title
        self.tableView.register(FeaturedTableViewCell.self, forCellReuseIdentifier: UIConstant.Cell.FeaturedTableViewCell.rawValue)
        self.tableView.register(UINib(nibName: "TaskTypeTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstant.Cell.TaskTypeTableViewCell.rawValue)
    }
    
    @IBAction func addButtonOnTapped(_ sender: Any) {
        let addTaskModalVC = UIHelper.makeViewController(viewControllerName: .AddTaskVC) as! AddTaskViewController
        addTaskModalVC.addTaskVM = AddTaskViewModel(UIType: .CREATE)
        self.modalPresentationStyle = .currentContext
        self.present(addTaskModalVC, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .categoriesUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .tasksUpdated, object: nil)
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return homeVM.categoryInfo.value.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell", for: indexPath) as! FeaturedTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let categoryInfo = homeVM.categoryInfo.value[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.TaskTypeTableViewCell.rawValue, for: indexPath) as! TaskTypeTableViewCell
            cell.taskTypeVM = TaskTypeViewModel(categoryInfo: categoryInfo)
            return cell
        default:()
        return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180.0
        case 1:
            return 60.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Featured"
        case 1:
            return "Categories"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = TableHeaderLabel()
        myLabel.frame = CGRect(x: 15, y: -5, width: 320, height: 25)
        myLabel.backgroundColor = .clear
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        let headerView = UIView()
        headerView.backgroundColor = .TODOYellow
        headerView.addSubview(myLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let queryVC = UIHelper.makeViewController(viewControllerName: .QueryVC) as! QueryViewController
            queryVC.selectedUIType = .CATEGORIES
            queryVC.categoryName = homeVM.categoryInfo.value[indexPath.row].name
            self.navigationController?.pushViewController(queryVC, animated: true)
        }
    }
}

extension HomeViewController:FeaturedCollectionViewDelegate{
    
    func didSelectFeatured(for featured: Featured) {
        let queryVC = UIHelper.makeViewController(viewControllerName: .QueryVC) as! QueryViewController
        queryVC.selectedUIType = .FEATURED
        queryVC.selectedFeature = featured
        self.navigationController?.pushViewController(queryVC, animated: true)
    }
}

//MARK: Notification
extension HomeViewController{
    @objc func onCategoriesChanged(_ notification:Notification){
        loadData()
    }
    
    @objc func onTasksChanged(_ notification:Notification){
        loadData()
    }
}

