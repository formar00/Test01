//
//  RxTableViewCell.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/02.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import RxSwift
import RxGesture


class RxTableViewCell: UITableViewCell {
    
    static let id = "RxCell"
    
    lazy var Img: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .systemBlue
        return v
    }()
    
    lazy var label: UILabel = {
        let v = UILabel()
        
        return v
    }()
    
    lazy var infolabel: UILabel = {
           let v = UILabel()
           
           return v
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(Img)
        addSubview(label)
        addSubview(infolabel)
        
        Img.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(30)
            $0.width.equalTo(Img.snp.height)
        }
        
        label.snp.makeConstraints {
            $0.left.equalTo(Img.snp.right).offset(30)
            $0.centerY.equalTo(Img)
            $0.right.equalToSuperview()
        }
        infolabel.snp.makeConstraints {
            $0.left.equalTo(label.snp.left)
            $0.top.equalTo(label.snp.bottom).inset(-10)
            $0.right.equalToSuperview()
            
        }
        
    }
    
    func configure(item: String, imgColor: UIColor) {
        Img.backgroundColor = imgColor
        label.textColor = .darkGray
        label.text = item
    }
    
    func stconfigure(cityList: CityList) {
        Img.backgroundColor = cityList.imgColor
        label.text = cityList.name
        infolabel.text = cityList.time
    
    }
}
