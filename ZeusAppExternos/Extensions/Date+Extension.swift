//
//  Date+Extension.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 16/01/25.
//

import Foundation

extension Date {
    func getStringDate(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .init(identifier: "es_ES")
        let str = formatter.string(from: self)
        return str
    }
    
    func add(_ value: Int, to: Calendar.Component) -> Date? {
        return Calendar.current.date(byAdding: to, value: value, to: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var timestamp: Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    var date: Date {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var time: Date {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        components.hour = self.hour
        components.minute = self.minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var yearMonth: Date {
        var components = DateComponents()
        components.year = self.year
        components.month = self.month
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
    
    func withFormat(_ format: String, _ locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? Date()
    }
    
    init(fromDateComponents components: DateComponents) {
        self.init()
        self = Calendar.current.date(from: components) ?? Date()
    }
    
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return startDate <= self && self < endDate
    }
    
    func getWrokdayRange() -> (start:Date, end: Date) {
        var startHourDay: Date = Date(fromDateComponents: .init(year: self.year, month: self.month, day: self.day,
                                                                hour: 6, minute: 0, second: 0))
        var endHourDay: Date = Date()
        
        if self.hour >= 6 {
            endHourDay = startHourDay.add(1, to: .day) ?? Date()
        } else {
            startHourDay = startHourDay.add(-1, to: .day) ?? Date()
            endHourDay = startHourDay.add(1, to: .day) ?? Date()
        }
        return (startHourDay, endHourDay)
    }
}
