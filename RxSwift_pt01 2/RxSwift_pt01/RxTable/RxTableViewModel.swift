//
//  RxTableViewModel.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/04/02.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import RxSwift

class RxTableViewModel {
    
    let model: cityListModel
    
    init(model: cityListModel = cityListModel()) {
        self.model = model
    }
    
    func cityList() -> Observable<[CityList]> {
        return Observable<[CityList]>.create { [unowned self] observe in
            let list = self.model.makeCityList()
            if list.count > 0 {
                observe.onNext(list)
            } else {
                
            }
            observe.onCompleted()
            return Disposables.create()
        }
    }
    
}
