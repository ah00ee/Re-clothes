//
//  ItemCollectionViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit

// 검색 결과로 보이는 아이템 콜렉션 뷰
class ItemCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imgName = ["dress01", "dress02", "dress03", "dress04", "dress05", "dress06", "dress07", "dress08", "dress09", "dress10", "dress11", "dress12", "dress13", "dress14"]
    var tmpItemName = ["자켓 투피스", "수트", "여성 정장", "체크패턴 수트", "버튼 원피스", "트위드 투피스", "원피스", "레이스 핀턱 미니원피스", "리사 기모 후드", "스커트", "롱스커트", "미디움 스커트", "플로럴 스커트", "포인트 스커트"]
    var tmpItemPrice = ["2000원", "4400원", "2300원", "3000원", "30000원", "2000원", "4400원", "2300원", "3000원", "30000원", "2000원", "4400원", "2300원", "3000원", "30000원"]
    let sectionInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.layer.borderWidth = 0.7
        cell.layer.borderColor = UIColor.gray.cgColor
        
        // 여기 가격 안보임, 셀 사이즈 조정 : 라인 간격도 
        cell.itemImage.image = UIImage(named: imgName[indexPath.row])
        cell.itemTitle.text = tmpItemName[indexPath.row]
        cell.itemPrice.text = tmpItemPrice[indexPath.row]
        cell.itemPrice.text! += "/일"
        
        return cell
    }

    // 코드가 안먹고 스토리보드에서 커스텀된 것 같은데 나중에 테스팅해보고 수정

    // 아래는 셀들의 사이즈, 간격을 조정해주는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    // 이거는 인스타처럼 셀이 세개씩 보이게 해주는 코드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("enter here")
        let width = (view.frame.width - 4) / 3
            
        return CGSize(width: width, height: 160)
    }
}
