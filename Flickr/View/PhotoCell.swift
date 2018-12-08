//
//  PhotoCell.swift
//  Flickr
//
//  Created by Ebru on 08/07/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(photo: Photo) {
        self.photoView.loadImageFromURL(photo.imageDownloadURL)
        self.titleLabel.text = photo.title
    }
}
