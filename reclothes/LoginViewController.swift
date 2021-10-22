//
//  ViewController.swift
//  reclothes
//
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var reclothes_logo: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    
    let userRealm = try! Realm()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    // handle server error here.
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    //MainViewController.swift로 이동
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
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    // login succeed.

                    //do something
                    _ = oauthToken
                    
                    self.saveUserInfo()
                }
            }
        }
        else{
            // no KakaoTalk here.
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        // 로그인 성공

                        //do somethingn
                        _ = oauthToken
                        
                        self.saveUserInfo()
                    }
                }
        }
        self.present(mainVC, animated: true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
