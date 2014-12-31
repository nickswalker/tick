import UIKit
import Foundation

class OptionsViewController: UITableViewController {
    var tock: TockManager

    @IBOutlet var displayTwentyFourHourTime: UISwitch?
    @IBOutlet var blinkColon: UISwitch?
    @IBOutlet var autoBrightness: UISwitch?
    @IBOutlet var brightness: UISlider?

    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
        tock = appDelegate.tockManager
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
        let twentyFourHour = tock.setting(TockManager.Option.DISPLAYTWENTYFOURHOURTIME) != 0
        displayTwentyFourHourTime!.on = twentyFourHour

        let blink = tock.setting(TockManager.Option.BLINKCOLON) != 0
        blinkColon!.on = blink
	
        let brightnessValue = Float(tock.setting(.BRIGHTNESS))
        brightness!.value = brightnessValue

        let autoBrightnessValue = tock.setting(TockManager.Option.AUTOBRIGHTNESS) != 0
        autoBrightness!.on = autoBrightnessValue.boolValue;
	
	
        if !autoBrightness!.on {
            brightness!.enabled = true
        }
        else {
            brightness!.enabled = false
        }
	
}

    @IBAction func settingChanged(sender: UISwitch){
        if sender == displayTwentyFourHourTime!{
            //tock.sendSetting(TockManager.DISPLAYTWENTYFOURHOURTIME, value: sender.on)
        }
        if sender == blinkColon! {
        //tock.sendSetting(TockManager.BLINKCOLON, value: sender.on)
        }
        if sender == autoBrightness! {
            //tock.sendSetting(TockManager.AUTOBRIGHTNESS, value: sender.on)
            brightness!.enabled = !sender.on
        }
	
    }

    func reset(){
        var alert = UIAlertController(title: "Reset to defaults?",
            message: "This will erase all alarms and settings.",
            preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .Destructive, handler:{ (alertAction:UIAlertAction!) in
            self.tock.resetToDefaults()
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func sliderSettingChanged(slider: UISlider){
        if slider == brightness {
            //tock.brightness = slider.value
        }
    }

    @IBAction func reloadClicked(sender:AnyObject) {
        tock.detachFromTock()
        tock.attachToTock()
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
