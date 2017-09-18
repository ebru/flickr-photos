//
//  PhotoDetailViewController.swift
//  Flickr
//
//  Created by Ebru on 08/07/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    // Array declarations for getting details of a particular row.
    
    var photoURLArray = [String]()
    var photoTitleArray = [String]()
    
    var activeRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change title of view to title of photo.
        
        self.title = photoTitleArray[activeRow]
        
        // Download and load image from the URL.
        
        let photoURL = URL(string: photoURLArray[self.activeRow])!
        
        let request = NSMutableURLRequest(url: photoURL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if let data = data {
                        
                        if let pImage = UIImage(data: data) {
                            
                            self.photo.image = pImage
                            
                            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                            
                            if documentsPath.count > 0 {
                                
                                let documentsDirectory = documentsPath[0]
                                
                                let savePath = documentsDirectory + "/photo.jpg"
                                
                                do {
                                    
                                    try UIImageJPEGRepresentation(pImage, 1)?.write(to: URL(fileURLWithPath: savePath))
                                    
                                } catch {
                                    
                                    print("Failed.")
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                })
                
            }
            
        }
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
