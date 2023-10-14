//
//  DataExtension.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import UIKit

extension Data {
    func parser<T>(options opt: JSONSerialization.ReadingOptions = []) throws -> T? {
        try JSONSerialization.jsonObject(with: self, options: opt) as? T
    }
    
}

