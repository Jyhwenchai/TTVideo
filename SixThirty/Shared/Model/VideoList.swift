//
//  VideoList.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2022/1/4.
//

import Foundation
//import DateHelper

struct VideoList {
    var videos: [Video]
    var next: Next
    
    init() {
        videos = []
        next = .default()
    }
}

struct Next {
    var hasMore: Bool
    var maxBehotTime: Int64
    
    static func `default`() -> Next {
        .init(hasMore: false, maxBehotTime: 0)
    }
}

