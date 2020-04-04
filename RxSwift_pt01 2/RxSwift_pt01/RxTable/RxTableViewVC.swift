//
//  RxTableViewVC.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/01.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class RxTableViewVC: BaseVC {
    
    lazy var rxTable: UITableView = {
        let v = UITableView()
        v.register(RxTableViewCell.self, forCellReuseIdentifier: RxTableViewCell.id)
        v.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        
        return v
    }()
    
    
    let viewModel : RxTableViewModel = RxTableViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        title = "RxTable"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindTableView()
        setupRx()
        
        
    }
    
    func setupView() {
        layoutGuideView.addSubview(rxTable)
        
        rxTable.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }
    }
    
    func setupRx() {
        rxTable.rx.setDelegate(self).disposed(by:disposeBag)
    }
    
    private func bindTableView() {
        let city = ["London","Paris","Seoul"]
        let citiesOb: Observable<[String]> = Observable.of(city)
      
        viewModel.cityList().bind(to: rxTable.rx.items(cellIdentifier: RxTableViewCell.id)) { (row, element, cell: RxTableViewCell) in
            cell.stconfigure(cityList: element)
//        citiesOb.bind(to: rxTable.rx.items(cellIdentifier: RxTableViewCell.id)) { (row, item, cell: RxTableViewCell) in
        
//            cell.configure(item: item, imgColor: .black)
//            cell.textLabel?.text = item
        
//        citiesOb.bind(to: rxTable.rx.items) {( tv, row, item) -> RxTableViewCell in
//
//                let cell = tv.dequeueReusableCell(withIdentifier: RxTableViewCell.id, for: IndexPath.init(row: row, section: 0))
//
//                cell.textLabel?.text = item
//
            
        
            
//        citiesOb.bind(to: rxTable.rx.items) { (rxTable:UITableView, index: Int, element: String) -> RxTableViewCell in
//            guard let cell = rxTable.dequeueReusableCell(withIdentifier: RxTableViewCell.id)
//                else { return RxTableViewCell() }
//
//            cell.textLabel?.text = element
//            cell.textLabel?.textColor = .black
//            cell.textLabel?.textAlignment = .left
//
//            return cell as! RxTableViewCell
        }.disposed(by: disposeBag)
    }
    
    
}

extension RxTableViewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct List {
    var city : String
    var color : UIColor
}
