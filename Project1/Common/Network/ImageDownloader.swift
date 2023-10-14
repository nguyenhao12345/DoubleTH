//
//  ImageOperation.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import UIKit

open class ImageDownloader: Operation, SendingAPIRequestInteractionsAble {
    private let urlAsText: String
    
    init(urlAsText: String) {
        self.urlAsText = urlAsText
        super.init()
    }
    
    open override func main() {
        if arrayImagesGlobal[urlAsText] != nil { return }
        print(urlAsText)
        print(arrayImagesGlobal)
        sendRequest(.init(endpoint: .custom(urlAsText), method: .get)) { result in
//            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let image = UIImage(data: data)
                arrayImagesGlobal[self.urlAsText] = image
            case .failure(_):
                break
            }
        }
    }
}
