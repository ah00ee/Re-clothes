//
//  ItemCollectionViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

// 검색 결과로 보이는 아이템 콜렉션 뷰
class ItemCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tmpItemName = ["구두", "아우터", "가방", "후드", "악세사리", "구두", "아우터", "가방", "후드", "악세사리", "구두", "아우터", "가방", "후드", "악세사리"]
    var tmpItemPrice = ["2000원", "4400원", "2300원", "3000원", "30000원", "2000원", "4400원", "2300원", "3000원", "30000원", "2000원", "4400원", "2300원", "3000원", "30000원"]
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.gray.cgColor
        
        // 여기 가격 안보임, 셀 사이즈 조정 : 라인 간격도 
        cell.itemImage.image = nil
        cell.itemTitle.text = tmpItemName[indexPath.row]
        cell.itemPrice.text = tmpItemPrice[indexPath.row]
        cell.itemPrice.text! += "(1일기준)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = collectionView.frame.width
           let itemsPerRow: CGFloat = 3
           let widthPadding = sectionInsets.left * (itemsPerRow + 1)
           let cellWidth = (width - widthPadding) / itemsPerRow
           
           return CGSize(width: cellWidth, height: 220)
           
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return sectionInsets
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return sectionInsets.left
       }
}
