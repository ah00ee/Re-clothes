//
//  PostViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/11/01.
//

import UIKit
import FirebaseStorage

class PostViewController: UIViewController {
    
    let imgPicker = UIImagePickerController()
    
    let imgStorage = Storage.storage()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var hashtagTextView: UITextView!
    
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
    
    @IBAction func postBtn(_ sender: UIButton) {
        var img = imgView.image
        var data = Data()
        data = img!.jpegData(compressionQuality: 0.8)!
        
        let filePath = "test"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        imgStorage.reference().child(filePath).putData(data, metadata: metaData){
            (metaData,error) in if let error = error {
                print(error)
            }
            else{
                print("업로드 성공")
            }
        }
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
        dismiss(animated: true, completion: nil)
      
    }
}
