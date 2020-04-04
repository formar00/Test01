//
//  RootVC.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/01.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Reachability

//네트워크 연결 체크

class RootVC : UINavigationController , ReachabilityObserverDelegate{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        try? addReachabilityObserver()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeReachabilityObserver()
    }
    
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable,
            let lastVC = viewControllers.last,
            !(lastVC is MainVC) {
            showNetworkAlert()
        }
    }
    
    func showNetworkAlert() {
        let vc = UIAlertController(title:"네트워크 연결 실패", message: "네트워크 연결상태 확인요청", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default) { _ in
                                        exit(0)
        }
        
        vc.addAction(action)
        
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
}
