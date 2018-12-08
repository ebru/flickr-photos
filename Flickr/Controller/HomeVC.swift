//
//  HomeVC.swift
//  Flickr
//
//  Created by Ebru on 08/07/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var table: UITableView!
    
    var photoArray = [Photo]()
    var activeRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets JSON data when view loaded.
        getJSONDataWithTagName(tag: "wanderlust")
    }
    
    func getJSONDataWithTagName(tag: String) {
        
        // URL that gets photo details with tag name using Flickr Public API.
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

                                var title = item["title"] as! String

                                if title.trimmingCharacters(in: .whitespaces).isEmpty  {
                                    // If photo title is empty, replace it with published date.
                                    title = item["published"] as! String
                                }
                                
                                let photoURLDictionary = item["media"] as! [String: AnyObject]
                                
                                let imageDownloadURL = photoURLDictionary["m"] as! String
                               
                                let photo = Photo(title: title, imageDownloadURL: imageDownloadURL)
                                
                                self.photoArray.append(photo)
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
        return photoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? PhotoCell else { return UITableViewCell() }
        
        let photo = photoArray[indexPath.row]
        cell.configureCell(photo: photo)

        return cell
    }
    
    // When a row tapped in table, perform a segue with details of that particular row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeRow = indexPath.row
        performSegue(withIdentifier: "toDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            let detailViewController = segue.destination as! PhotoDetailVC
            detailViewController.photo = photoArray[activeRow]
        }
    }
}
