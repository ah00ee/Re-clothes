//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar

class SchedulerViewController: UIViewController{
    
    @IBOutlet weak var scheduler: FSCalendar!
    @IBOutlet weak var scheduleList: UITableView!
    var didSelectDate = ""
    let dateFormatter = DateFormatter()
    
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
//         달력의 맨 위의 년도, 월의 색깔
        scheduler.appearance.headerTitleColor = .black
        
        scheduler.appearance.todayColor = #colorLiteral(red: 0.857311964, green: 0.8762198687, blue: 0.7865865827, alpha: 0.48)
        scheduler.appearance.selectionColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        scheduler.appearance.titleTodayColor = .black
        
        scheduler.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        scheduler.calendarWeekdayView.weekdayLabels[0].textColor = .red
        
        // 년월에 흐릿하게 보이는 애들 없애기
        scheduler.appearance.headerMinimumDissolvedAlpha = 0
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
    
    // 일정 다중 선택 시 일정을 모아서 보여줄때 필ㄹ요함
//    func numberOfSections(in tableView: UITableView) -> Int {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 //temp item
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell.dequeueReusableCell(withIdentifier: <#T##String#>)
        let cell = scheduleList.dequeueReusableCell(withIdentifier: "schedulerTableViewCell", for:indexPath) as! SchedulerTableViewCell
        cell.contents.text = "일정이 쭈르륵 나오면 됩니다"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return didSelectDate
    }
    
}
