//
//  SearchResultViewController.swift
//  reclothes
//
//  Created by 노아영 on 2021/12/17.
//

import UIKit

class SearchResultViewController: UIViewController {
    var searchWord = ""
    
    var imgs: [String] = ["pants01", "pants06", "pants08", "pants09"]
    var titles: [String] = ["청바지", "반바지", "청바지2", "편한 바지"]
    var prices: [String] = ["4500원/일", "2300원/일", "5000원/일", "3000원/일"]
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // 검색어 전달받기
    func receiveWord(_ word: String){
        searchWord = word
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showdetail2"{
            if let target = segue.destination as? UINavigationController, let vc = target.topViewController as? DetailViewController {
                let cell = sender as! UICollectionViewCell
                let indexPath = self.collectionView.indexPath(for: cell)
        
                vc.receiveItemData(imgs[indexPath!.row], titles[indexPath!.row], prices[indexPath!.row])
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count // tmp
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCell", for: indexPath) as! SearchResultCollectionViewCell
        
        resultCell.itemImage.image = UIImage(named: imgs[indexPath.row])
        resultCell.itemTitle.text = titles[indexPath.row]
        resultCell.itemPrice.text = prices[indexPath.row]
        
        return resultCell
    }
    
    // 셀 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
