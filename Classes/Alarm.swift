import Foundation
import UIKit

public class Alarm{
    public var binaryRepresentation: UInt32 {
        get{
            let bytes = [minute, hour, schedule, 0]
            return Alarm.bytesToInt(bytes)
        }
        set(newValue){
            let bytes = Alarm.intToBytes(newValue)
            minute = bytes[0]
            hour = bytes[1]
            schedule = bytes[2]
        }
    }
    public var minute: UInt8 = 0
    public var hour: UInt8 = 0
    public var active: Bool {
        get{
            return (schedule & 1) > 0
        }
        set(newValue){
            let value: UInt8 = newValue ? 1 : 0
            let mask = ~UInt8(value)
            schedule = (schedule & mask) | UInt8(value)
        }
    }

    private var schedule: UInt8 = 0

    public init(){
		let date = NSDate()
		let calendar = NSCalendar.currentCalendar()
        let desiredComponents:NSCalendarUnit = NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit

		let components = calendar.components(desiredComponents, fromDate: date);
		hour = UInt8(components.hour)
		minute = UInt8(components.minute)
		schedule = 0;
        active = true
		
    }

    public init(binary:UInt32){
        binaryRepresentation = binary
        let bytes = Alarm.intToBytes(binary)
        minute = bytes[0]
        hour = bytes[1]
        schedule = bytes[2]
    }

    public init?(minute: UInt8, hour: UInt8, schedule: UInt8){
        self.minute = minute
        self.hour = hour
        self.schedule = schedule

        if minute > 59 || hour > 23 {
            return nil
        }
    }

    public func activeForDay(day: Day)-> Bool{
        let mask = UInt8(1 << day.rawValue)
        let masked = schedule & mask
        return masked > 0
    }

     public func setActiveForDay(day: Day, value: Bool){
        let oldSchedule = schedule
        let boolToInt: UInt8 = value ? 1 : 0
        let shifted: UInt8 = boolToInt << UInt8(day.rawValue)
        let mask = ~shifted
        let newSchedule: UInt8 = (oldSchedule & mask) | shifted
        schedule = newSchedule
    }

    public func stringForSchedule()-> String {
        var returnString = ""
        let tempSchedule = schedule
        var repeats = [Bool](count: 8, repeatedValue: false)
        for var i: UInt8 = 1; i < 8; i++ {
            repeats[i-1] = (tempSchedule & ( 1 << i)) > 0
        }

        let noActiveBit: UInt8 = tempSchedule & 0b11111110
        let weekendMask: UInt8 = 0b10000010
        let onlyWeekends: Bool = noActiveBit == weekendMask
        if onlyWeekends {
            return "Weekends"
        }
        let weekdaysMask: UInt8 = 0b01111100
        let onlyWeekdays: Bool = noActiveBit == weekdaysMask
        if onlyWeekdays{
            return "Weekdays"
        }
        let everyDayMask: UInt8 = 0b11111110
        let everyDay: Bool = noActiveBit == everyDayMask
        if everyDay{
            return "Every day"
        }
        let neverMask:UInt8 = 0b00000000
        let never: Bool = noActiveBit == neverMask
        if never {
            return "Never"
        }

        let dayStrings: [String] = ["Sun" ,"Mon" ,"Tues" ,"Wed" ,"Thurs" ,"Fri" ,"Sat"]
        var first = true
        for var i = 0; i < 7; i++ {
            if(repeats[i]){
                if !first{
                    returnString += " "
                } else {
                    first = false
                }

                returnString += dayStrings[i]
            }
        }

        return returnString
    }

    private class func intToBytes(binary: UInt32)-> [UInt8]{
        var returnValue: [UInt8] = []
        returnValue.append( UInt8((binary >> 0)));
        returnValue.append( UInt8((binary >> 8)));
        returnValue.append( UInt8((binary >> 16)));
        returnValue.append( UInt8((binary >> 24)));
        return returnValue
    }

    private class func bytesToInt(bytes: [UInt8])-> UInt32 {
        var returnValue: UInt32 = UInt32(bytes[0])
        returnValue += (UInt32(bytes[1]) << 8)
        returnValue += (UInt32(bytes[2]) << 16)
        returnValue += (UInt32(bytes[3]) << 24)
        return returnValue
    }

    public func description()-> String {
        return "\(hour):\(minute) \(stringForSchedule())"
    }

}
