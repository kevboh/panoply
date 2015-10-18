//
//  Album.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import SwiftyJSON

let DefaultAlbumTerm = "Postlight"

/// A collection of Flickr photos.
struct Album {
    /// The Photos in this album.
    private let photos : [Photo]
    
    /// Create an Album from a Flickr API JSON response. 
    /// - parameter json: The JSON response to create an Album from.
    /// - returns: an Album, or `nil` if there are no photos in the JSON.
    init?(json: JSON) {
        guard let photosJSON = json["photo"].array else {
            return nil
        }
        
        self.photos = photosJSON.flatMap({Photo(json: $0)})
    }
    
    /// Create an empty Album.
    init() {
        self.photos = []
    }
    
    /// Create an Album from an array of Photos.
    private init(photos: [Photo]) {
        self.photos = photos
    }
    
    /// The number of photos in this album.
    var numberOfPhotos : Int {
        return photos.count
    }
    
    subscript(index: Int) -> Photo {
        return photos[index]
    }
    
    func albumByDeletingPhotoAtIndex(index: Int) -> Album {
        var newPhotos = photos
        newPhotos.removeAtIndex(index)
        return Album(photos: newPhotos)
    }
    
    func albumByMovingPhotoAtIndex(oldIndex: Int, toIndex newIndex: Int) -> Album {
        var newPhotos = photos
        let photo = newPhotos.removeAtIndex(oldIndex)
        newPhotos.insert(photo, atIndex: newIndex)
        return Album(photos: newPhotos)
    }
}