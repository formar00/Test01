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
import SnapKit
import RxCocoa

class CityVC: UIViewController {
    
    let allCities = ["NewYork", "London", "Paris", "Osaka", "Osagu", "Seoul"]
    var shownCities = [String]()
    
    
    lazy var serchBar : UISearchBar = {
        let v = UISearchBar()
        return v
    }()
    
    lazy var guideView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var lblCities : UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = .black
        v.text = "city"
        v.textAlignment = .center
        v.numberOfLines = .max
        return v
    }()
    
    
    
    var disposeBag = DisposeBag()
    
    var testText = "Rx swift City"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "City"
        customNavi()
        setupView()
        setupRx()
        
    }
    
    func setupView() {
        
        view.addSubview(guideView)
        guideView.addSubview(serchBar)
        guideView.addSubview(lblCities)
        
        guideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        serchBar.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(100)
            $0.height.equalTo(100)
        }
        
        lblCities.snp.makeConstraints {
            $0.top.equalTo(serchBar.snp.bottom).inset(-80)
            $0.left.right.equalToSuperview().inset(40)
        }
        
        
    }
    
    func setupRx() {
        
        serchBar.rx.text.orEmpty.subscribe(onNext: { [unowned self] query in
            print("query: \(query)")
            self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
            self.lblCities.text = query
            }).disposed(by: disposeBag)
        
        
        serchBar.rx.textDidBeginEditing.subscribe(onNext: { _ in
            self.lblCities.layer.borderWidth = 2.0
            self.lblCities.layer.borderColor = UIColor.red.cgColor
            }).disposed(by: disposeBag)
        
        
        
//        searchBar
//            .rx.text
//            .orEmpty
//            .subscribe(onNext: { [unowned self] query in // subscribe
//                print("query: \(query)")
//                self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
//                self.lblCities.text = shownCities
//            })
//            .disposed(by: disposeBag)
//
//        searchBar
//            .rx.text
//            .orEmpty
//            .debounce(0.5, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .filter({ !$0.isEmpty })
//            .subscribe(onNext: { [unowned self] query in
//                self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
//                self.lblCities.text = shownCities
//            })
//            .disposed(by: disposeBag)
        
    }
}
