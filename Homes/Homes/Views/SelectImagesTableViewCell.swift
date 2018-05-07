//
//  SelectImagesTableViewCell.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

class SelectImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func layoutScrollview(_ images: [UIImage]) {
        for subView in scrollView.subviews {
            subView.removeFromSuperview()
        }
        
        var x:CGFloat = 0.0
        var width: CGFloat = 95.0
        
        if images.count == 0 {
            width = 150
        }
        
        let imgContentView = ImageContentView.createImageContentView()
        imgContentView.setFrame(frame:CGRect(x: x, y: 0, width: width, height: 95))
        imgContentView.overlayBtn.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        imgContentView.deleteMode = false
        
        scrollView.addSubview(imgContentView)
        
        x += (width + 1)
        
        var index = 0
        for image in images {
            let imageContentView = ImageContentView.createImageContentView()
            imageContentView.setFrame(frame:CGRect(x: x, y: 0, width: 95, height: 95))
            imageContentView.imageView.image = image
            imageContentView.deleteMode = true
            imageContentView.index = index
            
            scrollView.addSubview(imageContentView)
            x += 96
            index += 1
        }
        
        scrollView.contentSize = CGSize(width: x, height: 95)
    }
}
