//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar

class ReservationViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var confirmLabel: UILabel!
    
    // 가격
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var dailyPrice: UILabel!
    @IBOutlet weak var cntLabel: UILabel!
    @IBOutlet weak var cntDays: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    let dateFormatter = DateFormatter()
    let today = Date()
    
    // 선택된 날짜 중
    var minDate : Date? = nil
    var maxDate : Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmLabel.textAlignment = .center
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.allowsMultipleSelection = true
        calendar.appearance.borderRadius = 0
        
        // 달력의 요일 글자 색깔
        calendar.appearance.weekdayTextColor = .black
//         달력의 맨 위의 년도, 월의 색깔
        calendar.appearance.headerTitleColor = .black
        
        calendar.appearance.todayColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        calendar.appearance.selectionColor = #colorLiteral(red: 0.7678088546, green: 0, blue: 0, alpha: 1)
        
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        
        // 년월에 흐릿하게 보이는 애들 없애기
        calendar.appearance.headerMinimumDissolvedAlpha = 0

    }

    // 일단 dismiss
    @IBAction func completeReserve(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//            // 날짜 선택 일수 제한(현재 3일)
//            if calendar.selectedDates.count > 3 {
//                return false
//            } else {
//            return true
//        }
//    }
    
    // 날짜 선택 시 메소드, 해재시는 didSelect -> didDeselect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if calendar.selectedDates.count == 1 {
            minDate = date
            maxDate = date
            confirmLabel.text = dateFormatter.string(from: date) + " 예약"
            
            confirmBtn.isEnabled = true
        } else if calendar.selectedDates.count == 2 {
            if minDate?.compare(date) == .orderedDescending{
                minDate = date
            }
            if maxDate?.compare(date) == .orderedAscending{
                maxDate = date
            }
            
            let range = datesRange(from: minDate!, to: maxDate!)
            for d in range {
                calendar.select(d)
            }
            
            confirmLabel.text = dateFormatter.string(from: minDate!) + " ~ " + dateFormatter.string(from: maxDate!) + " 예약"
            
            confirmBtn.isEnabled = true
        }else{
            clear()
            confirmLabel.text = "날짜를 선택해주세요"
        }
        
        if date < today {
            confirmLabel.text = "당일과 이전 날짜는 선택할 수 없습니다"
            clear()
        }
    }
    
    //선택해제 불가능하게
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            return false // 선택해제 불가능
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func clear(){
        print("clear")
        for selectedDate in self.calendar.selectedDates {
            self.calendar.deselect(selectedDate)
        }
        minDate = nil
        maxDate = nil
        confirmBtn.isEnabled = false
    }
}
