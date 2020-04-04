//
//  RxTableModel.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/02.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit

struct CityList {
    let name: String
    let imgColor: UIColor
    let time: String
}

struct cityListModel {
    
    func makeCityList() -> [CityList] {
        return [
            CityList(name: "Seoul", imgColor: .blue, time: "14:00"),
            CityList(name: "Tokyo", imgColor: .red, time: "14:00"),
            CityList(name: "China", imgColor: .orange, time: "12:00"),
            CityList(name: "London", imgColor: .gray, time: "04:00"),
            CityList(name: "Paris", imgColor: .brown, time: "02:00")
        
        ]
    }
}
