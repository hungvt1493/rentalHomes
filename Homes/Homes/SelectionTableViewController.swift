//
//  SelectionTableViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/27.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

enum SelectionType {
    case City
    case State
    case Stress
}

protocol SelectionTableViewControllerDelegate: class {
    func didSelectValueAtIndex(_ obj: Any, _ type:SelectionType)
}

class SelectionTableViewController: UITableViewController {
    
    weak var delegate: SelectionTableViewControllerDelegate?
    
    public var data:[Any] = []
    public var selectionType:SelectionType = SelectionType.City
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        // Configure the cell...
        switch selectionType {
        case .City:
            let cityObj = data[indexPath.row] as! CityModel
            cell.textLabel?.text = cityObj.name
            break
        case .State:
            let stateObj = data[indexPath.row] as! StateModel
            cell.textLabel?.text = stateObj.nameWithType
            break
        case .Stress:
            let stressObj = data[indexPath.row] as! StressModel
            cell.textLabel?.text = stressObj.nameWithType
            break
        default:
            //default
            cell.textLabel?.text = ""
            break
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        switch selectionType {
        case .City:
            let cityObj = data[indexPath.row]
            self.delegate?.didSelectValueAtIndex(cityObj, .City)
            break
        case .State:
            let stateObj = data[indexPath.row]
            self.delegate?.didSelectValueAtIndex(stateObj, .State)
            break
        case .Stress:
            let stressObj = data[indexPath.row]
            self.delegate?.didSelectValueAtIndex(stressObj, .Stress)
            break
        default:
            //default
            break
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
