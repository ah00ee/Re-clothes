//
//  LoginViewController.swift
//  reclothes
//
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import SQLite3
import Foundation

class LoginViewController: UIViewController {
    
    var db: OpaquePointer?
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var intro: UILabel!

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        /*
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
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
        */
        super.viewDidLoad()

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("reclothes.db")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("success to open ReclothesDB.db")
            
            //creating table
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS User (userID INTEGER PRIMARY KEY AUTOINCREMENT, nickname TEXT, email TEXT, gender INTEGER, birthday TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        print(fileURL)
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
                
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                let email = user?.kakaoAccount?.email ?? ""
                var gender = 0
                if user?.kakaoAccount?.gender?.rawValue == "female"{
                    gender = 1
                }
                let bday = user?.kakaoAccount?.birthday ?? ""
            
                //creating a statement
                var stmt: OpaquePointer?
                
                //the userInfo insert query
                let insertData = "INSERT INTO User(nickname, email, gender, birthday) values(?,?,?,?)"
                
                //preparing the query
                if sqlite3_prepare(db, insertData, -1, &stmt, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return
                }
                
                //binding the parameters
                if sqlite3_bind_text(stmt, 1, nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding nickname: \(errmsg)")
                    return
                }
                
                if sqlite3_bind_text(stmt, 2, email, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding email: \(errmsg)")
                    return
                }

                if sqlite3_bind_int(stmt, 3, Int32(gender)) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding gender: \(errmsg)")
                    return
                }
                    
                if sqlite3_bind_text(stmt, 4, bday, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding birthday: \(errmsg)")
                    return
                }
                
                //executing the query to insert values
                if sqlite3_step(stmt) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting hero: \(errmsg)")
                    return
                }
                
                print("INSERT SUCCEED")
                UserDefaults.standard.set(nickname, forKey: "userName")
            }
        }
    }
    
   
    @IBAction func loginButton(_ sender: Any) {
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard?.instantiateViewController(identifier: "MainViewController")else{
            return
        }
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        /*
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
        */
        
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
