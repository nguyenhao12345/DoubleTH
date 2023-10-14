//
//  APIHelper.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import Foundation

public struct APIHelper {
    public enum EndPoint {
        case test
        case custom(String)
        
        var text: String {
            switch self {
            case .test:
                return Environment.testEndPoint
            case .custom(let text):
                return text
            }
        }
    }
    
    public struct Header {
        public struct Key {
            public static let ContentType = "Content-Type"
            public static let Authorization = "Authorization"
            public static let Accept = "Accept"
            public static let ContentLanguage = "Content-lang"
        }
    }
}

public struct ErrorModel: Error {
    var code: Int
    var mes: String
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
