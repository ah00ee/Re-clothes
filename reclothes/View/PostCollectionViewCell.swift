//
//  PostCollectionViewCell.swift
//  reclothes
//
//  Created by λΈμμ on 2021/12/02.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    
    override func prepareForReuse() {
        postImage.image = nil
        postLabel.text = nil
        postPrice.text = nil
    }
}
