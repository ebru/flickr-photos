//
//  ViewController.swift
//  Flickr
//
//  Created by Ebru on 08/07/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    // Array declarations for parsed JSON data, active row when tapped in table view and simple image caching.
    
    var photoURLArray = [String]()
    var photoTitleArray = [String]()
    
    var activeRow = 0
    
    var imageCache = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calling function that gets JSON data when view loaded.
        
        getJSONDataWithTagName(tag: "wanderlust")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getJSONDataWithTagName(tag: String) {
        
        // Definition of URL that gets photo details with tag name using Flickr Public API.
        
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=" + tag + "&format=json&nojsoncallback=?")!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                
                print("Failed.")
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        // Getting JSON data from the URL, parse and store them as titles and image URLs of photos.
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let items = jsonResult["items"] as? NSArray {
                            
                            for item in items as [AnyObject] {
                                
                                let photoURLDictionary = item["media"] as! [String: AnyObject]
                                
                                let photoURL = photoURLDictionary["m"] as! String
                                
                                // For high quality images, comment off below and change 'let' of photoURL above to 'var'.
                                
                                // photoURL = photoURL.replacingOccurrences(of: "_m", with: "_c")
                                
                                self.photoURLArray.append(photoURL)
                                
                                var photoTitle = item["title"] as! String
                                
                                if photoTitle.trimmingCharacters(in: .whitespaces).isEmpty  {
                                    
                                    // If photo title is empty, replace it with published date.
                                    
                                    photoTitle = item["published"] as! String
                                }
                                
                                self.photoTitleArray.append(photoTitle)
                                
                            }
                            
                            OperationQueue.main.addOperation({
                                
                                // Reload table after getting details of photos.
                                
                                self.table.reloadData()
                                
                            })
                            
                        }
                        
                    } catch {
                        
                        // If JSON is not reachable at that moment, show an alert.
                        
                        let alertController = UIAlertController(title: "Error!", message:
                            "Could not reach server at this moment. Please try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
                
            }
            
        }
        task.resume()
        
    }
    
    // Table view setup with details of photos.
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photoURLArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PhotoTableViewCell
        
        let urlString = photoURLArray[indexPath.row]
        
        let photoURL = NSURL(string: urlString)
        
        // Assign a small default image for loading.
        
        cell.photoView.image = UIImage(named: "Blank.png")
        
        // Check if there is a cached image before loading whole image again.
        
        if let cachedImage = imageCache[urlString] {
            
            cell.photoView.image = cachedImage
            
        } else {
            
            OperationQueue.main.addOperation({
                
                if photoURL != nil {
                    
                    let data = NSData(contentsOf: (photoURL as URL?)!)
                    
                    let image = UIImage(data: data! as Data)
                    
                    // Cache the image for later and load it in table.
                    
                    self.imageCache[urlString] = image
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        cell.photoView.image = image
                        
                    })
                    
                }
                
            })
            
        }
        
        // Change label text to title of photo.
        
        cell.titleLabel.text = photoTitleArray[indexPath.row]
        
        return cell
        
    }
    
    // When a row tapped in table, perform a segue with details of that particular row.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeRow = indexPath.row
        
        performSegue(withIdentifier: "toDetailSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailSegue" {
            
            let detailViewController = segue.destination as! PhotoDetailViewController
            
            detailViewController.activeRow = activeRow
            detailViewController.photoURLArray = photoURLArray
            detailViewController.photoTitleArray = photoTitleArray
            
        }
        
    }
    
}
