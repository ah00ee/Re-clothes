//
//  LoginViewController.swift
//  reclothes
//
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import Foundation
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var intro: UILabel!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        // auto signin
        if Auth.auth().currentUser?.uid != nil {
            self.present(mainVC, animated: true, completion: nil)
        }
        loginLabel.textAlignment = .center
    }
    
    func saveUserInfo(){
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        guard let popupVC = storyboard?.instantiateViewController(identifier: "PopUpViewController")else{
            return
        }
        popupVC.modalPresentationStyle = .overCurrentContext
        
        // save userinfo
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print(error)
            }
            else{
                //do something
                _ = user
                
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                let email = user?.kakaoAccount?.email ?? ""
                var gender = 0
                if user?.kakaoAccount?.gender?.rawValue == "female"{
                    gender = 1
                }
                let bday = user?.kakaoAccount?.birthday ?? ""
                var itemID = [String]()
                
                // id: user?.kakaoAccount?.email, pw: user?.id
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { fuser, error in
                    if let error = error {
                        print(error)
                        print("이미 가입된 회원입니다!")
                        Auth.auth().signIn(withEmail: email, password: "\(String(describing: user?.id))", completion: nil)
                        present(mainVC, animated: true, completion: nil)
                    } else {
                        ref = Database.database().reference().child("user")
                        self.ref.child("\(String(describing: user?.id))").setValue(["nickname": nickname, "email": email, "gender": gender, "bday": bday, "itemID": itemID])
                        print("회원가입이 완료되었습니다.")
                        present(mainVC, animated: true, completion: nil)
                        mainVC.present(popupVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
   
    @IBAction func loginButton(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("kakaotalk here")
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    //do something
                    _ = oauthToken
      
                    self.saveUserInfo()
                }
            }
        }
        else{
            // no KakaoTalk here.
            print("no kakaotalk here")
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    //do something
                    _ = oauthToken
                    
                    self.saveUserInfo()
                }
            }
        }
    }
}
