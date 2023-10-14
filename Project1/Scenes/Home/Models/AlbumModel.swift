//
//  AlbumModel.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import Foundation

public struct AlbumModel {
    public let id: String
    public let title: String
    public let url: String
    public let thumbnailUrl: String
}

extension AlbumModel {
    public init(with dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
        thumbnailUrl = dictionary["thumbnailUrl"] as? String ?? "" 
    }
}
