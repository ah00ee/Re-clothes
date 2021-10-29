//
//  LoginViewController.swift
//  reclothes
//
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var intro: UILabel!
    
    let userRealm = try! Realm()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        if (AuthApi.hasToken()) {
            print("view load// has token")
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    print("but error")
                    // handle server error here.
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    //MainViewController.swift로 이동
                    print("available")
                    self.present(mainVC, animated: true)
                }
            }
        }
        
        super.viewDidLoad()
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
                
                let userInfo = UserInfo()
                
                userInfo.nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                userInfo.email = user?.kakaoAccount?.email ?? ""
                userInfo.gender = user?.kakaoAccount?.gender?.rawValue ?? Gender.Male.rawValue
                userInfo.bday = user?.kakaoAccount?.birthday ?? ""
                
                try! self.userRealm.write {
                    userRealm.add(userInfo)
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
        
        // 토큰 있을 시
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    print("but error")
                    // handle server error here.
                }
                else {
                    //로그인 성공
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    
                    //로그인 창 열지 않고** 바로 메인으로 이동
                    self.present(mainVC, animated: true)
                }
            }
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
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
