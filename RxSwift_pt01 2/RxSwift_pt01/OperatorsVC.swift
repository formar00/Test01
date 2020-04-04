//
//  OperatorsVC.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/03/24.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit


class OperatorsVC : UIViewController {
    
    lazy var layoutView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    var lable = UIButton()
    var lable2 = UIButton()
    var lable3 = UIButton()
    var lable4 = UIButton()
    var lable5 = UIButton()
    var lable6 = UIButton()
    
    lazy var stackview: UIStackView = {
        let v = UIStackView(arrangedSubviews: [lable,lable2,lable3,lable4,lable5,lable6])
        v.axis = .vertical
        v.distribution = .fillEqually
        
        lable.setTitle("exJust", for: .normal)
        lable2.setTitle("exFrom", for: .normal)
        lable3.setTitle("exMap", for: .normal)
        lable4.setTitle("exMap2", for: .normal)
        lable5.setTitle( "exFilter", for: .normal)
        lable6.setTitle( "exMap3", for: .normal)
        
        lable.titleLabel?.textAlignment = .center
        lable2.titleLabel?.textAlignment = .center
        lable3.titleLabel?.textAlignment = .center
        lable4.titleLabel?.textAlignment = .center
        lable5.titleLabel?.textAlignment = .center
        lable6.titleLabel?.textAlignment = .center
        
        lable.setTitleColor(.black, for: .normal)
        lable2.setTitleColor(.black, for: .normal)
        lable3.setTitleColor(.black, for: .normal)
        lable4.setTitleColor(.black, for: .normal)
        lable5.setTitleColor(.black, for: .normal)
        lable6.setTitleColor(.black, for: .normal)
        
        lable.layer.borderWidth = 1.0
        lable2.layer.borderWidth = 1.0
        lable3.layer.borderWidth = 1.0
        lable4.layer.borderWidth = 1.0
        lable5.layer.borderWidth = 1.0
        lable6.layer.borderWidth = 1.0
        
        return v
    }()
    
    lazy var img : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    lazy var lableWindow : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = .max
        return v
    }()
    
    lazy var tf: UITextField = {
        let v = UITextField()
        
        return v
    }()
    
    var disposeBag = DisposeBag()
    var arr : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Observable"
        customNavi()
        setupView()
        setupRx()
    }
    
    func setupView() {
        view.addSubview(layoutView)
        layoutView.addSubview(stackview)
        layoutView.addSubview(img)
        layoutView.addSubview(lableWindow)
        
        layoutView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackview.snp.makeConstraints {
            $0.top.equalTo(layoutView.snp.top).inset(100)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        img.snp.makeConstraints {
            $0.top.equalTo(stackview.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        lableWindow.snp.makeConstraints {
            $0.top.equalTo(img.snp.bottom).inset(-50)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
    }
    
    func setupRx() {
        
        lable.rx.tap.bind{ [unowned self] in
            Observable.just("Hellow").subscribe(onNext: { str in
                self.lableWindow.text = str
            })
        }.disposed(by: disposeBag)
        
        lable2.rx.tap.bind { [unowned self] in
            Observable.from(["RxSwift", "In", 4 , "Hours"])
                .subscribe(onNext: { str in
                    self.lableWindow.text = "\(str)"
                })
        }.disposed(by: disposeBag)
        
        lable3.rx.tap.bind { [unowned self] in
            self.arr.removeAll()
            Observable.just("Hello")
                .map { str in "\(str) RxSwift" }
                .subscribe(onNext: { str in
                    self.arr.append(str)
                    self.lableWindow.text = "\(self.arr)"
                })
        }.disposed(by: disposeBag)
        
        lable4.rx.tap.bind { [unowned self] in
            self.arr.removeAll()
            Observable.from(["with", "iOS"])
                .map { $0.count }
                .subscribe(onNext: { str in
                    self.arr.append(str)
                    self.lableWindow.text = "\(self.arr)"
                })
        }.disposed(by: disposeBag)
        
        lable5.rx.tap.bind { [unowned self] in
            self.arr.removeAll()
            Observable.from([1,2,3,4,5,6,7,8,9,10])
                .filter { $0 % 2 == 0 }
                .subscribe(onNext: { n in
                    self.arr.append(n)
                    self.lableWindow.text = "\(self.arr)"
                })
        }.disposed(by: disposeBag)
        
        lable6.rx.tap.bind { [unowned self] in
            self.img.image = nil
            
            Observable.just("800x600")
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .map { $0.replacingOccurrences(of: "x", with: "/") }
                .map { "https://picsum.photos/\($0)/?random"}
                .map { URL(string: $0) }
                .filter { $0 != nil }
                .map { $0! }
                .map { try Data(contentsOf: $0) }
                .map { UIImage(data: $0 ) }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { image in
                    self.img.image = image
            })
        }.disposed(by: disposeBag)
        
        
    }
    
}
