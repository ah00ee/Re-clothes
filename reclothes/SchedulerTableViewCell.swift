//
//  SchedulerTableViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

class SchedulerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contents: UILabel! // 예약 일정 한 건
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
