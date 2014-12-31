import Foundation
import UIKit


protocol AlarmCreation{
    func alarmWasCreated(alarm: Alarm)
}

class AlarmDetailTableViewController: UITableViewController{

    var delegate: AlarmCreation?
    var alarm: Alarm?
    @IBOutlet var datePicker: UIDatePicker?
    @IBOutlet var repeatSchedule: UITableViewCell?
    @IBOutlet var deleteCell: UITableViewCell?
    var editMode = false

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components =  gregorian.components(.allZeros, fromDate: NSDate())
        
        components.hour = Int(alarm!.hour)
        components.minute = Int(alarm!.minute)
	
        let newDate = gregorian.dateFromComponents(components)!
	
        self.datePicker!.date = newDate;
        let detail: UILabel = repeatSchedule!.contentView.subviews[1] as UILabel;
        detail.text = alarm!.stringForSchedule();
    }

    override func viewWillAppear(animated: Bool) {

        let detail = repeatSchedule!.contentView.subviews[1] as UILabel
        detail.text = self.alarm!.stringForSchedule()

        if (!editMode) {
            deleteCell!.removeFromSuperview()
        }
    }

    @IBAction func cancel(sender: AnyObject){
        dismissViewControllerAnimated(true, completion:nil)
    }

    @IBAction func save(sender: AnyObject){
        delegate!.alarmWasCreated(alarm!)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dateChanged(sender: UIDatePicker){
        let date = sender.date
        let calendar = NSCalendar.currentCalendar()

        let desiredComponents:NSCalendarUnit = NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit

        let components = calendar.components(desiredComponents, fromDate: date);
        alarm!.hour = UInt8(components.hour)
        alarm!.minute = UInt8(components.minute)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //The user tapped the confirm button
		if indexPath.section == 1 && indexPath.row == 0 {
			alarm = Alarm()
			self.delegate!.alarmWasCreated(alarm!)
			tableView.deselectRowAtIndexPath(indexPath, animated:true)
		}
        else{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destinationViewController = segue.destinationViewController as ScheduleTableViewController;

        if segue.identifier! == "EditSchedule" {
            destinationViewController.alarm = self.alarm;
            
        }
        else{
            abort()
        }
    }
}
