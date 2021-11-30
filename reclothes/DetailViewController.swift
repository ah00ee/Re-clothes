//
//  DetailViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/11/30.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    // 흠 이거 따로 빼고싶은데 일단은 한 번에
    @IBOutlet weak var sharerImg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.borderWidth = 0.7
        // Do any additional setup after loading the view.
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
