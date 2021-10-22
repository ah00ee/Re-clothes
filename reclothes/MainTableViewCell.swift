//
//  MainTableViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/10/22.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{

    

    @IBOutlet weak var labelWithHashTag: UILabel!
    @IBOutlet weak var mainCollectionViewCell: UICollectionView!
    var tmpItemName = ["구두", "아우터", "가방", "후드", "악세사리"]
    var tmpItemPrice = ["2000원", "4400원", "2300원", "3000원", "30000원"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainCollectionViewCell.delegate = self
        self.mainCollectionViewCell.dataSource = self
        
        let nibName = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        mainCollectionViewCell.register(nibName, forCellWithReuseIdentifier: "ItemCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionCell", for: indexPath) as! ItemCollectionViewCell
        
        
        cell.itemImage.image = nil
        cell.itemNameLabel.text = tmpItemName[indexPath.row]
        cell.itemPriceLabel.text = tmpItemPrice[indexPath.row]
        cell.itemPriceLabel.text! += "(1일기준)"
        
        return cell
    }
    
}
