//
//  ViewController.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usersTabelView: UITableView!
    
    
    var usersData : [UserDto] = [] {
        didSet {
            DispatchQueue.main.async {
                
                if self.usersData.count > 0 {
                    
                    self.usersTabelView.reloadData()
                    
                } else {
                    print(TAG, "User 정보가 없습니다.")
                }
                
            }
        }
    }
    
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
        print(#function)
        
        usersTabelView.delegate = self
        usersTabelView.dataSource = self
        usersTabelView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        
        
    }
    
    func updateView() {
        print(#function)
        
        ApiController.shared.randomUser(gender: nil) { data in
            print("success : \(data)")
        
            DispatchQueue.main.async {
                
                    self.usersData = data.results
                
                
            }
            
        } onFailure: { error in
            print("error : \(error)")
        }

    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.usersData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell",for: indexPath) as! UserTableViewCell
        
        let item = self.usersData[indexPath.row]
        
        let name = item.name
        let gender = item.gender
        
        cell.label_Name.text = "이름 : \(name.title). \(name.first) \(name.last)"
        
        cell.label_Gender.text = "성별 : \(gender)"
        
        cell.label_Nat.text = "국가 : \(item.nat)"
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(#function , "indexpath.row : \(indexPath.row)")
        
        let item = self.usersData[indexPath.row]
        
        let popup = ProfilePopup(nibName: "ProfilePopup", bundle: nil)
        popup.modalPresentationStyle = .overFullScreen
        popup.userData = item
        
        self.present(popup, animated: false)
        
        
        
    }


}

