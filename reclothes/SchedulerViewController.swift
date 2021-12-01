//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar

class SchedulerViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var confirmBtn: UIButton!
    let dateFormatter = DateFormatter()
    
    // 선택된 날짜 중
    var minDate : Date? = nil
    var maxDate : Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.allowsMultipleSelection = true
        
        // 꾹 눌러 스와이프해서 multi select
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.borderRadius = 0
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red

    }

    // 일단 dismiss
    @IBAction func completeReserve(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            // 날짜 선택 일수 제한(현재 3일)
            if calendar.selectedDates.count > 3 {
                return false
            } else {
            return true
        }
    }
    
    // 날짜 선택 시 메소드, 해재시는 didSelect -> didDeselect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if calendar.selectedDates.count == 1 {
            print("1개 날짜 선택")
            confirmBtn.titleLabel?.text = dateFormatter.string(from: date)
            if minDate == nil, maxDate == nil {
                minDate = date
                maxDate = date
            }else{
                
                
            }
        } else {
            print("어러 날짜 선택")
        }
    }
    
    //선택해제 불가능하게
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            return false // 선택해제 불가능
    }
    
//
//    //날짜 밑에 문자열을 표시
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
////        switch dateFormatter.string(from: date) {
////            case dateFormatter.string(from: Date()):
////                return "오늘"
////            case "2021-10-22":
////                return "출근"
////            case "2021-10-23":
////                return "지각"
////            case "2021-10-24":
////                return "결근"
////            default:
////                return nil
////            }
//    }
//
//    //날짜 글씨 자체를 바꾸기
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
////            switch dateFormatter.string(from: date) {
////            case "2021-10-25":
////                return "D-day"
////            default:
////                return nil
////            }
//        }
}
