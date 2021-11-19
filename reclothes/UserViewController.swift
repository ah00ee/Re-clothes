//
//  UserViewController.swift
//  reclothes
//
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTableView: UITableView!
    var userName: String?
    
    let userV = UserDefaults.standard.string(forKey: "userName")
    var tableView: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "마이클로젯"
        
        tableView.append(UserDefaults.standard.string(forKey: "userName") ?? "데이터 불러오기 실패")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userTableView.dequeueReusableCell(withIdentifier: "UserModelCell") else{
            fatalError("no cell")
        }
        cell.textLabel?.text = self.tableView[indexPath.row]
        
        return cell
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
