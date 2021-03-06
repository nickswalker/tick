import QuartzCore
import UIKit

class ColorViewController: UIViewController{

    @IBOutlet var rSlider: UISlider?
    @IBOutlet var gSlider: UISlider?
    @IBOutlet var bSlider: UISlider?
    @IBOutlet var colorPreview: UIView?

    override func viewDidLoad(){
        super.viewDidLoad()
    }

    @IBAction func updateColorPreview(sender:UISlider) {
        let r = CGFloat(rSlider!.value / 255.0)
        let g = CGFloat(gSlider!.value/255.0)
        let b = CGFloat(bSlider!.value/255.0)
        let newColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        colorPreview!.backgroundColor = newColor
    }

    @IBAction func sendColorToTock(sender:UISlider) {
        let r = rSlider!.value;
        let g = gSlider!.value;
        let b = bSlider!.value;
        //tock send color
	}
}
