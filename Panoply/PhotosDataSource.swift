//
//  PhotosDataSource.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import Foundation
import Moya

/// A UITableViewDataSource for photos.
class PhotosDataSource : NSObject, UITableViewDataSource {
    typealias PhotosDataSourceDidUpdateCallback = (isLoading: Bool) -> ()
    let callback : PhotosDataSourceDidUpdateCallback
    
    private var album = Album()
    
    init(callback: PhotosDataSourceDidUpdateCallback) {
        self.callback = callback
    }
    
    var numberOfPhotos : Int {
        return album.numberOfPhotos
    }
    
    subscript(indexPath: NSIndexPath) -> Photo {
        return album[indexPath.row]
    }
    
    func deletePhotoAtIndexPath(indexPath: NSIndexPath) {
        album = album.albumByDeletingPhotoAtIndex(indexPath.row)
    }
    
    func movePhotoFromIndexPath(oldIndexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        album = album.albumByMovingPhotoAtIndex(oldIndexPath.row, toIndex: newIndexPath.row)
    }
    
    private var cancelToken : Cancellable?
    
    func setWithSearch(search: FlickrSearch) {
        // Cancel any pending search
        cancelToken?.cancel()
        
        callback(isLoading: true)
        
        cancelToken = search.get { result in
            if let album = result.value {
                self.album = album
            }
            else {
                // If I had time I'd report an error here.
                self.album = Album()
            }
            self.callback(isLoading: false)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPhotos
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoCell.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        cell.photo = self[indexPath]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deletePhotoAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        movePhotoFromIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
}