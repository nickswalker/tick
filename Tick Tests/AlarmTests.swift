import Tick
import UIKit
import XCTest

class AlarmTests: XCTestCase {

    private var alarm = Alarm(binary: 0)

    override func setUp() {
        super.setUp()
        alarm = Alarm(binary: 0)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActivatingDays() {
        for day in Day.allValues{
            XCTAssertFalse(alarm.activeForDay(day), "Day \(day.rawValue) inactive by default")
        }

        alarm.setActiveForDay(.Sunday, value: true)
        XCTAssert(alarm.activeForDay(.Sunday))

        for day in Day.allValues{
            if day != .Sunday{
                XCTAssertFalse(alarm.activeForDay(day), "Day \(day.rawValue) should still be inactive")
            }
        }
        alarm.setActiveForDay(.Saturday, value: true)
        XCTAssert(alarm.activeForDay(.Saturday))

        alarm.setActiveForDay(.Wednesday, value: true)
        XCTAssert(alarm.activeForDay(.Wednesday))

        for day in Day.allValues{
            if day != .Sunday && day != .Saturday && day != .Wednesday {
                XCTAssertFalse(alarm.activeForDay(day), "Day \(day.rawValue) should still be inactive")
            }
        }
    }

    func testActivating(){
        XCTAssertFalse(alarm.active, "Inactive by default")
        alarm.active = true
        XCTAssert(alarm.active)
    }
    func testIncorrectInitialization(){
        XCTAssertNil(Alarm(minute: 60, hour: 0, schedule: 0), "Can't initialize with invalid time")
    }

    func testSettingTime(){
        alarm.minute = 10
        alarm.hour = 15
        XCTAssertEqual(alarm.minute, UInt8(10))
        XCTAssertEqual(alarm.hour, UInt8(15))
    }

    func testStringForSchedule(){
        alarm = Alarm(minute: 10, hour: 10, schedule: 0b11111111)!

        XCTAssertEqual(alarm.stringForSchedule(), "Every day")
        alarm = Alarm(minute: 12, hour: 12, schedule: 0b11111110)!
        XCTAssertEqual(alarm.stringForSchedule(), "Every day", "Should ignore active bit")

        alarm = Alarm(minute: 59, hour: 23, schedule: 0b01000000)!
        XCTAssertEqual(alarm.stringForSchedule(), "Fri")

    }
    
}
