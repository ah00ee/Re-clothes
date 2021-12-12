//
//  PopUpViewController.swift
//  reclothes
//
//  Created by 노아영 on 2021/11/30.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        introText.text = "반갑습니다!\nRe-clothes에서 원하는 옷을 대여하고\n마음껏 입어보세요!"
        introLabel.text = "Re-clothes"
        
        introText.numberOfLines = 0
        introText.textAlignment = .center
        introLabel.textAlignment = .center
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
