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

class UserViewController: UIViewController{
    var ref: DatabaseReference!
    var items: [String] = []
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "마이클로젯"

        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                ref = Database.database().reference().child("user")
                
                self.ref.child("\(String(describing: user?.id))").observe(.value) {snapshot in
                    let value = snapshot.value as! [String: AnyObject]
                    let nickname = value["nickname"] as! String
  
                    self.userName.text = nickname
                }
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
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                ref.child("user/\(String(describing: user?.id))").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    let value = snapshot.value as? [String: AnyObject]
                    items = value!["itemID"] as! [String];()
                });
            }
        }
        print("nums")
        //items.count)
        return items.count
    }
    
    // 셀 지정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imgStorage = Storage.storage()
        var imgPath: String = ""
        ref.child("item/\(items[indexPath.row])").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            let value = snapshot.value as! [String: AnyObject]
            imgPath = value["imgPath"] as! String
        });
        
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        print(imgPath)
        imgStorage.reference(forURL: "gs://re-clothes.appspot.com/\(imgPath)").downloadURL(completion: { url, error in
            if error == nil{
                print(error)
            }
            else{
                let data = NSData(contentsOf: url!)
                postCell.postImage.image = UIImage(data: data! as Data)
            }
        })
        print("great")
        return postCell
    }
    
    // 셀 레이아웃
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = (collectionView.bounds.width - 10)/2
        let height: CGFloat = width*1.7 + 30
        
        return CGSize(width: width, height: height)
    }
     */
}
