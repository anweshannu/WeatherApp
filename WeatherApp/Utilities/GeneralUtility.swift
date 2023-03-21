//
//  GeneralUtility.swift
//  WeatherApp
//
//  Created by Anwesh on 3/21/23.
//

import Foundation


extension Date{
    
    
    func getDayOfWeekString()->String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: self)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tue"
            case 4:
                return "Wed"
            case 5:
                return "Thu"
            case 6:
                return "Fri"
            case 7:
                return "Sat"
            default:
                print("Error fetching days")
                return "Day"
            }
   
    }
    
    func getTimeinAmPm() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "hh:mm a"
        let time12 = formatter.string(from: self)
        return time12
    }
    
   func getDate() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "d MMM"
        let time12 = formatter.string(from: self)
        return time12
    }
    
    
    func isDateInToday() -> Bool{
        Calendar.current.isDateInToday(self)
    }
    
}

extension String{
    
    func toDate() -> Date?{
        let  df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: self)
        return date
    }
    
}
