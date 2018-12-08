//
//  Photo.swift
//  Flickr
//
//  Created by Ebru Kaya on 8.12.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import Foundation

class Photo {
    private var _title: String
    private var _imageDownloadURL: String

    var title: String {
        return _title
    }
    var imageDownloadURL: String {
        return _imageDownloadURL
    }
    
    init(title: String, imageDownloadURL: String) {
        self._title = title
        self._imageDownloadURL = imageDownloadURL
    }

    convenience init() {
        self.init(title: String(), imageDownloadURL: String())
    }
}
