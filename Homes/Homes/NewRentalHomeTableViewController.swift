//
//  NewRentalHomeTableViewController.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImagePicker //https://github.com/hyperoslo/ImagePicker
import SwiftyPickerPopover

class NewRentalHomeTableViewController: UITableViewController, ImagePickerDelegate, UITextFieldDelegate, UITextViewDelegate, SelectionTableViewControllerDelegate {
    
    let photoCellIndex = 2

    public var defaultData: RentalHome!
    
    let titles:[String] = ["Title", "Description", "Add1", "Add2", "Add3", "Type", "Price", "Select Photos"]
    var selectedImages:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let rightBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(createOrEditHome(_:)))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        if defaultData == nil {
            
            defaultData = RentalHome(homeId: "", user: me()!, title: "", createdDate: Date().timeIntervalSince1970, status: "", desc: "", rentalType: 0, price: 0, images: [], add1: "", add2: "", add3: "", code1: -1, code2: -1, code3: -1)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewPhotoNotification(_:)), name: NSNotification.Name(rawValue: "AddNewPhoto"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhotoNotification(_:)), name: NSNotification.Name(rawValue: "DeletePhoto"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func createOrEditHome(_ sender: Any?) {
        self.view.endEditing(true)
        
        if defaultData.homeId == "" {
            //create
            var success = 0
            var failed = 0
            SVProgressHUD.show()
            ServiceClient.request(HomesTask.createNew(title: defaultData.title, desc: defaultData.desc!, rentalType: defaultData.rentalType!, price: defaultData.price!, add1: defaultData.add1!, add2: defaultData.add2!, add3: defaultData.add3!, code1: defaultData.code1, code2: defaultData.code2, code3: defaultData.code3)).responseCreateNewHome(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    if self.selectedImages.count == 0 {
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        let homeId = value.0
                        for img in self.selectedImages {
                            let imageData = UIImagePNGRepresentation(img) ?? Data()
                            ServiceClient.uploadFile(file: imageData, toHomeId: homeId,urlRequest: HomesTask.uploadFile(), completion: { (error, fileId) in
                                if (fileId ?? "").isEmpty {
                                    failed += 1
                                    print("failed:" + "\(failed)")
                                } else {
                                    success += 1
                                    print("success:" + "\(success)")
                                }
                                let status = "Uploaded: " + "\(success)" + " Failed: " + "\(failed)"
                                SVProgressHUD.show(withStatus: status)
                                if (failed+success) == self.selectedImages.count {
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            })
                        }
                    }
                    
                    break
                case .failure:
                    print("create new failed")
                    SVProgressHUD.dismiss()
                    break
                }
            })
        } else {
            //edit
        }
    }
    
    @objc func addNewPhotoNotification(_ notification: NSNotification) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func deletePhotoNotification(_ notification: NSNotification) {
        let index = notification.userInfo?.first?.value as! Int
        selectedImages.remove(at: index)
        
        let indexPath = IndexPath(item: (titles.count-1), section: 0)
        let photoCell = self.tableView.cellForRow(at: indexPath) as! SelectImagesTableViewCell
        photoCell.layoutScrollview(selectedImages)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            let contentCellIdentifier = "TextViewInputTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! TVInputTableViewCell
            cell.titleLbl.text = titles[indexPath.row]
            cell.textView.tag = indexPath.row
            cell.textView.delegate = self
            cell.textView.text = defaultData.desc
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        case 2://city
            let contentCellIdentifier = "SelectionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! SelectionTableViewCell
            cell.titleLbl.text = titles[indexPath.row]
            cell.valueLbl.text = defaultData.add1!

            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        case 3://state
            let contentCellIdentifier = "SelectionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! SelectionTableViewCell
            cell.titleLbl.text = titles[indexPath.row]
            cell.valueLbl.text = defaultData.add2
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        case 4:
            let contentCellIdentifier = "SelectionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! SelectionTableViewCell
            cell.titleLbl.text = titles[indexPath.row]
            cell.valueLbl.text = defaultData.add3!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        case (titles.count-1):
            let contentCellIdentifier = "SelectImagesTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! SelectImagesTableViewCell
            cell.layoutScrollview(selectedImages)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        default:
            let contentCellIdentifier = "TextFieldInputTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath) as! TFInputTableViewCell
            cell.titleLbl.text = titles[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if indexPath.row == 2 {
                cell.showTagListView(true)
            } else {
                cell.showTagListView(false)
            }
            
            if indexPath.row == 0 {
                cell.textField.text = defaultData.title
            } else if indexPath.row == 5 {
                cell.textField.text = String(describing: defaultData.rentalType!)
            } else if indexPath.row == 6 {
                cell.textField.text = String(describing: defaultData.price!)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
//            let cell = tableView.cellForRow(at: indexPath)
            
            let selectVC = SelectionTableViewController()
            switch indexPath.row {
                case 2:
                    selectVC.data = LocationTask.getCityList()
                    selectVC.selectionType = .City
                    break
                case 3:
                    selectVC.data = LocationTask.getStateList(filterParrentCode: defaultData.code1!)
                    selectVC.selectionType = .State
                    break
                case 4:
                    selectVC.data = LocationTask.getStressList(filterParrentCode: defaultData.code2!)
                    selectVC.selectionType = .Stress
                    break
            default:
                //do nothing
                break
            }
            selectVC.delegate = self
            navigationController?.pushViewController(selectVC, animated: true)
        }
    }
    
    //MARK: SelectionTableViewControllerDelegate
    func didSelectValueAtIndex(_ obj: Any, _ type:SelectionType) {
        
        switch type {
        case .City:
            let indexPath1 = IndexPath.init(row: 2, section: 0)
            let indexPath2 = IndexPath.init(row: 3, section: 0)
            let indexPath3 = IndexPath.init(row: 4, section: 0)
            
            defaultData.add1 = (obj as? CityModel)?.name
            defaultData.code1 = (obj as? CityModel)?.code
            
            defaultData.add2 = ""
            defaultData.code2 = -1
            
            defaultData.add3 = ""
            defaultData.code3 = -1
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath1,indexPath2,indexPath3], with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            break
        case .State:
            let indexPath1 = IndexPath.init(row: 3, section: 0)
            let indexPath2 = IndexPath.init(row: 4, section: 0)
            
            defaultData.add2 = (obj as? StateModel)?.name
            defaultData.code2 = (obj as? StateModel)?.code
            
            defaultData.add3 = ""
            defaultData.code3 = -1
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath1,indexPath2], with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            break
        case .Stress:
            let indexPath = IndexPath.init(row: 4, section: 0)
            defaultData.add3 = (obj as? StressModel)?.name
            defaultData.code3 = (obj as? StressModel)?.code
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.tableView.endUpdates()
            break
        default:

            break
        }
        
        
    }
    
    // MARK: ImagePickerDelegate

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        selectedImages.append(contentsOf: images)
        imagePicker.dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    // MARK: TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text!
        if text != "" {
            fillValueToObject(text: text, tag: textField.tag)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 2 {
//            getListOfLocationTags(textField.text!)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text!
        fillValueToObject(text: text, tag: textView.tag)
    }
    
    func fillValueToObject(text: String, tag: Int) {
        switch tag {
        case 0:
            defaultData.title = text
        case 1:
            defaultData.desc = text
        case 2:
            defaultData.add1 = text
        case 3:
            defaultData.add2 = text
        case 4:
            defaultData.add3 = text
//            var textAfterTrim = text.trimmingCharacters(in: .whitespaces)
//            let lastChar = textAfterTrim[textAfterTrim.index(before: textAfterTrim.endIndex)]
//            if lastChar == "," {
//                textAfterTrim = String(textAfterTrim.dropLast())
//            }
//            print("After trim " + textAfterTrim)
//            defaultData.address = textAfterTrim
        case 3:
            if text == "" {
                defaultData.rentalType = 0
            } else {
                defaultData.rentalType = Int(text)!
            }
        case 4:
            if text == "" {
                defaultData.price = 0
            } else {
                defaultData.price = Int(text)!
            }
        default:
            print(text)
        }
    }
    
    // MARK: API
    func getListOfLocationTags(_ text: String) {
        let inputStringArr = text.components(separatedBy: ",")
        var searchText = inputStringArr.last
        searchText = searchText?.trimmingCharacters(in: .whitespaces)
        
        if searchText != "" {
            print("Search: " + searchText!)
            
            ServiceClient.request(HomesTask.getLocationTags(searchText: searchText!)).responseGetHomeTags(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let indexPath = IndexPath(row: 2, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! TFInputTableViewCell
                    cell.reloadTags(value)
                    break
                case .failure:
                    print("Cannot get tags")
                    break
                }
            })
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
