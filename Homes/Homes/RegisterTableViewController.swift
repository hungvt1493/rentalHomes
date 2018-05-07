//
//  RegisterTableViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/03/01.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyUserDefaults

class RegisterTableViewController: UITableViewController, UITextFieldDelegate {

    let titles :[String] = ["Email","Username","Password","Re-Password"]
    var values: [String] = ["","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        let doneBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = doneBarBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneBtnTapped(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
        let validate = validateInputValue()
        
        if validate {
            SVProgressHUD.show()
            ServiceClient.request(UserTask.regNewUser(email: values[0], username: values[1], password: values[2])).responseUserInfo(completionHandler: {(response) in
                switch response.result {
                case .success(let result):
                    if let msg = result as? String {
                        SVProgressHUD.showError(withStatus: msg)
                    } else {
                        let user = result as! UserModelProtocol
                        let userid = user.userId
                        if userid.isEmpty == false {
                            SVProgressHUD.dismiss()
                            
                            Defaults[.email] = user.email
                            Defaults[.password] = self.values[2]
                            Defaults[.userid] = user.userId
                            Defaults[.username] = user.username
                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            SVProgressHUD.showError(withStatus: "Login Failed")
                        }
                    }
                    break
                case .failure:
                    SVProgressHUD.showError(withStatus: "Failed")
                    break
                }
            })
        }
    }
    
    func validateInputValue() -> Bool {
        //check required value
        
        // validate password and re-password
        let pass = values[2]
        let repass = values[3]
        if pass != repass {
            alert(m: "Password and Re-Password are not the same")
            return false
        }
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentCellIdentifier = "TextFieldInputTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! TFInputTableViewCell
        cell.titleLbl.text = titles[indexPath.row]
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
//        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.showTagListView(false)
        
        return cell
    }
 

//    @objc func textFieldDidChange(_ textField: UITextField) {
//
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        values.remove(at: tag)
        values.insert(textField.text!, at: tag)
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
