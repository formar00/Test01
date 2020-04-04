//
//  LoginVC.swift
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
import RxGesture
import Toast_Swift

protocol loginVCDelegate {
    func didTabBtn(loginValid: LoginVC.Valid)
}

class LoginVC: UIViewController {
    
    enum Valid {
        case success
        case fail
    }
    
    lazy var guideView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var emailTextField: UITextField = {
        let v = UITextField()
        v.placeholder = "E-mail"
        v.textAlignment = .left
        v.layer.borderWidth = 1.0
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        v.leftViewMode = .always
        v.keyboardType = .emailAddress
        return v
    }()
    
    
    lazy var passwordTextField: UITextField = {
        let v = UITextField()
        v.placeholder = "Password"
        v.textAlignment = .left
        v.layer.borderWidth = 1.0
        v.isSecureTextEntry = true
        v.keyboardType = .numberPad
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        v.leftViewMode = .always
        return v
    }()
    
    lazy var emailCheck: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.contentMode = .scaleToFill
        
        return v
    }()
    
    lazy var passwordCheck: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.contentMode = .scaleToFill
        
        return v
    }()
    
    lazy var loginBtn: UIButton = {
        let v = UIButton()
        v.setTitle("로그인", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.textAlignment = .center
        v.backgroundColor = .lightGray
        v.isEnabled = false
        
        
        return v
    }()
    
    lazy var label : UILabel = {
        let v = UILabel()
        return v
    }()
    
    lazy var colorBtn : UIButton = {
        let v = UIButton()
        v.setTitle("color", for: .normal)
        v.setTitleColor(.black, for: .normal)
        return v
    }()
    
    var disposeBag = DisposeBag()
    var delegate : loginVCDelegate?
    
    let emaildb = "A@a.io"
    let password = "0000"
    
    let notifiCenter = NotificationCenter.default
    var observer: NSObjectProtocol?
    
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let idInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let redKey = "Red"
    let greenKey = "green"
    let yellowKey = "yellow"
    let orangeKey = "orange"
    let blackKey = "black"
    
    let arr = [5,4,3,2,1,6]
    var arrArr : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        customNavi()
        setupView()
        bindUI()
     
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func didEnterBackground() {
        print("didEnterBackground")
    }
    
    @objc func willEnterForeground() {
        print("willEnterForeground")
    }
    
    func setupView() {
        
        view.addSubview(guideView)
        guideView.addSubview(emailTextField)
        guideView.addSubview(passwordTextField)
        emailTextField.addSubview(emailCheck)
        passwordTextField.addSubview(passwordCheck)
        guideView.addSubview(loginBtn)
        
        
        guideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-40)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        
        emailCheck.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.width.height.equalTo(15)
        }
        
        passwordCheck.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.width.height.equalTo(15)
        }
        
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).inset(-80)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
        
       
    }
    
    func bindUI() {
        
        //        emailTextField.rx.text.orEmpty
        //            .bind(to: idInputText)
        //            .disposed(by: disposeBag)
        //
        //        idInputText
        //            .map(checkEmailValid)
        //            .bind(to: idValid)
        //            .disposed(by: disposeBag)
        //
        //        passwordTextField.rx.text.orEmpty
        //            .bind(to: pwInputText)
        //            .disposed(by: disposeBag)
        //
        //        pwInputText
        //            .map(checkPasswordValid)
        //            .bind(to: pwValid)
        //            .disposed(by: disposeBag)
        //
        //        idValid.subscribe(onNext: { b in
        //            self.emailCheck.isHidden = b
        //        }).disposed(by: disposeBag)
        //
        //        pwValid.subscribe(onNext: { b in
        //            self.passwordCheck.isHidden = b
        //        }).disposed(by: disposeBag)
        //
        //        Observable.combineLatest(idValid,pwValid, resultSelector: { $0 && $1 } )
        //            .subscribe(onNext: { b in self.loginBtnEnable(b) })
        //            .disposed(by: disposeBag)
        //
        
        // 이메일 텍스트 필드
        emailTextField.rx.text.orEmpty
            .map(checkEmailValid)
            .subscribe(onNext: { b in
                self.emailCheck.isHidden = b
            })
            .disposed(by: disposeBag)
        
        //비밀번호 텍스트 필드
        passwordTextField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { b in
                self.passwordCheck.isHidden = b
            })
            .disposed(by: disposeBag)
        
        
        
        //이메일 비번 유효한지 체크
        Observable.combineLatest(
            emailTextField.rx.text.orEmpty.map(checkEmailValid),
            passwordTextField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1,s2 in s1 && s2 }
        )
            .subscribe(onNext: { b in
                self.loginBtnEnable(b)
            })
            .disposed(by: disposeBag)
        
        //로그인 버튼 탭 액션
        loginBtn.rx.tap.bind { [unowned self] in
            if self.emailTextField.text == self.emaildb && self.passwordTextField.text == self.password {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didTabBtn(loginValid: .success)
            }else if self.emailTextField.text == self.emaildb && self.passwordTextField.text != self.password {
                self.showToast(message: "비번 확인 필요.")
                self.delegate?.didTabBtn(loginValid: .fail)
            }else if self.emailTextField.text != self.emaildb && self.passwordTextField.text == self.password {
                self.showToast(message: "이메일 확인 필요.")
                self.delegate?.didTabBtn(loginValid: .fail)
            }else {
                self.showToast(message: "이메일 , 비번 확인 필요")
                self.delegate?.didTabBtn(loginValid: .fail)
            }
        }.disposed(by: disposeBag)
        
        //바닥터치 내리기
        guideView.rx.anyGesture(.tap(), .swipe(direction: .down))
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.view.endEditing(true)
                self.arrArr.removeAll()
                self.arrArr.append(contentsOf: self.arr.sorted { $0 > $1 } )
                print(self.arrArr)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    // 이메일 & 비번 유효 체크
    private func loginCheck(email: String, pw:String) -> Bool {
        return email == emaildb && pw == password
    }
    
    // 로그인 버튼 활성화 체크
    private func loginBtnEnable(_ b: Bool) {
        loginBtn.isEnabled = b
        if b == true {
            loginBtn.backgroundColor = .blue
        }else{
            loginBtn.backgroundColor = .lightGray
        }
    }
    
    // 이메일 유효 체크
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    //비번 유효 체크
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count >= 4
    }
    
}

extension UIViewController {
    func showToast(title: String? = nil, message: String, duration: Double = 1.5, position: ToastPosition = .center, _ completion: ((_ didTap: Bool) -> Void)? = nil) {
        view.makeToast(message,
                       duration: duration,
                       position: position,
                       title: title,
                       image: nil,
                       style: .init(),
                       completion: { didTap in
                        if let c = completion {
                            c(didTap)
                        }})
    }
}
