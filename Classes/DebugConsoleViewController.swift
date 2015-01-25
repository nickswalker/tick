import Foundation
import UIKit

class DebugConsoleViewController: UIViewController, UITextFieldDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet var messageField: UITextField?
    @IBOutlet var recieved: UILabel?

    override func viewDidLoad(){
        super.viewDidLoad()
        NRFManager.sharedInstance.dataCallback = {
            data, string in
            self.updateRecievedDisplay(data!)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var message = [UInt8]()
        var text = textField.text
        if countElements(text) % 2 != 0 {
            text.append(Character("0"))
        }
        for var i = 0; i < countElements(text); i += 2 {
            let substring = text.substringWithRange(Range<String.Index>(start: advance(text.startIndex, i), end: advance(text.startIndex, i + 2)))
            let scanner = NSScanner(string: substring)
            var result: UInt32 = 0;
            scanner.scanHexInt(&result)
            message.append(UInt8(result & 0xFF))
        }

        TockManager.sendMessage(message)
        return true
    }

    func updateRecievedDisplay(data: NSData){
        var messageBytes = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&messageBytes, length: data.length)

        recieved?.text = ""
        for byte in messageBytes {
            let hex = String(format: "%02x", arguments: [byte])
            recieved!.text = "\(recieved!.text!) \(hex)"
        }
    }

}
