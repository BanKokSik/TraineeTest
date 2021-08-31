//
//  ImagesCollectionViewCell.swift
//  TraineeTest
//
//  Created by Nikita Chekmarev on 27.07.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class ImagesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.shadowRadius = 6
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        clipsToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "no-image-png-2")
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        imageView.af.cancelImageRequest()
        imageView.image = nil
    }
    
}
