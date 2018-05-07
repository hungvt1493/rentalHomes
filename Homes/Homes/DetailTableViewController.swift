//
//  DetailTableViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import Agrume
import SwiftyUserDefaults

class DetailTableViewController: UITableViewController, ImagesScrollTableViewCellDelegate {

    @IBOutlet weak var editButton: UIBarButtonItem!
    var data: RentalHome!
    var parseData:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "Detail"
        
        let currentUserId = me()!.userId
        if data.user.userId != currentUserId  {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.parseData = data.pasreDataToDict()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + parseData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let scrollCellIdentifier = "ImagesScrollTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: scrollCellIdentifier, for: indexPath) as! ImagesScrollTableViewCell
            cell.delegate = self
            cell.setContent(data.images)
            return cell
        } else {
            let contentCellIdentifier = "ContentTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! ContentTableViewCell
            cell.setData(parseData[indexPath.row-1])
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditHomeSegue" {
            let vc = segue.destination as! NewRentalHomeTableViewController
            vc.defaultData = self.data
        }
    }
    

    func imageUrls() -> [URL] {
        return data.images.map{$0.url}
    }
    
    //MARK: - Delegate
    func selectedImageAtIndex(_ index: NSInteger) {
        //https://github.com/JanGorman/Agrume
        let agrume = Agrume(imageUrls: self.imageUrls(), startIndex: index, backgroundBlurStyle: .light)
//        agrume.didScroll = { [unowned self] index in
//
//        }
        agrume.showFrom(self)
    }
    

}

