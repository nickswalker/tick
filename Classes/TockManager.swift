import UIKit
import Foundation

class TockManager: NRFManager {
    private var alarms = [Alarm](count: 10, repeatedValue: Alarm(binary: 0))
    private var settings = [Option: UInt8]()

    enum Command: UInt8 {
        case SETDATE = 1,
        SETTIME = 2,
        SETLIGHTCOLOR = 3,
        GETLIGHTCOLOR = 4,
        SETALARM = 5,
        GETALARM = 6,
        SETSETTING = 7,
        GETSETTING = 8,
        RESET = 254,
        TESTCONNECTION = 255
    }

    enum Option: UInt8 {
        case DISPLAYTWENTYFOURHOURTIME = 1,
        BLINKCOLON = 2,
        LOUDERALARM = 3,
        AUTOBRIGHTNESS = 4,
        BRIGHTNESS = 5
    }

    init() {

    }

    func attachToTock(){

        //Search the peripherals array for the one that matches what we want
    
        //Connect peripheral, sync time, get settings

    }
    func detachFromTock(){
        //self.cm.cancelPeripheralConnection(self.activePeripheral);
    }

    private func processCommand(message: NSData){
        var messageBytes = [UInt8](count: message.length, repeatedValue: 0)
        message.getBytes(&messageBytes, length: message.length)

        for var i = 0; i < message.length ; i++ {
            print("\(i): \(messageBytes[i])");
        }
        switch Command(rawValue: messageBytes[0])!  {
            case .GETALARM:
                let alarm = TockManager.bytesToInt([messageBytes[0], messageBytes[1], messageBytes[2], messageBytes[3]])
                let alarmNumber = messageBytes[1]
                alarms[Int(alarmNumber)] = Alarm(binary: alarm)

            case .GETSETTING:
                let option = Option(rawValue: messageBytes[1])!
                let value = messageBytes[2]
                settings[option] = value
            default:
                print("Recieved other command")
        }
    }

    func syncDateTime(){
        //In GMT
        let currentDate = NSDate()

        var timeInterval =  currentDate.timeIntervalSince1970

        let timeZone = NSTimeZone.systemTimeZone()
        timeInterval = timeInterval.advancedBy(Double(timeZone.secondsFromGMT))
        //Now in iPhone-local time zone/DST
        let intTime: UInt32 = UInt32(timeInterval)
        let bytes = TockManager.intToBytes(intTime)
        let message: [UInt8] = [Command.SETTIME.rawValue, bytes[0], bytes[1], bytes[2], bytes[4]]
        sendBytes(message)
    }

    func resetToDefaults(){
        let message: [UInt8] = [Command.RESET.rawValue]
        //[self sendBytes:message size:sizeof(message)];
    }

    func numberOfAlarms()-> Int {
        var number = 0;
        for alarm in alarms {
            if alarm.binaryRepresentation != 0 {
                number++
            }
        }
        return number
    }

    func emptyAlarmNumber()-> Int {
        for var i = 0; i < 10; i++ {
            let alarm = alarms[i]
            if alarm.binaryRepresentation == 0 {
                return i;
            }
        }
        return 9;
    }

    //MARK: Message Senders

    private func sendText(string:String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)

    }

    private func sendBytes(bytes: [UInt8]){
        for var i = 0; i < bytes.count; i++ {
            print()
        }
        let data = NSData(bytes: bytes, length: bytes.count)
    }

    private func sendSetting(option: Option, value: UInt8){
        let message: [UInt8] = [Command.SETSETTING.rawValue, option.rawValue, value]
        sendBytes(message)
    }

    private func sendColor(r: UInt8, g: UInt8, b: UInt8) {
        let message: [UInt8] = [Command.SETLIGHTCOLOR.rawValue, r, g, b]
        sendBytes(message)
    }

    private func sendAlarm(alarm: Alarm, number: UInt8){
        print(alarm)
        let bytes = TockManager.intToBytes(alarm.binaryRepresentation)
        let message: [UInt8] = [Command.SETALARM.rawValue, number, bytes[0], bytes[1], bytes[2], bytes[3]]
        sendBytes(message)
    }

    private func testConnection(){
        let message: [UInt8] = [Command.TESTCONNECTION.rawValue]
        sendBytes(message)
    }

    private func fetchAllSettings(){
        for var i: UInt8 = 0; i < 5; i++ {
            fetchSetting(Option(rawValue: i)!)
        }
    }

    private func fetchSetting(option: Option){
        let message: [UInt8] = [Command.GETSETTING.rawValue, option.rawValue]
        sendBytes(message)
    }

    private func fetchAlarm(alarmNumber: Int){
        let message: [UInt8]  = [Command.GETALARM.rawValue, UInt8(alarmNumber)];
        sendBytes(message)
    }

    private func fetchAlarms(){
        for var i = 1; i < 9; i++ {
            fetchAlarm(i)
        }
    }

    //MARK: Public
    func setSetting(option:Option, value: UInt8) {
        settings[option] = value
    }

    func setting(option: Option)-> UInt8 {
        let value = settings[option]
        if value == nil {
            return 0
        }
        else {
            return value!
        }
    }

    func clearAlarm(number: Int){
        let emptyAlarm = Alarm(binary: 0)
        alarms[number] = emptyAlarm
    }

    func setAlarm(number: Int, alarm: Alarm)  {
        alarms[number] = alarm
    }

    func alarm(number: Int)-> Alarm {
        return alarms[number]
    }

    //MARK: Helpers
    //Little endian: Least significant byte first
    private class func intToBytes(binary: UInt32)-> [UInt8] {
        var returnValue = [UInt8](count: 4, repeatedValue: 0)
        returnValue[0] = UInt8((binary >> 0));
        returnValue[1] = UInt8((binary >> 8));
        returnValue[2] = UInt8((binary >> 16));
        returnValue[3] = UInt8((binary >> 24));
        return returnValue
    }
    private class func bytesToInt(bytes: [UInt8])-> UInt32 {
        var returnValue: UInt32 = UInt32(bytes[0])
        returnValue += (UInt32(bytes[1]) << 8)
        returnValue += (UInt32(bytes[2]) << 16)
        returnValue += (UInt32(bytes[3]) << 24)
        return returnValue
    }

}
