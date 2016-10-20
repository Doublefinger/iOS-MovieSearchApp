//
//  FirstViewController.swift
//  Movie
//
//  Created by Shitianyu Pan on 10/18/16.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var detailViewController: DetailViewController?=nil
    
    @IBOutlet weak var movieView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityIndicator: UIActivityIndicatorView!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        // Do any additional setup after loading the view, typically from a nib.
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-2] as! UINavigationController).topViewController as? DetailViewController
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.movieView.indexPathForCell(sender as! UICollectionViewCell){
                let movie = movies[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = movie
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PosterCell", forIndexPath: indexPath)
        let movie = movies[indexPath.row]
        let image = cell.contentView.viewWithTag(1) as! UIImageView
        let titleView = cell.contentView.viewWithTag(2)!
        for previousTitle in titleView.subviews {
            previousTitle.removeFromSuperview()
        }
        let title = UILabel(frame: CGRect(x: 20, y: -40, width: 60, height: 120))
        title.text = movie.title
        title.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        title.numberOfLines = 2
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.whiteColor()
        titleView.addSubview(title)
        
        if movie.posterPath == "" {
            image.image = UIImage(named: "no_poster")
            return cell
        }
        image.image = movie.poster
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: 164)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text == "" {
            return
        }
        self.movies.removeAll()
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        dispatch_async(dispatch_get_main_queue(), {
            self.movieView.reloadData()
        })
        var text = searchBar.text!
        text = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let url = NSURL(string:"http://www.omdbapi.com/?r=json&page=1&s="+text)!
      
        let json = JSON(data: NSData(contentsOfURL: url)!)
        
        if let error = json["Error"].string{
            //Movie not found
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: error, message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            var moviesWithPoster = fetchHelper(json["Search"])
            print(moviesWithPoster.count)
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                for i in 0...moviesWithPoster.count-1 {
                    let imageUrl = NSURL(string: moviesWithPoster[i].posterPath)
                    let poster = UIImage(data: NSData(contentsOfURL: imageUrl!)!)
                    moviesWithPoster[i].setMoviePoster(poster!)
                }
                self.movies.insertContentsOf(moviesWithPoster, at: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.movieView.reloadData()
                    self.activityIndicator.stopAnimating()
                })
            })
        }
        
        
    }
    
    func fetchHelper(movieInfos: JSON) -> [Movie]{
        var moviesWithPoster = [Movie]()
        
        for index in 0...movieInfos.count-1 {
            let title = String(movieInfos[index]["Title"])
            let id = String(movieInfos[index]["imdbID"])
            let year = String(movieInfos[index]["Year"])
            let posterPath = String(movieInfos[index]["Poster"])
            let type = String(movieInfos[index]["Type"])
            if posterPath == "N/A" {
                let movie = Movie(id: id, title: title, posterPath: "", type: type, year: year)
                self.movies.append(movie)
                
            } else {
                let movie = Movie(id: id, title: title, posterPath: posterPath, type: type, year: year)
                moviesWithPoster.append(movie)
            }
        }
        
        return moviesWithPoster

    }
}

