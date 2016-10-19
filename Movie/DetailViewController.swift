//
//  DetailViewController.swift
//  Movie
//
//  Created by Shitianyu Pan on 10/19/16.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var rating: UILabel!
    var detailItem: Movie? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.rating {
                label.text = detail.year
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
