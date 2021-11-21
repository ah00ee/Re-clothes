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
            self.present(mainVC, animated: true)
        }
    }
    
    func saveUserInfo(){
        // save userinfo
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print(error)
            }
            else{
                //do something
                _ = user
                /*
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                let email = user?.kakaoAccount?.email ?? ""
                var gender = 0
                if user?.kakaoAccount?.gender?.rawValue == "female"{
                    gender = 1
                }
                let bday = user?.kakaoAccount?.birthday ?? ""
                */
                
                // id: user?.kakaoAccount?.email, pw: user?.id
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))") { fuser, error in
                    if let error = error {
                        print(error)
                        print("이미 가입된 회원입니다!")
                        Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email)!, password: "\(String(describing: user?.id))", completion: nil)
                    } else {
                        print("회원가입이 완료되었습니다.")
                    }
                }
            }
        }
    }
   
    @IBAction func loginButton(_ sender: Any) {
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen

        // auto signin
        if Auth.auth().currentUser?.uid != nil {
            self.present(mainVC, animated: true)
        }
        
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
                    self.present(mainVC, animated: true)
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
                    self.present(mainVC, animated: true)
                }
            }
        }
    }
}
