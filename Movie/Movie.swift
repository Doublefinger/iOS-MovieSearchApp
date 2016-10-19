//
//  Movie.swift
//  MovieApp
//
//  Created by Shitianyu Pan on 10/17/16.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation
import UIKit

struct Movie {
    var id: String = ""
    var title: String = ""
    var year: String = ""
    var type: String = ""
    var poster: UIImage
    var posterPath: String = ""
    var rating = ""
    
    init(id: String, title: String, posterPath: String, poster: UIImage, type: String, year: String) {
        self.id = id
        self.title = title
        self.poster = poster
        self.posterPath = posterPath
        self.type = type
        self.year = year
    }
    
    init(id: String, title: String, posterPath: String, type: String, year: String) {
        self.id = id
        self.poster = UIImage()
        self.title = title
        self.posterPath = posterPath
        self.type = type
        self.year = year
    }
    
    mutating func setMoviePoster(poster: UIImage) {
        self.poster = poster
    }
    
}