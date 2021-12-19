//
//  DetailViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/11/30.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class DetailViewController: UIViewController {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var hashtagCollection: UICollectionView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var sharerImg: UIImageView!
    @IBOutlet weak var reserveBtn: UIButton!
    
    var tmpImage: UIImage!
    var tmpTitle: String = ""
    var tmpPrice: String = ""

    var ref: DatabaseReference!
    var storage: StorageReference!
    var receivedItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        itemImage.layer.borderColor = UIColor.lightGray.cgColor
        itemImage.layer.borderWidth = 0.7
        profileView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.layer.borderWidth = 0.7
        
        reserveBtn.layer.cornerRadius = 20
        
        itemImage.image = tmpImage
        itemTitle.text = tmpTitle
        itemPrice.text = tmpPrice
    }
   
    // Item 불러오기(user)
    func receiveItem(_ item: String){
        receivedItem = item
        var imgPath: String = "gs://re-clothes.appspot.com/"
        let storage = Storage.storage()

        ref = Database.database().reference().child("item")
        ref.child(item).getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            let value = snapshot.value as! [String: AnyObject]
            let path = value["imgPath"] as! String
            imgPath.append(path)
            
            // storage에서 이미지 불러오기
            storage.reference(forURL: imgPath).downloadURL{ url, error in
                if let error = error {
                    print(error)
                }
                else{
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.itemImage.image = image
                }
            }
            let title = value["title"] as! String
            let price = value["price"] as! Int
            
            self.itemTitle.text = title
            self.itemPrice.text = String(price) + "원/일"
        });
    }
    
    // 검색 결과 셀에서 데이터 불러오기
    func receiveItemData(_ img: String, _ title: String, _ price: String){
        tmpImage = UIImage(named: img)
        tmpTitle = title
        tmpPrice = price
    }

    // TODO: description 추가
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "reserveItem"{
            if let vc = segue.destination as? ReservationViewController {
                vc.receiveItemFromDVC(receivedItem)
            }
        }
    }
}
