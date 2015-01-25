import UIKit
import Foundation

class AlarmsTableViewController: UITableViewController, AlarmCreation, AlarmEditing {

    @IBOutlet var editButton: UIBarButtonItem?


    override func viewDidLoad(){
        super.viewDidLoad()
        let colorPreview = UIView();
        colorPreview.backgroundColor = UIColor(red:0.933, green:0.933, blue:0.9531, alpha:1)
        tableView.backgroundView = colorPreview
	}

    override func viewWillAppear(animated: Bool) {
        setEditing(false, animated: false)
        tableView.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing) {
            self.editButton!.title = "Done";
        }
        else {
            self.editButton!.title = "Edit";
        }
    }

    @IBAction func editButtonPressed( sender: UIBarButtonItem){
        setEditing(!self.editing, animated: true)
    }

    func alarmWasCreated(alarm: Alarm) {
        TockManager.setAlarm(TockManager.emptyAlarmNumber(), alarm: alarm)
        tableView.reloadData()
    }

    func alarmWasEdited(alarm:Alarm, cell: UITableViewCell){
        let table = cell.superview as UITableView
        let indexPath = table.indexPathForCell(cell)
        TockManager.setAlarm(indexPath!.row, alarm: alarm)
        tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Immediately deselect
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TockManager.numberOfAlarms()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: AlarmTableViewCell = tableView.dequeueReusableCellWithIdentifier("Alarm", forIndexPath: indexPath) as AlarmTableViewCell

        cell.alarm = TockManager.alarm(indexPath.row)
        return cell;
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            TockManager.clearAlarm(indexPath.row + 1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as UINavigationController
        let destinationViewController = navigationController.visibleViewController as AlarmDetailTableViewController
        
        if segue.identifier == "CreateAlarm" {
            destinationViewController.delegate = self
            destinationViewController.alarm = Alarm()
            destinationViewController.title = "Add Alarm"
            
        }
        else if segue.identifier == "EditAlarm" {
            let cell = sender as AlarmTableViewCell
            destinationViewController.delegate = cell
            destinationViewController.title = "Edit Alarm"
            destinationViewController.editMode = true
            destinationViewController.alarm = cell.alarm
        
        }
        else{
            abort()
        }
    }
}