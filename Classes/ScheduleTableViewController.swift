import UIKit
import Foundation

class ScheduleTableViewController: UITableViewController {
    var alarm: Alarm?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let day = Day(rawValue: indexPath.row + 1)!
        if alarm!.activeForDay(day) {
            cell.accessoryType = .Checkmark
        }
        return cell;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let day = Day(rawValue: indexPath.row + 1)!
        
        if (cell.accessoryType == .None) {
            cell.accessoryType = .Checkmark;
            alarm!.setActiveForDay(day, value: true);
        }
        else {
            cell.accessoryType = .None;
            alarm!.setActiveForDay(day, value: false);
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true);
}

}