//
//  JodoRegex.swift
//  jodoSDK
//
//  Created by jodo on 15/10/8.
//  Copyright © 2015年 jodo. All rights reserved.
//

import Foundation

struct RegexHelper {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try! NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
            options: NSMatchingOptions.Anchored,
            range: NSMakeRange(0, input.characters.count)) {
                return matches.count > 0
        } else {
            return false
        }
    }
}