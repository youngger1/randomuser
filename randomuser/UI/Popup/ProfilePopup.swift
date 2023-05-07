//
//  ProfilePopup.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import UIKit

class ProfilePopup: UIViewController {

    var userData : UserDto?
    
    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_Gender: UILabel!
    @IBOutlet weak var label_Nat: UILabel!
    @IBOutlet weak var label_Email: UILabel!
    @IBOutlet weak var label_Phone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }


    func setupView() {
        
        
    }
    
    func updateView() {
        
        if let data = self.userData {
            
            let name = data.name
            let gender = data.gender
            let nat = data.nat
            label_Name.text = "이름 : \(name.title). \(name.first) \(name.last)"
            label_Gender.text = "성별 : \(gender)"
            label_Nat.text = "국가 : \(nat)"
            
            if let email = data.email {
                label_Email.text = "이메일 : \(email)"
            } else {
                
            }
            
            if let phone = data.phone {
                label_Phone.text = "연락처 : \(phone)"
            } else {
                
            }
            
        }
        
    }

    @IBAction func btnClosePressed(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
}
