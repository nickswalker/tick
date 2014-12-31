import UIKit
import Foundation

protocol AlarmEditing{
    func alarmWasEdited(alarm:Alarm, cell: UITableViewCell )
}

class AlarmTableViewCell: UITableViewCell, AlarmCreation{

    var delegate: AlarmEditing?
    var alarm: Alarm?{
        didSet{
            timeLabel!.text = String(format: "%02d:%02d", alarm!.hour, alarm!.minute )
            repeatScheduleLabel!.text = alarm!.stringForSchedule()
        }
    }
    
    @IBOutlet var activationSwitch: UISwitch?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var repeatScheduleLabel: UILabel?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseIn, animations: {
                self.activationSwitch!.alpha = 0.0
                }, completion: { value in
                    self.activationSwitch!.hidden = true;
            })

        }
        else{
            activationSwitch!.hidden = false;
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseIn, animations: {
                self.activationSwitch!.alpha = 1.0
                }, completion: nil)
        }
    }

    @IBAction func toggledActivation(sender: UISwitch){
        if sender.on {
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseIn, animations: {
                self.backgroundColor = UIColor.whiteColor()
                self.timeLabel!.textColor = UIColor.blackColor()
                }, completion: nil)
        }
        else{
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseIn, animations: {
                self.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.9531, alpha: 1.0)
                self.timeLabel!.textColor = UIColor(red: 0.556, green: 0.556, blue: 0.576, alpha: 1.0)
                }, completion: nil)
        }
    }

    func alarmWasCreated(alarm: Alarm) {
        self.alarm = alarm;
        delegate!.alarmWasEdited(alarm, cell:self)
        
    }
}