//
//  MainTableViewCell.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var row = 0
    var imgName = [["top01", "outer01", "etc01", "pants01", "dress14"], ["top04", "outer06", "etc04", "pants04", "dress02"], ["top09", "outer04", "etc07", "pants06", "dress07"]]
    var tmpItemName = [["가디건", "Military 패딩(blue)", "Saint Laurent cross", "부츠컷 청바지", "롱 스커트"], ["리본 스트라이프탑", "베이지 무스탕", "어그부츠", "골덴팬츠", "수트"], ["니트", "자켓", "써지컬 팬던트", "숏팬츠", "원피스"]]
    var tmpItemPrice = [["2000원", "4400원", "2300원", "3000원", "30000원"], ["2000원", "4400원", "2300원", "3000원", "30000원"], ["2000원", "4400원", "2300원", "3000원", "30000원"]]

    @IBOutlet weak var labelWithHashtag: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.itemImage.image = UIImage(named: imgName[collectionView.tag][indexPath.row])
        cell.itemTitle.text = tmpItemName[collectionView.tag][indexPath.row]
        cell.itemPrice.text = tmpItemPrice[collectionView.tag][indexPath.row]
        cell.itemPrice.text! += "/일"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width:120, height: 180)
        return cellSize
    }
}
