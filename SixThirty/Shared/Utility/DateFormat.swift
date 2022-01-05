//
//  DateFormat.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2022/1/4.
//

import Foundation
import DateHelper

enum Formatter {
    static func formatDateInterval(_ dateInterval: Int64) -> String {
        let interval = Double(dateInterval)
        let date = Date(timeIntervalSince1970: interval)
        
        let now = Date()
        let days = now.since(date, in: .day)
        let hours = now.since(date, in: .hour)
        
        if days == 1 {
            return "\(hours)小时前"
        }
        
        if days == 2 {
            return "前天 \(date.toString(format: .custom("HH:mm")))"
        }

        if days < 7 {
            return "\(days)天前"
        }
        
        return date.toString(format: .custom("yyyy年MM月dd日"))
    }
}
