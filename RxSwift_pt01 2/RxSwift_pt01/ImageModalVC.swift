//
//  ImageModalVC.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/03/26.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ImageModalVC: UIViewController {
    
    lazy var guideView : UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 1.0
        return v
    }()
    
    lazy var imgView : UIImageView = {
        let v = UIImageView()
        v.image = image
        v.contentMode = .scaleAspectFit
        v.alpha = 1.0
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    lazy var closeBtn : UIButton = {
        let v = UIButton()
        v.setTitle("X", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.textAlignment = .center
        
        return v
    }()
    
    
    var image : UIImage?
    var disposeBag = DisposeBag()
    
    init(image:UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        setupView()
        setupRx()
        
    }
    
    func setupView() {
        view.addSubview(guideView)
        guideView.addSubview(imgView)
        guideView.addSubview(closeBtn)
        
        guideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
            
        imgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(100)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        closeBtn.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(30)
            $0.width.height.equalTo(40)
        }
    }
    
    func setupRx() {
        //배경색
        imgView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.currentBackColor()
        })
            .disposed(by: disposeBag)
        
        //이미지 스와이프
        imgView.rx.swipeGesture(.down)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        //버튼 탭
        closeBtn.rx.tap.bind { _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    func currentBackColor() {
        if guideView.backgroundColor == UIColor.black {
            guideView.backgroundColor = .white
            closeBtn.setTitleColor(.black, for: .normal)
        } else {
            guideView.backgroundColor = .black
            closeBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    
    
}
