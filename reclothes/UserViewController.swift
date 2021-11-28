//
//  UserViewController.swift
//  reclothes
//
//

import UIKit
import FirebaseDatabase
import KakaoSDKUser

class UserViewController: UIViewController{

    var ref: DatabaseReference!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "마이클로젯"
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                ref = Database.database().reference(withPath: "user")
                
                self.ref.child("\(String(describing: user?.id))").observe(.value) {snapshot in
                    let value = snapshot.value as! [String: AnyObject]
                    let nickname = value["nickname"] as! String
                    print(nickname)
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
        return 1 //temp
    }
    
    // 셀 지정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell() //temp
    }
    
    // 셀 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = (collectionView.bounds.width - 10)/2
        let height: CGFloat = width*1.7 + 30
        
        return CGSize(width: width, height: height)
    }
}
