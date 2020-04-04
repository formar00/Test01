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
import RxGesture

class ImageLoadVC: UIViewController {

    var textLable : String?
    var counter = 0
    
    
    lazy var guideView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        
        return v
    }()
    
    lazy var imgView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    lazy var timerLabel : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        
        return v
    }()
    
    lazy var bringBtn : UIButton = {
        let v = UIButton()
        v.setTitle("불러오기", for: .normal)
        v.setTitleColor(.black, for: .normal)
//        v.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        v.layer.borderWidth = 2.0
        return v
    }()
    
    lazy var cancleBtn : UIButton = {
        let v = UIButton()
        v.setTitle("취소하기", for: .normal)
        v.setTitleColor(.black, for: .normal)
//        v.addTarget(self, action: #selector(didTap2), for: .touchUpInside)
        v.layer.borderWidth = 2.0
        return v
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        v.center = self.view.center
        v.hidesWhenStopped = false
        v.style = .gray
        v.isHidden = true
        return v
        
    }()
    
    lazy var fullImgView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .black
        
        return v
    }()
    
    var didsetCount: Int = 1 {
           didSet (ov) {
                print("현재 카운트 = \(didsetCount), 이전 카운트 = \(ov)")
            print(UUID())
           }
       }
    
    var disposeBag : DisposeBag = DisposeBag()
    var disposeBle : Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rx"
        customNavi()
        timer()
        someFunction()
        someSequence()
        setupView()
        setupRx()
        
    }
    
    func timer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.timerLabel.text = "\(self.counter)"
        }
    }
    
    func setupView() {
        
        view.addSubview(guideView)
        guideView.addSubview(imgView)
        guideView.addSubview(timerLabel)
        guideView.addSubview(bringBtn)
        guideView.addSubview(cancleBtn)
        guideView.addSubview(indicator)
        
        guideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        imgView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(100)
            $0.height.equalTo(300)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(400)
            $0.right.equalToSuperview().inset(50)
        }
        
        bringBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(480)
            $0.left.equalToSuperview().inset(50)
            $0.width.equalTo(130)
        }
        
        cancleBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(480)
            $0.right.equalToSuperview().inset(50)
            $0.width.equalTo(120)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(400)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        
        
    }
    
//    //취소버튼
//    @objc func didTap2() {
//        indicator.stopAnimating()
//        indicator.isHidden = true
//        disposeBag = DisposeBag()
//
    //    }
    
    func setupRx() {
        
        //불러오기 버튼 탭
        bringBtn.rx.tap.bind { _ in
            self.didsetCount += 1
            self.imgView.image = nil
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.bringBtn.setTitle("불러오는중...", for: .normal)
            self.rxswiftLoadImage(from: loadingImageUrl)
                .observeOn(MainScheduler.instance)
                .subscribe({ result in
                    switch result {
                    case let .next(image):
                        self.imgView.image = image
                        self.indicator.isHidden = true
                        self.bringBtn.setTitle("불러오기", for: .normal)
                    case let .error(err):
                        print(err.localizedDescription)
                        
                    case .completed:
                        break
                    }
                    
                }).disposed(by: self.disposeBag)
        }
        //이미지 탭 버튼
            imgView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
                if self.imgView.image != nil {
                    self.imgFullScreen()
                }
                }).disposed(by: disposeBag)
        
        
        //cancle 버튼 탭
       cancleBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.bringBtn.setTitle("불러오기", for: .normal)
            self.disposeBag = DisposeBag()
        })
        disposeBle?.dispose()
        
    
    }
    
    func imgFullScreen() {
        let imgVC = ImageModalVC(image: imgView.image)
        imgVC.modalPresentationStyle = .fullScreen
        present(imgVC,animated: true)
        
    }
    
    
    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    func someSequence() {
        let stringSQ = Observable.just("this is string")
        let oddSQ = Observable.from([1,3,5,7,9])
        let dictSQ =  Observable.from([1:"Rx",
                                       2:"Swift"])
        
        let subscription = stringSQ.subscribe { (event: Event<String>) in
            print(event)
        }
        let subscription2 = oddSQ.subscribe{ (event: Event<Int>) in
            print(event)
        }
        
        let subscription3 = dictSQ.subscribe { (event: Event<(key: Int, value: String)>) in
            print(event)
        }
        
        let disposeBag = DisposeBag()
        
        subscription.disposed(by: disposeBag)
        subscription2.disposed(by: disposeBag)
        subscription3.disposed(by: disposeBag)
        
        Observable.just("simple String")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        
        
    }
    
   
    func inputText() -> String {
        return "input"
    }
    
    func someFunction() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let text = self.inputText()
            
            DispatchQueue.main.async {
                self.textLable = text
                print(self.textLable ?? "")
            }
        }
        
    }
    

}
