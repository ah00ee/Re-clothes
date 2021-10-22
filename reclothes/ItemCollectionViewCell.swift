//
//  ItemCollectionViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/10/22.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    var data: [String:Any]?
    var catecory: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    // 재사용되는 셀의 속성을 초기화해주는 부분
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImage.image = nil
        itemNameLabel.text = nil
        itemPriceLabel.text = nil
        
        // UIActivityIndicator는 로딩띄워주는 컴포넌트
//        activityIndicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
