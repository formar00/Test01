//
//  ViewController.swift
//  RxSwift_PT01
//
//  Created by AutoCrypt on 2020/03/23.
//  Copyright © 2020 AutoCrypt. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import UserNotifications

class MainVC: UIViewController {

   
    lazy var guideView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        
        return v
    }()
    
    lazy var bringBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Rx - Image", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.layer.borderWidth = 2.0
        return v
    }()
    
    lazy var secondBtn : UIButton = {
          let v = UIButton()
          v.setTitle("Rx - city", for: .normal)
          v.setTitleColor(.black, for: .normal)
          v.layer.borderWidth = 2.0
          return v
      }()
    
    lazy var thirdBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Rx - Operators", for: .normal)
        v.setTitleColor(.black, for: .normal)
        v.layer.borderWidth = 2.0
        return v
    }()
    
    lazy var loginBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Login", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.textAlignment = .center
        v.backgroundColor = .blue
        return v
    }()
    
    
    var num = true
    let content = UNMutableNotificationContent()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Swift"
        customNavi()
        setupView()
        setupRx()
        NotificationCenter.default.post(name: NSNotification.Name("TestNotification"), object: nil, userInfo: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ],
                                                                completionHandler: {didAllow, Error in
                                                                    print(didAllow)
        } )
        
    }
    
    
    func setupView() {
        
        view.addSubview(guideView)
        guideView.addSubview(bringBtn)
        guideView.addSubview(secondBtn)
        guideView.addSubview(thirdBtn)
        guideView.addSubview(loginBtn)
        
        guideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bringBtn.snp.makeConstraints {
            $0.bottom.equalTo(thirdBtn.snp.top).inset(-40)
            $0.left.equalToSuperview().inset(50)
            $0.width.equalTo(130)
        }
        
        secondBtn.snp.makeConstraints {
            $0.bottom.equalTo(thirdBtn.snp.top).inset(-40)
            $0.right.equalToSuperview().inset(50)
            $0.width.equalTo(130)
        }
    
        thirdBtn.snp.makeConstraints {
            $0.bottom.equalTo(loginBtn.snp.top).inset(-40)
            $0.left.equalTo(bringBtn.snp.left)
            $0.width.equalTo(130)
        }
        
        loginBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(60)
        }
        
    }
    
    func setupRx() {
        bringBtn.rx.tap.bind { _ in
            self.pushViewController(ImageLoadVC(), animated: true)
        }.disposed(by: disposeBag)
        
        secondBtn.rx.tap.bind { _ in
            self.pushViewController(RxTableViewVC(), animated: true)
        }.disposed(by: disposeBag)
        
        thirdBtn.rx.tap.bind { _ in
            self.pushViewController(OperatorsVC(), animated: true)
        }.disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind { _ in
            let vc = LoginVC()
            vc.delegate = self
            self.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    func pushViewController(_ vc: UIViewController, animated: Bool ) {
        navigationController?.pushViewController(vc, animated: animated)
    }
    func popViewController(animated: Bool ) {
        navigationController?.popViewController(animated: animated)
    }
    
//    @objc func didTap() {
//        pushViewController(ImageLoadVC(), animated: true)
//    }
//
//    @objc func didTap2() {
//        pushViewController(CityVC(), animated: true)
//    }
//
    
   
}
   
extension UIViewController {
    func customNavi() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
}

extension MainVC : loginVCDelegate {
    func didTabBtn(loginValid: LoginVC.Valid) {
        switch loginValid {
        case .success:
            showToast(message: "로그인 성공")
            content.title = "title: 로그인 성공"
            content.subtitle = "subtitle : 로그인 성공"
            content.body = "body : 메인이동"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        case .fail:
            showToast(message: "로그인 해주세요")

        }
    }
    
    
}
