//
//  MainViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/10/22.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    var tempHashTagLabel = ["# 오늘 핫한 신상", "# 주목해볼만한 아이템", "# 가을 어쩌구 저쩌구"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        mainTableView.reloadData()
    }
    
    // item info 반환
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        // temp text arr
        cell.labelWithHashtag.text = tempHashTagLabel[indexPath.row]
        // which row
        cell.mainCollectionView.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0;//Choose your custom row height
    }

}
