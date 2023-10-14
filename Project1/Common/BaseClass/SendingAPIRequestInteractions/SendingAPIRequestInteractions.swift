//
//  SendingAPIRequestInteractions.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import Foundation

protocol SendingAPIRequestInteractionsAble {
    func sendRequest(_ request: APIRequest, _ completion: @escaping HttpRequest.APIClientCompletion)
}

extension SendingAPIRequestInteractionsAble {
    private func sendRequestHandler(_ request: APIRequest, _ completion: @escaping HttpRequest.APIClientCompletion) {
        let httpRequest = HttpRequest()
        httpRequest.request(apiRequest: request, completion)
    }
}

extension SendingAPIRequestInteractionsAble where Self: BaseViewController {
    func sendRequest(_ request: APIRequest, _ completion: @escaping HttpRequest.APIClientCompletion) {
        sendRequestHandler(request, completion)
    }
}

extension SendingAPIRequestInteractionsAble where Self: ImageDownloader {
    func sendRequest(_ request: APIRequest, _ completion: @escaping HttpRequest.APIClientCompletion) {
        sendRequestHandler(request, completion)
    }
}

