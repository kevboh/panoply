//
//  AlbumTableViewController.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import UIKit

/// Super-simple view controller to display a popover of search album options.
class AlbumTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    typealias DidSelectSearchCallback = (String, FlickrSearch) -> ()
    
    /// Called when a search album is selected.
    var didSelectSearchCallback : DidSelectSearchCallback?
    
    private let albumOptions : [String] = [
        DefaultAlbumTerm,
        "NYC",
        "Sloth"
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Popover
        popoverPresentationController?.delegate = self
        preferredContentSize = CGSize(width: 200, height: 200)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath)
        cell.textLabel?.text = albumOptions[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = albumOptions[indexPath.row]
        let search = FlickrSearch(term: title.lowercaseString)
        didSelectSearchCallback?(title, search)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
