//
//  Album.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import SwiftyJSON

/// A collection of Flickr photos.
struct Album {
    /// The Photos in this album.
    let photos : [Photo]
    
    /// Create an Album from a Flickr API JSON response. 
    /// - parameter json: The JSON response to create an Album from.
    /// - returns: an Album, or `nil` if there are no photos in the JSON.
    init?(json: JSON) {
        guard let photosJSON = json["photo"].array else {
            return nil
        }
        
        self.photos = photosJSON.flatMap({Photo(json: $0)})
        
//        print("made photos: \(photos)")
    }
}