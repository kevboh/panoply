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
    case Search(String)
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
            return ["method" : "flickr.photos.search", "text" : text]
        default:
            return [:]
        }
    }
    
    var sampleData: NSData {
        switch self {
        case .Search:
            // Normally I'd not rely so heavily on force-unwrapping, but in this case I want Moya to fail if this file
            // isn't available, since that would indicate that something is terribly, horribly wrong.
            let file = NSBundle().pathForResource("search-test", ofType: "json")!
            return NSData(contentsOfFile: file)!
        case .Photo:
            // TODO: Replace with real photo
            return NSData()
        }
    }
}

/// A FlickrConsumer has access to a single var, `provider`, that returns by default a connection to the Flickr API.
/// Allows easy mocking in test targets.
protocol FlickrConsumer {
    var provider : MoyaProvider<Flickr> { get }
}

extension FlickrConsumer {
    var provider : MoyaProvider<Flickr> { return DefaultMoyaProvider.provider }
}

// Could eventually override anything here for testing.
private struct DefaultMoyaProvider {
    private static let provider = MoyaProvider<Flickr>(endpointClosure: endpointClosure)
    
    private static var endpointClosure = { (target: Flickr) -> Endpoint<Flickr> in
        // Add default Flickr params
        var parameters = target.parameters ?? [:]
        parameters["format"] = "json"
        parameters["nojsoncallback"] = 1
        parameters["api_key"] = PanoplyKeys().flickrAPIKey()
        parameters["extras"] = "owner_name,url_m"
        // TODO: url extra here?
        
        return Endpoint<Flickr>(URL: target.urlString,
            sampleResponseClosure: { DefaultMoyaProvider.sampleReponseForTarget(target) },
            method: target.method,
            parameters: parameters)
    }
    
    private static func sampleReponseForTarget(target: MoyaTarget) -> EndpointSampleResponse {
        return EndpointSampleResponse.NetworkResponse(200, target.sampleData)
    }
}
