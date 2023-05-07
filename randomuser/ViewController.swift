//
//  ViewController.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usersTabelView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var ivCheckBox1: UIImageView!
    @IBOutlet weak var ivCheckBox2: UIImageView!
    @IBOutlet weak var ivCheckBox3: UIImageView!
    
    var ArrayCheckBox : [UIImageView] = []
    var pageCount: Int = 0
    let resultsCount : Int = 10
    var genderIndex : Int = 0
    
    var infiniteScroll = false
    
    var usersData : [UserDto] = [] {
        didSet {
            DispatchQueue.main.async {
                print("self.usersData.count : \(self.usersData.count)")
                if self.usersData.count > 0 {

                    self.usersTabelView.reloadData()
                    
                    if self.pageCount == 0 {
                        self.usersTabelView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }

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
        usersTabelView.refreshControl = UIRefreshControl()
        usersTabelView.refreshControl?.addTarget(self, action: #selector(pullToUpdate(_:)), for: .valueChanged)
        
        ArrayCheckBox = [ivCheckBox1 , ivCheckBox2, ivCheckBox3]
        
    }
    
    func updateView() {
        print(#function)
        
        callAPI(gender: nil, page: pageCount, results: resultsCount, isShowPrgoress: true)
    }
    
    func callAPI(gender: String? , page : Int, results : Int, isShowPrgoress : Bool){
        
        if isShowPrgoress {
            showProgress()
        }
        
        print(#function , "page : \(page)")
        ApiController.shared.randomUser(gender: gender, page: page, results: results) { data in
            print("success : \(data)")
        
            DispatchQueue.main.async {
                if isShowPrgoress {
                    self.hideProgress()
                }
                //
                var dummyData : [UserDto] = []
                
                for item in data.results {
                    
                    if !self.usersData.contains(where: { user in
                     
                        if item.gender == user.gender && item.name.title == user.name.title && item.name.first == user.name.first && item.name.last == user.name.last && item.nat == user.nat {
                            
                            return true
                        }
                        
                        return false
                        
                    }) {
                        
                        dummyData.append(item)
                    }
                }
                
                if page == 0 {
                    self.usersData = dummyData
                } else {
                    self.usersData.append(contentsOf: dummyData)
                }
                
                
                //
                
//                if page == 0 {
//                    self.usersData = data.results
//                } else {
//                    self.usersData.append(contentsOf: data.results)
//                }
                
                self.usersTabelView.refreshControl?.endRefreshing()
                
                self.infiniteScroll = false
            }
            
        } onFailure: { error in
            DispatchQueue.main.async {
                if isShowPrgoress {
                    self.hideProgress()
                }
                print("error : \(error)")
                self.usersTabelView.refreshControl?.endRefreshing()
            }
        }

        
        
    }
    
    func showProgress() {
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
    }
    
    func hideProgress() {
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
        
    }
    
    func changeCheckBox(tag : Int) {
        for checkBox in ArrayCheckBox {
            if checkBox.tag == tag {
                checkBox.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                checkBox.image = UIImage(systemName: "circle")
            }
        }
        
    }
    
    func requestAPI(tag : Int, isShowProgress : Bool) {
        
        
        if tag == 0 {
            // 전체 ( male & female )
            self.callAPI(gender: nil, page: pageCount, results: resultsCount, isShowPrgoress: isShowProgress)
            
        } else if tag == 1 {
            // 남성 ( male )
            self.callAPI(gender: "male", page: pageCount, results: resultsCount, isShowPrgoress: isShowProgress)
            
        } else if tag == 2 {
            // 여성 ( female )
            self.callAPI(gender: "female", page: pageCount, results: resultsCount, isShowPrgoress: isShowProgress)
        }
        
    }
    
   
    
    @IBAction func btnGenderPressed(_ sender: Any) {
        
        print(#function)
        let tag = (sender as! UIButton).tag
        print("tag : \(tag)")
       
        self.pageCount = 0
        self.genderIndex = tag
        self.changeCheckBox(tag: tag)
        self.requestAPI(tag: tag, isShowProgress: true)
        
    
        
        
    }
    
    @objc func pullToUpdate(_ sneder: Any) {
        
        self.pageCount = 0
        self.requestAPI(tag: self.genderIndex, isShowProgress: false)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        
//        let contentOffset = scrollView.contentOffset.y
//        let contentSizeHeight = scrollView.contentSize.height
//        let frameHeight = scrollView.frame.height
//
//        if contentOffset > contentSizeHeight - frameHeight
//        {
//            print(#function, "down")
//            pageCount += 1
//            requestAPI(tag: self.genderIndex, isShowProgress: true)
//
//        }
        
//        if scrollView == usersTabelView { return }
//
//        if ((scrollView.contentOffset.y+scrollView.frame.height) / scrollView.contentSize.height) > 0.9 {
//            // 내릴때
////            if isProgressing == false {
////                isProgressing = true
//
//            pageCount += 1
//            requestAPI(tag: self.genderIndex, isShowProgress: true)
////            }
//        }

        
        
        let contentOffset = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentOffset > contentSizeHeight - frameHeight
        {
            
            if !infiniteScroll {
                infiniteScroll = true
                print(#function, "down")
                pageCount += 1
                requestAPI(tag: self.genderIndex, isShowProgress: true)
                
            }
        }
        
    }


}

