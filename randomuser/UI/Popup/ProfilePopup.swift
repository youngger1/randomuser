//
//  ProfilePopup.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import UIKit

class ProfilePopup: UIViewController {

    var userData : UserDto?
    
    
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
            
            
        }
        
    }

    @IBAction func btnClosePressed(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
}
