import UIKit
import WebKit

class ContactViewController : WebViewController {
    
    override func viewDidLoad() {
        self.url = "https://www.freightroll.com/pages/contact"
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "CONTACT US"
    }
}

