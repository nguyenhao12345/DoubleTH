//
//  RangeIntegerPropertyWapper.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import Foundation

@propertyWrapper
struct RangeIntegerPropertyWapper {
    var wrappedValue: Int? {
        get {
            return storageValue
        }
        set {
            guard let newValue = newValue else {
                storageValue = nil
                return
            }
            if newValue < min { storageValue = min }
            else if newValue > max { storageValue = max }
            storageValue = newValue
        }
    }

    private var max: Int
    private var storageValue: Int?
    private let min = 0

    init(max: Int) {
        if max <= min { self.max = 1 }
        else if max >= Int.max { self.max = Int.max - 1 }
        else { self.max = max }
    }
}
