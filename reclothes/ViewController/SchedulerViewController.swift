//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar
import FirebaseDatabase
import KakaoSDKUser

class SchedulerViewController: UIViewController{
    var ref: DatabaseReference!
    var schedules: [String] = []
    
    @IBOutlet weak var scheduler: FSCalendar!
    @IBOutlet weak var scheduleList: UITableView!
    var didSelectDate = ""
    let dateFormatter = DateFormatter()
    let today = Date()
    var itemTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        didSelectDate = dateFormatter.string(from: Date())
        
        scheduler.delegate = self
        scheduler.dataSource = self
        scheduleList.delegate = self
        scheduleList.dataSource = self
        
        scheduler.appearance.borderRadius = 0
        // 달력의 요일 글자 색깔
        scheduler.appearance.weekdayTextColor = .black
        // 달력의 맨 위의 년도, 월의 색깔
        scheduler.appearance.headerTitleColor = .black
        
        scheduler.appearance.todayColor = #colorLiteral(red: 0.857311964, green: 0.8762198687, blue: 0.7865865827, alpha: 0.48)
        scheduler.appearance.selectionColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        scheduler.appearance.titleTodayColor = .black
        
        scheduler.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        scheduler.calendarWeekdayView.weekdayLabels[0].textColor = .red
        
        // 년월에 흐릿하게 보이는 애들 없애기
        scheduler.appearance.headerMinimumDissolvedAlpha = 0
        
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                ref = Database.database().reference().child("user")
                
                // User reservation Data 불러오기
                ref.child("\(String(describing: user?.id))").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    let value = snapshot.value as? [String: AnyObject]

                    if value?.keys.contains("reservationID") == true {
                        schedules = value!["reservationID"] as! [String];()
                    }

                    scheduleList.delegate = self
                    scheduleList.dataSource = self
                });
            }
        }
    }
}

extension SchedulerViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        didSelectDate = dateFormatter.string(from: date)
        DispatchQueue.main.async {
            self.scheduleList.reloadData()
        }
    }
}

extension SchedulerViewController: UITableViewDelegate, UITableViewDataSource{
    /*
    // 일정 다중 선택 시 일정을 모아서 보여줄때 필요함
    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleList.dequeueReusableCell(withIdentifier: "schedulerTableViewCell", for:indexPath) as! SchedulerTableViewCell

        ref = Database.database().reference()
        ref.child("reservation").child("\(schedules[indexPath.row])").getData(completion:  { [self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            let value = snapshot.value as! [String: AnyObject]
            let itemID = value["itemID"] as! String
    
            ref.child("item").child(itemID).getData(completion: { error, snapshot in
                guard error == nil else{
                    print(error?.localizedDescription)
                    return;
                }
                let item_value = snapshot.value as! [String: AnyObject]
                itemTitle = item_value["title"] as! String
            });
            let lendDate = dateFormatter.date(from: value["lendDate"] as! String)
            let returnDate = dateFormatter.date(from: value["returnDate"] as! String)
            let selectedDate = scheduler.selectedDate!
            
            if selectedDate >= today && selectedDate <= returnDate!{
                if lendDate! > selectedDate{
                    let days = String(Int((lendDate?.timeIntervalSince(selectedDate))!/86400))
                    cell.contents.text = "[빌리기 - " + "\(itemTitle)] " + days + "일 전"
                }
                else if lendDate! <= selectedDate && selectedDate < returnDate!{
                    let days = String(Int((returnDate?.timeIntervalSince(selectedDate))!/86400))
                    cell.contents.text = "[반납하기 - " + "\(itemTitle)] " + days + "일 전"
                }
                else{ // 반납일
                    cell.contents.text = "*** [반납일 - " + "\(itemTitle)] ***"
                }
            }
            else{
                cell.contents.text = ""
            }
        });
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return didSelectDate
    }
}
