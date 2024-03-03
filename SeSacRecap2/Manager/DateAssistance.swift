//
//  DateAssistance.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/3/24.
//

import Foundation


final class DateAssistance{
    private init() {}
    static let shared = DateAssistance()
    private let dateformetter = ISO8601DateFormatter()
   
    func localDate(_ dateString: String) -> String{
        dateformetter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        dateformetter.timeZone = TimeZone(secondsFromGMT: 0)
    
        guard let date = dateformetter.date(from: dateString) else {
            return ""
        }
        // 로케일에 따른 지역화
        let outDateFormetter = DateFormatter()
        outDateFormetter.locale = .current
        outDateFormetter.setLocalizedDateFormatFromTemplate("MdHHmmss")
        
        let results = outDateFormetter.string(from: date)
        print(results)
        return results
    }
    
}

/* This init method creates a formatter object set to the GMT time zone and preconfigured with the RFC 3339 standard format ("yyyy-MM-dd'T'HH:mm:ssXXXXX") using the following options:
 NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithDashSeparatorInDate | NSISO8601DateFormatWithColonSeparatorInTime | NSISO8601DateFormatWithColonSeparatorInTimeZone
 */
/*
 주의

 .withYear, .withMonth, .withWeekOfYear, .withDay, .withTime, .withTimeZone, .withSpaceBetweenDateAndTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds

 위 옵션들은 단독으로 사용하게 되면 아무런 결과를 주지 않는다!!!

 왜냐고 물으면 나도 모른다!!!! 프로젝트 상에서 단독으로 넣어보고 플레이그라운드에서도 넣어봤는데 아무것도 반환을 안하는걸 어떡하냐!!! 이것 때문에 계속 삽질했다!!!!!!!
 */
//.withFullDate, .withFullTime, .withInternetDateTime 개중 한개는 꼭 넣고 나머지도 하나를 선택해야 동작한다.
/*
 if let date = dateformetter.date(from: dateString){
     dateformetter.timeZone = .current
     let calender = Calendar.current.dateComponents([.month,.day,.hour,.minute], from: date)
     print(calender)
     //print("@@@@",date
 */

// dateformetter.timeZone = .current
//        dateformetter.formatOptions = [.]
// dateformetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
// dateformetter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
// private let dateStyle = "yyyy-MM-DDTHH:mm:ss:Z"
// dateString    String    "2024-03-03T05:20:37.368Z"
// ISO8601DateFormatter()
