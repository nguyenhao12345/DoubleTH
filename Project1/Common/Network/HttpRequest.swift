//
//  HttpRequest.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import Foundation

open class HttpRequest: NSObject {
    private let session = BaseURLSession.shared
    
    typealias APIClientCompletion = (Result<Data?, ErrorModel>) -> Void

    func request(apiRequest request: APIRequest, _ completion: @escaping APIClientCompletion) {
        guard let urlRequest = request.urlRequest else { return completion(.failure(.init(code: 400, mes: "The request url is invalid"))) }
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error as? NSError {
                    completion(.failure(.init(code: error.code, mes: error.localizedDescription)))
                    return
                }
                completion(.success(data))
            }
        }
        task.resume()
    }
}


