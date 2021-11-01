//
//  PostViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/11/01.
//

import UIKit
import SwiftUI

class PostViewController: UIViewController {
    
    let imgPicker = UIImagePickerController()
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func addImgBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "사진 불러오기", message: "갤러리 또는 카메라 선택", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "갤러리", style: UIAlertAction.Style.default, handler: {(action) in self.openLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "카메라", style: UIAlertAction.Style.default, handler: {(action) in self.openCamera()}))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
    }
    
    func openLibrary(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker ,animated: false, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
        imgPicker.sourceType = .camera
        present(imgPicker, animated: false, completion: nil)
        }else{ // 시뮬레이터로 카메라 동작 불가
            print("Camera is not available on simulator, plz check on the iPhone")
        }
    }
}

extension PostViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("hi")
        print(info)
        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        {
//            imageView.image = image
//            print(info)
//
//        }
//        dismiss(animated: true, completion: nil)
      
    }
}
