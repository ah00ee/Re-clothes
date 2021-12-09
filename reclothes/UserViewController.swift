//
//  UserViewController.swift
//  reclothes
//
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import KakaoSDKUser
import FirebaseStorageUI

class UserViewController: UIViewController{
    var ref: DatabaseReference!
    var storageRef: StorageReference?
    var items: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "마이클로젯"
        //userName?.text = ""
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                ref = Database.database().reference().child("user")
                /*
                // User name 불러오기
                self.ref.child("\(String(describing: user?.id))").observeSingleEvent(of: .value, with: {snapshot in
                    let value = snapshot.value as? NSDictionary
                    let nickname = value?["nickname"] as? String ?? ""
                    
                    //self.userName?.text = nickname
                }){ error in
                    print(error.localizedDescription)
                }
                */
                // User item Data 불러오기
                ref.child("\(String(describing: user?.id))").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    let value = snapshot.value as? [String: AnyObject]
                    items = value!["itemID"] as! [String];()
                 
                    collectionView.delegate = self
                    collectionView.dataSource = self
                    collectionView.reloadData()
                });
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UserViewController: UICollectionViewDataSource,
                              UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var imgPath: String = "gs://re-clothes.appspot.com/"
        let storage = Storage.storage()
        
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PostCollectionViewCell

        ref = Database.database().reference().child("item")
        ref.child("\(items[indexPath.row])").getData(completion:  { error, snapshot in
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
                    postCell.postImage.image = image
                }
            }
            
            let title = value["title"] as! String
            if let label = postCell.postLabel {
                postCell.postLabel.text = title
            }
        });
        return postCell
    }

    // 셀 레이아웃
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = (collectionView.bounds.width - 10)/2
        let height: CGFloat = width*1.7 + 30
        
        return CGSize(width: width, height: height)
    }
}
