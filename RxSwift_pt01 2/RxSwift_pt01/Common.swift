//
//  Common.swift
//  RxSwift_pt01
//
//  Created by 김주성 on 2020/03/23.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation
import UIKit

let largeImgUrl = "https://picsum.photos/1024/768/?random"

let loadingImageUrl = largeImgUrl

func asyncLoadImage(from imgUrl: String, completed: @escaping (UIImage?) -> Void) {
    
    DispatchQueue.global().async {
        
        guard let url = URL(string: imgUrl) else {
            completed(nil)
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            completed(nil)
            return
        }
        
        let image = UIImage(data: data)
        completed(image)
    }
    
}



