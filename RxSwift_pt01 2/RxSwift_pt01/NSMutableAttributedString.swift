//
//  NSMutableAttributedString.swift
//  RxSwift_pt01
//
//  Created by AutoCrypt on 2020/03/25.
//  Copyright © 2020 Kim-Ju Seong. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    func apply(word: String, attrs: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: word)
        return apply(word: word, attrs:attrs, range: range, last: range)
    }
    
    private func apply(word: String, attrs:[NSAttributedString.Key: Any], range: NSRange, last: NSRange) -> NSMutableAttributedString {
        if range.location != NSNotFound {
            self.addAttributes(attrs, range: range)
            let start = last.location + last.length
            let end = self.string.count - start
            let stringRange = NSRange(location: start, length: end)
            let newRange = (self.string as NSString).range(of: word, options: [], range: stringRange)
            _ = apply(word: word, attrs: attrs, range: newRange, last: range)
        }
        return self
    }
    
}
