//
//  PostViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/11/01.
//

import UIKit
import KakaoSDKUser
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {
    var ref: DatabaseReference!
    
    let imgPicker = UIImagePickerController()
    let storage = Storage.storage()

    var filePath = ""
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var hashtagTextView: UITextView!
    
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    
    // 이미지 추가 버튼 클릭시 뜨는 팝업창(photo, camera, cancle 버튼이 나옴)
    @IBAction func addImgBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Photo or Camera", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: UIAlertAction.Style.default, handler: {(action) in self.openLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: {(action) in self.openCamera()}))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
        hashtagTextView.layer.borderWidth = 0.5
        hashtagTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func openLibrary(){ // 사진보관함 오픈
        imgPicker.sourceType = .photoLibrary
        present(imgPicker ,animated: false, completion: nil)
    }
    
    @IBAction func postBtn(_ sender: UIButton){
        ref = Database.database().reference()

        let img = imgView.image
        var data = Data()
        data = img!.jpegData(compressionQuality: 0.8)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata: metaData){
            (metaData,error) in if let error = error {
                print(error)
            }
            else{
                print("업로드 성공")
                
                // itemDB에 item 추가
                let postID = self.ref.child("item").childByAutoId()
                postID.setValue(["title": self.itemTitle.text!, "price": Int(self.itemPrice.text!)!, "imgPath": self.filePath])
                
                // userDB에 itemID 추가
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
                            let value = snapshot.value as! [String: AnyObject]
                            var ids = [String]()
                            if value["itemID"] != nil{
                                ids = value["itemID"] as! [String]
                            }
                            ids.append(postID.key!)
                            ref.child("user/\(String(describing: user?.id))/itemID").setValue(ids)
                        });
                    }
                }
            }
        }
        dismiss(animated: false, completion: nil)
    }

    func openCamera(){ // 카메라 오픈
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imgPicker.sourceType = .camera
            present(imgPicker, animated: false, completion: nil)
        }
        else{ // 시뮬레이터로 카메라 동작 불가
            print("Camera is not available on simulator, plz check on the iPhone")
        }
    }
}

extension PostViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    // 이미지 경로를 가져와서 UIImageView에 띄우고 창 내림(dismiss)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgView.image = image
            print(info)
        }
        
        if let asset = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            filePath = asset.lastPathComponent
            print(filePath)
        }
        dismiss(animated: true, completion: nil)
    }
}
