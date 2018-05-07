//
//  ContentTableViewCell.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setData(_ data: NSDictionary) {
        let title = data.object(forKey: "title") as! String
        titleLbl.text = title
        
        let value = data.object(forKey: "value")
        print(value!)
        let type = data.object(forKey: "type") as! DataType
        if type == .text {
            detailLbl.text = value as? String
        } else if type == .number {
            detailLbl.text = "\(value ?? 0)"
        } else if type == .date {
            detailLbl.text = timeStringFromTimeStamp(value as! Double)
        }
    }
    
}
