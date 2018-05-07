//
//  SearchViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    var currentPage: Int = 1
    var isGettingNewData: Bool = true
    
    var dataSource: [RentalHome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 280
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        currentPage = 1
        self.dataSource.removeAll()
        
        getData()
    }
    
    func getData() {
        self.isGettingNewData = true
        SVProgressHUD.show()
        ServiceClient.request(HomesTask.getAllHomes(page:currentPage)).responseGetHomes(completionHandler: { (response) in
            switch response.result {
            case .success(let homes):
                if homes.count > 0 {
                    self.dataSource.append(contentsOf: homes)
                    self.tableView.reloadData()
                } else {
                    self.currentPage -= 1
                    if self.currentPage == 0 {
                        self.currentPage = 1
                    }
                }
                self.isGettingNewData = false
                self.refreshControl.endRefreshing()
                SVProgressHUD.dismiss()
                break
            case .failure:
                print("get all Failed")
                self.isGettingNewData = false
                SVProgressHUD.showError(withStatus: "Failed")
                break
            }
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomesDetailSegue" {
            let selectedCell = sender as! UITableViewCell
            let vc = segue.destination as! DetailTableViewController
            vc.data = self.dataSource[selectedCell.tag]
        } else if segue.identifier == "AddNewRentalHomeSegue" {
//            let vc = segue.destination as! NewRentalHomeTableViewController
//            vc.isCreateNew = true
        }
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "HomeSearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? HomeSearchTableViewCell else {
            fatalError("The dequeued cell is not an instance of HomeSearchTableViewCell.")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.setData(self.dataSource[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Bottom Refresh
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if !isGettingNewData {
                    self.currentPage += 1
                    getData()
                }
            }
        }
    }
    
}
