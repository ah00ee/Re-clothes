//
//  MainTableViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var tmpItemName = ["구두", "아우터", "가방", "후드", "악세사리"]
    var tmpItemPrice = ["2000원", "4400원", "2300원", "3000원", "30000원"]

    @IBOutlet weak var labelWithHashtag: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        
        cell.itemImage.image = nil
        cell.itemTitle.text = tmpItemName[indexPath.row]
        cell.itemPrice.text = tmpItemPrice[indexPath.row]
        cell.itemPrice.text! += "(1일기준)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width:100, height: 200)
        return cellSize
    }
}
