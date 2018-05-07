//
//  HomeSearchTableViewCell.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/14.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

class HomeSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImgView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var shortDescLbl: UILabel!
    @IBOutlet weak var imgsScrollView: UIScrollView!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        for imgView in imgsScrollView.subviews {
            imgView.removeFromSuperview()
        }
    }

    public func setData(_ rentalHome: RentalHomeModelProtocol) {
        priceLbl.text = rentalHome.title
        shortDescLbl.text = timeStringFromTimeStamp(rentalHome.createdDate)
        
        let adds = [rentalHome.add1!,rentalHome.add2!,rentalHome.add3!]
        addressLbl.text =  adds.joined(separator: ", ") //rentalHome.status
        
        if rentalHome.images.count > 0 {
            createScrollContent(rentalHome.images)
        }
    }
    
    func createScrollContent(_ images:[ImageModel]) {
        for imgView in imgsScrollView.subviews {
            imgView.removeFromSuperview()
        }
        
        if imgsScrollView.subviews.count == 0 {
            var x:CGFloat = 0.0
            let scrollHeight = imgsScrollView.frame.size.height
            for imageObj in images {
                let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: scrollHeight, height: scrollHeight))
                imageView.autoresizesSubviews = false
                imageView.downloadedFrom(url: imageObj.url)
                imgsScrollView.addSubview(imageView)
//                imgsScrollView.autoresizesSubviews = false
                x += (scrollHeight+1)
            }
            imgsScrollView.contentSize = CGSize(width: x, height: scrollHeight)
        }
    }
}
