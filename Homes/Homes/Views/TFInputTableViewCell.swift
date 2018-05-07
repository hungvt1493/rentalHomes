//
//  TFInputTableViewCell.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import TagListView

class TFInputTableViewCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagListViewHeighContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        tagListView.alignment = .left // possible values are .Left, .Center, and .Right
        tagListView.delegate = self
        tagListView.tagBackgroundColor = UIColor.lightGray
        tagListView.tagSelectedBackgroundColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showTagListView(_ show: Bool) {
        tagListView.isHidden = !show
        self.tagListViewHeighContraint.constant = (show ? 40 : 0)
    }
    
    func reloadTags(_ tagsList: [String]) {
        tagListView.removeAllTags()
        tagListView.addTags(tagsList)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        autocompleteInput(title)
        tagListView.removeAllTags()
    }
    
    func autocompleteInput(_ textToReplace: String) {
        let text = self.textField.text
        
        if !(text?.isEmpty)! {
            
            let lowercaseText = text?.lowercased().trimmingCharacters(in: .whitespaces)
            let lowerReplaceText = textToReplace.lowercased().trimmingCharacters(in: .whitespaces)
            
            if lowerReplaceText.hasPrefix(lowercaseText!) {
                self.textField.text = textToReplace + ", "
            } else {
                var subStringArr = text?.components(separatedBy: ",")
                if subStringArr?.count == 0 {
                    self.textField.text = textToReplace + ", "
                } else {
                    subStringArr?.removeLast()
                    subStringArr?.append(" " + textToReplace + ", ")
                    let fullString = subStringArr?.joined(separator: ",")
                    self.textField.text = fullString
                }

            }
        }
    }
}
