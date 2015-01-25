import UIKit
import Foundation

typealias Option = TockManager.Option

class OptionsViewController: UITableViewController {

    @IBOutlet var displayTwentyFourHourTime: UISwitch?
    @IBOutlet var blinkColon: UISwitch?
    @IBOutlet var autoBrightness: UISwitch?
    @IBOutlet var brightness: UISlider?

    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
        super.init(coder: aDecoder)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        let colorView = UIView()
        colorView.backgroundColor = UIColor(red:0.933, green:0.933, blue:0.9531, alpha:1);
        self.tableView.backgroundView = colorView
    }

    override func viewWillAppear(animated: Bool) {
        self.configureFromModel()
    }

    private func configureFromModel(){
        let twentyFourHour = TockManager.setting(.DisplayTwentyFourHourTime) != 0
        displayTwentyFourHourTime!.on = twentyFourHour

        let blink = TockManager.setting(.BlinkColon) != 0
        blinkColon!.on = blink
	
        let brightnessValue = Float(TockManager.setting(.Brightness))
        brightness!.value = brightnessValue

        let autoBrightnessValue = TockManager.setting(.AutoBrightness) != 0
        autoBrightness!.on = autoBrightnessValue.boolValue;
	
	
        if !autoBrightness!.on {
            brightness!.enabled = true
        }
        else {
            brightness!.enabled = false
        }
	
}

    @IBAction func settingChanged(sender: UISwitch){
        let value: UInt8 = sender.on ? 1 : 0
        if sender == displayTwentyFourHourTime!{

            TockManager.setSetting(Option.DisplayTwentyFourHourTime, value: value)
        }
        else if sender == blinkColon! {
            TockManager.setSetting(Option.BlinkColon, value: value)
        }
        else if sender == autoBrightness! {
            TockManager.setSetting(Option.AutoBrightness, value: value)
            brightness!.enabled = !sender.on
        }
	
    }

    func reset(){
        var alert = UIAlertController(title: "Reset to defaults?",
            message: "This will erase all alarms and settings.",
            preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .Destructive, handler:{ (alertAction:UIAlertAction!) in
            TockManager.resetToDefaults()
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func sliderSettingChanged(slider: UISlider){
        if slider == brightness {
            TockManager.setSetting(Option.Brightness, value: UInt8(slider.value))
        }
    }

    @IBAction func reloadClicked(sender:AnyObject) {
        TockManager.detachFromTock()
        TockManager.searchForTock()
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        //The reset switch
        if indexPath.section == 1 && indexPath.row == 0{
            reset()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else {
            //Don't allow anything else to be selected
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
}
