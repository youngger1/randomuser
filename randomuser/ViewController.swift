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
    
    @IBOutlet weak var view_NoData: UIView!
    
    var ArrayCheckBox : [UIImageView] = []
    var pageCount: Int = 0
    let resultsCount : Int = 10
    var genderIndex : Int = 0
    
    var infiniteScroll = false
    
    var usersData : [UserDto] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.usersData.count > 0 {
                    
                    self.view_NoData.isHidden = true
                    
                    self.usersTabelView.reloadData()
                    
                    if self.pageCount == 0 {
                        // pageCount 0 일때 tableView 최상단으로 이동
                        self.usersTabelView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                    
                } else {
                    print(TAG, "User 정보가 없습니다.")
                    
                    self.view_NoData.isHidden = false
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
    
    /**
        API 호출
        gender : nil - 전체 / male - 남성 / female - 여성
        page :  페이지 인덱스
        results : 한 페이지 결과 노출 값 : 기본 10
        isShowProgress : indicator 노출 여부
     */
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
                
                var dummyData : [UserDto] = []
                
                for item in data.results {
                    
                    if !self.usersData.contains(where: { user in
                        
                        // 성별 , 이름, 국적 모두 같은 경우 동일 인물 처리
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
    
    // indicator show & start
    func showProgress() {
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
    }
    
    // indicator hide & stop
    func hideProgress() {
        
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
        
    }
    
    // 성별 체크박스 tag 값에 따른 이미지 변경
    func changeCheckBox(tag : Int) {
        for checkBox in ArrayCheckBox {
            if checkBox.tag == tag {
                checkBox.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                checkBox.image = UIImage(systemName: "circle")
            }
        }
        
    }
    
    /**
        성별 tag 값과 indicator  노출 여부에 따른 API 호출
     */
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
    
    
    // 성별 버튼 이벤트
    @IBAction func btnGenderPressed(_ sender: Any) {
        
        print(#function)
        let tag = (sender as! UIButton).tag
        print("tag : \(tag)")
        
        self.pageCount = 0
        self.genderIndex = tag
        self.changeCheckBox(tag: tag)
        self.requestAPI(tag: tag, isShowProgress: true)
        
        
        
        
    }
    
    // pull 업데이트
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
        
        if let thumbnail = item.picture?.thumbnail {
            cell.image_profile.setProfileImageGET(urlString: thumbnail) { image in
            }
        } else {
            cell.image_profile.image = UIImage(systemName: "person.circle.fill")
        }
        
        
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
        
        let contentOffset = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentOffset > contentSizeHeight - frameHeight
        {
            if !infiniteScroll {
                infiniteScroll = true
                print(TAG, #function, "down")
                pageCount += 1
                requestAPI(tag: self.genderIndex, isShowProgress: true)
                
            }
        }
        
    }
    
    
}

