
//
//  ItemCollectionViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func prepareForReuse() {
        self.itemImage.image = nil
        self.itemTitle.text = nil
        self.itemPrice.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override var isSelected: Bool {
        didSet{
            if isSelected {
                itemTitle.textColor = .lightGray
                itemPrice.textColor = .lightGray
            }
        }
    }
}
