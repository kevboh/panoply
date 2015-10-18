//
//  Flickr.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import Moya
import Keys

enum Flickr {
    /// A search for a given String term.
    case Search(String)
    /// A direct photo asset from Flickr with the given URL.
    case Photo(NSURL)
}

extension Flickr : MoyaTarget {
    var baseURL: NSURL {
        return NSURL(string: "https://api.flickr.com")!
    }
    
    var path: String {
        return "/services/rest/"
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var urlString: String {
        switch self {
        case .Search: return baseURL.URLByAppendingPathComponent(path).absoluteString
        case .Photo(let url): return url.absoluteString
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Search(let term):
            let text = term.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? ""
            // If I had more API endpoints this would go in the endpoint closure with a check to not set it on Photo, but.
            return [
                "method" : "flickr.photos.search",
                "text" : text,
                "format" : "json",
                "nojsoncallback" : 1,
                "api_key" : PanoplyKeys().flickrAPIKey(),
                "extras" : "owner_name,url_m"
            ]
        default:
            return [:]
        }
    }
    
    var sampleData: NSData {
        switch self {
            // Normally I'd not rely so heavily on force-unwrapping, but in this case I want Moya to fail if this file
            // isn't available, since that would indicate that something is terribly, horribly wrong.
        case .Search:
            let file = NSBundle().pathForResource("search-test", ofType: "json")!
            return NSData(contentsOfFile: file)!
        case .Photo:
            let file = NSBundle().pathForResource("postlight", ofType: "jpg")!
            return NSData(contentsOfFile: file)!
        }
    }
}

/// A FlickrConsumer has access to a single var, `flickr`, that returns by default a connection to the Flickr API.
/// Allows easy mocking in test targets.
protocol FlickrConsumer {
    var flickr : MoyaProvider<Flickr> { get }
}

extension FlickrConsumer {
    var flickr : MoyaProvider<Flickr> { return DefaultMoyaProvider.provider }
}

// Could eventually override anything here for testing.
private struct DefaultMoyaProvider {
    private static let provider = MoyaProvider<Flickr>(endpointClosure: endpointClosure)
    
    private static var endpointClosure = { (target: Flickr) -> Endpoint<Flickr> in
        return Endpoint<Flickr>(URL: target.urlString,
            sampleResponseClosure: { DefaultMoyaProvider.sampleReponseForTarget(target) },
            method: target.method,
            parameters: target.parameters)
    }
    
    private static func sampleReponseForTarget(target: MoyaTarget) -> EndpointSampleResponse {
        return EndpointSampleResponse.NetworkResponse(200, target.sampleData)
    }
}
