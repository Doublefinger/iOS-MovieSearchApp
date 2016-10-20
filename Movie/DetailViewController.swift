//
//  DetailViewController.swift
//  Movie
//
//  Created by Shitianyu Pan on 10/19/16.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var runningTime: UILabel!
    
    var favortieViewController : FavoriteViewController?=nil
    var movieTitle: String!
    
    var detailItem: Movie? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.movieTitle = detail.title
            updateDetail(detail.id)
            if detail.posterPath != "" {
                if let imageView = self.poster{
                    imageView.image = detail.poster
                }
            }
        }
    }
    
    func updateDetail(id: String){
        let url = NSURL(string:"http://www.omdbapi.com/?plot=short&r=json&i=" + id)!
        let json = JSON(data: NSData(contentsOfURL: url)!)
        
        if let error = json["Error"].string{
            //Movie not found
            print(error)
        } else {
            let release = String(json["Released"])
            let runtime = String(json["Runtime"])
            let director = String(json["Director"])
            let rating = String(json["imdbRating"])
            
            if let label = self.rating {
                label.text = "Rating: " + rating
            }
            
            if let label = self.runningTime {
                label.text = "Running Time: " + runtime
            }
            
            if let label = self.releaseDate {
                label.text = "Release Date: " + release
            }
            
            if let label = self.director {
                label.text = "Director: " + director
            }
        }
    
    }
    
    @IBAction func addToFavorites(sender: UIButton) {
        self.favortieViewController?.insertNewObject(self.movieTitle)
    }
    
    /**
     copy from https://www.codementor.io/swift/tutorial/ios-development-facebook-twitter-sharing
     */
    @IBAction func shareOnFacebook(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let tabBar = self.tabBarController {
            let controllers = tabBar.viewControllers
            self.favortieViewController = controllers![controllers!.count-1] as? FavoriteViewController
        }
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
