//
//  ViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeaturedTableViewCell.self, forCellReuseIdentifier: "FeaturedTableViewCell")
        tableView.register(UINib(nibName: "TaskTypeTableViewCell", bundle: .main), forCellReuseIdentifier: UIConstant.Cell.TaskTypeTableViewCell.rawValue)
    }
    
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return homeVM.getCategories.count
        default:()
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell", for: indexPath) as! FeaturedTableViewCell
            return cell
        case 1:
            let category = homeVM.getCategories[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: UIConstant.Cell.TaskTypeTableViewCell.rawValue, for: indexPath) as! TaskTypeTableViewCell
            cell.categories = category
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
        
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .systemGray6
        } else {
            headerView.backgroundColor = .systemGray6Fallback
        }
        headerView.addSubview(myLabel)
        return headerView
    }
}

