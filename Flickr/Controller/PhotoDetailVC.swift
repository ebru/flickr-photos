//
//  PhotoDetailVC.swift
//  Flickr
//
//  Created by Ebru on 08/07/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class PhotoDetailVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    
    var photo = Photo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = photo.title
        self.photoView.loadImageFromURL(photo.imageDownloadURL)
    }
}
