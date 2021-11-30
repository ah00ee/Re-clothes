//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar

class SchedulerViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.allowsMultipleSelection = true
        
        // 꾹 눌러 스와이프해서 multi select
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.borderRadius = 0

        // Do any additional setup after loading the view.
    }

    // 일단 dismiss
    @IBAction func completeReserve(_ sender: Any) {
        self.dismiss(animated: true)
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
