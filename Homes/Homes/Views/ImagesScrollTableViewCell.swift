//
//  ImagesScrollTableViewCell.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

protocol ImagesScrollTableViewCellDelegate: class {
    func selectedImageAtIndex(_ index: NSInteger)
}

class ImagesScrollTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: ImagesScrollTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setContent(_ images: [ImageModel]) {
        
        for imgView in scrollView.subviews {
            imgView.removeFromSuperview()
        }
        
        if scrollView.subviews.count == 0 {
            var x:CGFloat = 0.0
            var i = 0
            
            let screenWidth = UIScreen.main.bounds.size.width
            for imageObj in images {
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                
                let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: screenWidth, height: scrollView.bounds.size.height))
                imageView.autoresizesSubviews = false
                imageView.downloadedFrom(url: imageObj.url)
                imageView.addGestureRecognizer(tap)
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                
                scrollView.addSubview(imageView)
                x += (screenWidth+1)
                i += 1
            }
            scrollView.contentSize = CGSize(width: x, height: scrollView.bounds.size.height)
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let imageView = gesture.view as! UIImageView
        self.delegate?.selectedImageAtIndex(imageView.tag)
    }
}
