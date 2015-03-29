import UIKit
import Foundation

@objc public class TockManager: NRFManagerDelegate {
    struct ClassMembers {
        static var alarms = [Alarm](count: 10, repeatedValue: Alarm(binary: 0))
        static var settings = [Option: UInt8]()
    }

    enum Command: UInt8 {
        case SetTime = 1,
        SetLightColor = 2,
        GetLightColor = 3,
        SetAlarm = 4,
        GetAlarm = 5,
        SetSetting = 6,
        GetSetting = 7,
        Reset = 254,
        TestConnection = 255
    }

    enum Option: UInt8 {
        case DisplayTwentyFourHourTime = 1,
        BlinkColon = 20,
        AutoBrightness = 3,
        Brightness = 4

        static let allValues: [Option] = [.DisplayTwentyFourHourTime, .BlinkColon, .AutoBrightness, .Brightness]
    }

    class func searchForTock(){
        NRFManager.sharedInstance.autoConnect = true
        NRFManager.sharedInstance.connect()
        var contentView = HUDContentView.ProgressView()
        HUDController.sharedController.contentView = contentView
        HUDController.sharedController.show()
        HUDController.sharedController.dimsBackground = true
    }

    class func detachFromTock(){
        NRFManager.sharedInstance.disconnect()
        NRFManager.sharedInstance.autoConnect = false
    }

    public func nrfReceivedData(nrfManager: NRFManager, data: NSData?, string: String?) {
        var messageBytes = [UInt8](count: data!.length, repeatedValue: 0)
        data!.getBytes(&messageBytes, length: data!.length)

        TockManager.processCommand(messageBytes)
    }
    public func nrfDidConnect(nrfManager: NRFManager) {
        //Connect peripheral, sync time, get settings
        HUDController.sharedController.hide(afterDelay: 4.0)
        TockManager.syncDateTime()
        TockManager.fetchAllSettings()
        TockManager.fetchAlarms()
    }
    public func nrfDidDisconnect(nrfManager: NRFManager) {
        //nop
    }

    private class func processCommand(message: [UInt8]){
        switch Command(rawValue: message[0])!  {
            case .GetAlarm:
                let alarm = TockManager.bytesToInt([message[2], message[3], message[4], message[5]])
                let alarmNumber = message[1]
                ClassMembers.alarms[Int(alarmNumber)] = Alarm(binary: alarm)

            case .GetSetting:
                let option = Option(rawValue: message[1])
                if option != nil{
                let value = message[2]
                ClassMembers.settings[option!] = value
                } else {
                    println("Recieved incorect option code")
            }
            default:
                print("Recieved other command")
        }
    }

    private class func syncDateTime(){
        //In GMT
        let currentDate = NSDate()

        var timeInterval =  currentDate.timeIntervalSince1970

        let timeZone = NSTimeZone.systemTimeZone()
        timeInterval = timeInterval.advancedBy(Double(timeZone.secondsFromGMT))
        //Now in iPhone-local time zone/DST

        let test = UInt32(timeInterval)
        let bytes = TockManager.intToBytes(test)
        let message: [UInt8] = [Command.SetTime.rawValue, bytes[0], bytes[1], bytes[2], bytes[3]]
        sendBytes(message)
    }

    class func resetToDefaults(){
        let message: [UInt8] = [Command.Reset.rawValue]
        sendBytes(message)
    }

    class func sendMessage(message: [UInt8]){
        sendBytes(message)
    }

    class func numberOfAlarms()-> Int {
        var number = 0;
        for alarm in ClassMembers.alarms {
            if alarm.binaryRepresentation != 0 {
                number++
            }
        }
        return number
    }

    class func emptyAlarmNumber()-> Int {
        for var i = 0; i < 10; i++ {
            let alarm = ClassMembers.alarms[i]
            if alarm.binaryRepresentation == 0 {
                return i
            }
        }
        return 10;
    }

    //MARK: Message Senders

    private class func sendText(string:String) {
        NRFManager.sharedInstance.writeString(string)
    }

    private class func sendBytes(bytes: [UInt8]){
        let data = NSData(bytes: bytes, length: bytes.count)
        NRFManager.sharedInstance.writeData(data)
    }

    private class func sendSetting(option: Option, value: UInt8){
        let message: [UInt8] = [Command.SetSetting.rawValue, option.rawValue, value]
        sendBytes(message)
    }

    private class func sendColor(r: UInt8, g: UInt8, b: UInt8) {
        let message: [UInt8] = [Command.SetLightColor.rawValue, r, g, b]
        sendBytes(message)
    }

    private class func sendAlarm(alarm: Alarm, number: Int){
        let bytes = TockManager.intToBytes(alarm.binaryRepresentation)
        let message: [UInt8] = [Command.SetAlarm.rawValue, UInt8(number), bytes[0], bytes[1], bytes[2], bytes[3]]
        sendBytes(message)
    }

    private class func testConnection(){
        let message: [UInt8] = [Command.TestConnection.rawValue]
        sendBytes(message)
    }

    private class func fetchAllSettings(){
        for setting in Option.allValues {
            fetchSetting(setting)
        }
    }

    private class func fetchSetting(option: Option){
        let message: [UInt8] = [Command.GetSetting.rawValue, option.rawValue]
        sendBytes(message)
    }

    private class func fetchAlarm(alarmNumber: Int){
        let message: [UInt8]  = [Command.GetAlarm.rawValue, UInt8(alarmNumber)];
        sendBytes(message)
    }

    private class func fetchAlarms(){
        for var i = 0; i < 9; i++ {
            fetchAlarm(i)
        }
    }

    //MARK: Public
    class func setSetting(option:Option, value: UInt8) {
        ClassMembers.settings[option] = value
        sendSetting(option, value: value)
    }

    class func setting(option: Option)-> UInt8 {
        let value = ClassMembers.settings[option]
        if value == nil {
            return 0
        }
        else {
            return value!
        }
    }

    class func clearAlarm(number: Int){
        let emptyAlarm = Alarm(binary: 0)
        ClassMembers.alarms[number] = emptyAlarm
        sendAlarm(emptyAlarm, number: number)
    }

    class func setAlarm(number: Int, alarm: Alarm)  {
        ClassMembers.alarms[number] = alarm
        sendAlarm(alarm, number: number)
    }

    class func alarm(number: Int)-> Alarm {
        return ClassMembers.alarms[number]
    }

    //MARK: Helpers
    //Little endian: Least significant byte first
    private class func intToBytes(binary: UInt32)-> [UInt8] {
        var returnValue = [UInt8](count: 4, repeatedValue: 0)
        returnValue[0] = UInt8(binary & 0xFF)
        returnValue[1] = UInt8((binary & 0xFF00) >> 8)
        returnValue[2] = UInt8((binary & 0xFF0000) >> 16)
        returnValue[3] = UInt8((binary & 0xFF000000) >> 24)
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
