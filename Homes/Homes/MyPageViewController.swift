//
//  MyPageViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = me()
        if user == nil {
            self.showLoginView()
        } else {
            self.hideLoginView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 

    @IBAction func loginBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        let email = emailTf.text
        let password = passwordTf.text
        
        ServiceClient.request(UserTask.login(email: email!, password: password!)).responseUserInfo(completionHandler: {(response) in
            switch response.result {
            case .success(let result):
                if let msg = result as? String {
                    SVProgressHUD.showError(withStatus: msg)
                } else {
                    let user = result as! UserModelProtocol
                    let userid = user.userId
                    if userid.isEmpty == false {
                        SVProgressHUD.dismiss()
                        self.hideLoginView()
                        Defaults[.email] = email
                        Defaults[.password] = password
                        Defaults[.userid] = user.userId
                        Defaults[.username] = user.username
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
    
    func doLogout() {
        SVProgressHUD.show()
        
        ServiceClient.request(UserTask.logout()).responseLogout(completionHandler: {(response) in
            switch response.result {
            case .success(let logout):
                print("logged out:" + (logout ? "true":"flase"))
                Defaults[.userid] = ""
                self.showLoginView()
                SVProgressHUD.dismiss()
                break
            case .failure:
                SVProgressHUD.showError(withStatus: "Failed")
                break
            }
        })
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        print("Register")
    }
    
    func showLoginView() {
        self.overlayView.isHidden = false
        var frame = self.overlayView.frame
        frame.origin.y = 0
        
        UIView.animate(withDuration: 0.5) {
            self.overlayView.frame = frame
        }
    }
    
    func hideLoginView() {
        self.view.endEditing(true)
        
        var frame = self.overlayView.frame
        frame.origin.y = self.view.bounds.size.height
        
        UIView.animate(withDuration: 0.5) {
            self.overlayView.frame = frame
            self.overlayView.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UITableViewCell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Logout"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.doLogout()
    }
    
}
