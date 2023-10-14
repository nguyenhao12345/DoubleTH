//
//  APIRequest.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import Foundation

open class APIRequest {
    public let endpoint: APIHelper.EndPoint
    public let method: HTTPMethod
    public let path: String
    public var headers: [APIHelper.Header]?
    public var body: Data?
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    public var timeout: TimeInterval = 240

    init(endpoint: APIHelper.EndPoint, method: HTTPMethod, path: String = "") {
        self.endpoint = endpoint
        self.method = method
        self.path = path
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
    }

    
    private var url: URL? {
        let urlAsText = endpoint.text + path
        return URL(string: urlAsText)
    }
}
