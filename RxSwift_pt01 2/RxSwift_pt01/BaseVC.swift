//
//  BaseVC.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/01.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toast_Swift
import UserNotifications

class BaseVC: UIViewController {
    
    lazy var layoutGuideView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetupView()
        view.backgroundColor = .white
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ],
                                                                completionHandler: {didAllow, Error in
                                                                    print(didAllow)
        } )
    }
    
    
    private func layoutSetupView() {
        view.addSubview(layoutGuideView)
        
        
        layoutGuideView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func layoutGuideViewBringToFront() {
        view.bringSubviewToFront(layoutGuideView)
    }
    func pushViewController(_ vc: UIViewController, animated: Bool = true) {
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        view.endEditing(true)
        navigationController?.popViewController(animated: animated)
    }
    
    func showAlert(title: String, message:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
}
