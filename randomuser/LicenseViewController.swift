//
//  LicenseViewController.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/07.
//

import UIKit
import SafariServices

class LicenseViewController: UIViewController {
    
    
    @IBOutlet weak var Lable_Title: UILabel!
    @IBOutlet weak var Label_link: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        
        Lable_Title.text = "onevcat/Kingfisher (7.6.2)"
        
        
        let text = "https://github.com/onevcat/Kingfisher"
        
        let attributeString = NSMutableAttributedString(string: text)
        
        attributeString.addAttribute(.link, value: "https://github.com/onevcat/Kingfisher", range: NSRange(location: 0, length: text.count))
        
        
        Label_link.attributedText = attributeString
        
        Label_link.isUserInteractionEnabled = true
        
        let clickLink = UITapGestureRecognizer(target: self, action: #selector(clickLink))
        
        Label_link.addGestureRecognizer(clickLink)
    }
    
    
    @IBAction func btnClosePressed(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
    
    
    @objc func clickLink(sender: UITapGestureRecognizer) {
        print(#function)
        
        
        
        guard let url = URL(string: "https://github.com/onevcat/Kingfisher") else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        
        present(safariViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
