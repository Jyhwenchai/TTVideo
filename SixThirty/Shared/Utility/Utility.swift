//
//  Utility.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/24.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
