//
//  UserViewController.swift
//  reclothes
//
//

import UIKit
import FirebaseDatabase
import Firebase

class UserViewController: UIViewController{

    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "마이클로젯"
        userName.text = UserDefaults.standard.string(forKey: "userName") ?? "데이터 불러오기 실패"
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
