//
//  LikesTableViewCell.swift
//  reclothes
//
//  Created by 노아영 on 2021/12/16.
//

import UIKit

class LikesTableViewCell: UITableViewCell {
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
