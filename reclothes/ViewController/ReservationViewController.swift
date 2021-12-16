//
//  SchedulerViewController.swift
//  reclothes
//
//  Created by 문다 on 2021/12/01.
//

import UIKit
import FSCalendar
import KakaoSDKUser
import FirebaseDatabase

class ReservationViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    var ref: DatabaseReference!
    var itemID = ""
    var uid: Int64 = 0
    var tmpPrice = 0
    
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
        // 달력의 맨 위의 년도, 월의 색깔
        calendar.appearance.headerTitleColor = .black
        
        calendar.appearance.todayColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        calendar.appearance.selectionColor = #colorLiteral(red: 0.7678088546, green: 0, blue: 0, alpha: 1)
        
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        
        // 년월에 흐릿하게 보이는 애들 없애기
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        ref = Database.database().reference()
        ref.child("item/\(itemID)").getData(completion:  { [self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            let value = snapshot.value as! [String: AnyObject]
            tmpPrice = value["price"] as! Int
            dailyPrice.text = String(tmpPrice) + "원/일"
        });
    }
    
    // 달력 바깥 화면 터치 시, 예약vc dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }

    // 예약 정보 등록 -> Realtime Database
    @IBAction func completeReserve(_ sender: Any) {
        ref = Database.database().reference()
        let reserveID = self.ref.child("reservation").childByAutoId()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        UserApi.shared.me(){ [self](user,error) in
            if let error = error{
                print("error")
            }
            else{
                reserveID.setValue(["lendDate": dateFormatter.string(from: minDate!), "returnDate": dateFormatter.string(from: maxDate!), "userID": user?.id, "itemID": itemID, "totalPrice": totalPrice.text])

                ref.child("user/\(user?.id)").getData(completion:  { error, snapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                    }
                    let value = snapshot.value as! [String: AnyObject]
                    var schedules = [String]()
                    if value["reservationID"] != nil{
                        schedules = value["reservationID"] as! [String]
                    }
                    schedules.append(reserveID.key!)
                    self.ref.child("user/\(user?.id)/reservationID").setValue(schedules)
                });
            }
        }
      
        self.dismiss(animated: true)
    }
    
    /*
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
    }
    */
     
    // DetailVC에서 데이터 가져오기
    func receiveItemFromDVC(_ item: String){
        itemID = item
    }
    
    // 날짜 선택 시 메소드, 해제 시는 didSelect -> didDeselect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if calendar.selectedDates.count == 1 {
            minDate = date
            maxDate = date
            confirmLabel.text = dateFormatter.string(from: date) + " 예약"
            
            confirmBtn.isEnabled = true
        }
        else if calendar.selectedDates.count == 2 {
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
        }
        else{
            clear()
            confirmLabel.text = "날짜를 선택해주세요"
        }
        cntDays.text = String(calendar.selectedDates.count-1) + "일"
        totalPrice.text = String(tmpPrice*(calendar.selectedDates.count-1)) + "원"
        
        if date < today {
            confirmLabel.text = "당일과 이전 날짜는 선택할 수 없습니다"
            clear()
        }
    }
    
    // 선택해제 불가능하게
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
