//
//  Photo.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import SwiftyJSON

//"id": "22249325526",
//"owner": "53894703@N02",
//"secret": "0fd9c041a3",
//"server": "645",
//"url_m" : "https:\/\/farm6.staticflickr.com\/5617\/22255416632_0710350e03.jpg"
//"farm": 1,
//"title": "Test tripod",
//"ispublic": 1,
//"isfriend": 0,
//"isfamily": 0
//"ownername" : "MRFC1902"

/// A photo on Flickr.
struct Photo {
    /// The URL to this photo's image.
    let url : NSURL
    /// The title of this photo.
    let title : String?
    /// The name of this photo's owner.
    let ownerName : String?
    
    /// Create a photo from a Flickr API JSON response.
    /// - parameter json: The JSON to create the photo from.
    /// - returns: A Photo, or nil if the JSON does not contain an image URL.
    init?(json: JSON) {
        guard let url = json[.URL].URL else {
            return nil
        }
        
        self.url = url
        self.title = json[.Title].string
        self.ownerName = json[.OwnerName].string
    }
}

extension Photo : CustomDebugStringConvertible {
    var debugDescription: String {
        let t = title ?? "NO TITLE"
        let o = ownerName ?? "NO OWNER"
        return "{\(t) by \(o) at \(url)}"
    }
}

// Convenience to avoid String Death.

private enum JSONKeys : String {
    case URL = "url_m"
    case Title = "title"
    case OwnerName = "ownername"
}

extension JSON {
    private subscript(key: JSONKeys) -> JSON {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
}
