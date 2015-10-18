//
//  FlickrSearch.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

/// A search on Flickr for a specific term.
struct FlickrSearch : FlickrConsumer {
    /// The term to search for.
    let term : String
    
    /// Execute the search against Flickr.
    /// - parameter completion: The completion handler for the search.
    func get(completion: (Result<Album>) -> ()) -> Cancellable {
        return provider.request(.Search(term)) { data, statusCode, response, error in
            if let data = data {
                let json = JSON(data: data)
                print(json)
                if let album = Album(json: json["photos"]) {
                    completion(Result(album))
                }
                else {
                    let error = NSError(domain: "com.postlight.panoply",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey : "Unable to create album for search."])
                    completion(Result(error))
                }
            }
            else {
                let completionError = error ??
                    NSError(domain: "com.postlight.panoply",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey : "Unable to parse search response."])
                completion(Result(completionError))
            }
        }
    }
}