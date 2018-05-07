//
//  ImageContentView.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

class ImageContentView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayBtn: UIButton!
    public var deleteMode:Bool = true
    public var index: Int!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func createImageContentView() -> ImageContentView {
        let myClassNib = UINib(nibName: "ImageContentView", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! ImageContentView
    }
    
    public func setFrame(frame: CGRect) {
        self.frame = frame
    }
    
    @IBAction func overlayBtnTapped(_ sender: Any) {
        
        if deleteMode {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeletePhoto"), object: nil, userInfo: ["index": index])
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNewPhoto"), object: nil)
        }
    }
    
}
