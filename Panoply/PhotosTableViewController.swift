//
//  PhotosTableViewController.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import UIKit

/// A view controller that displays a list of photos.
class PhotosTableViewController: UITableViewController {
    private lazy var dataSource : PhotosDataSource = {
        // Create our data source.
        // The initializing callback is called whenever the source changes.
        let dataSource = PhotosDataSource { isLoading in
            // Reset the spinner.
            self.spinner.removeFromSuperview()
            
            // If we're loading, show the spinner.
            if isLoading {
                self.view.addSubview(self.spinner)
                self.spinner.center = self.view.center
                self.spinner.startAnimating()
            }
            
            // Refresh the view. If loading, hide separators.
            self.tableView.separatorStyle = isLoading ? .None : .SingleLine
            self.tableView.reloadData()
        }
        return dataSource
    }()
    
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.dataSource = dataSource
        dataSource.setWithSearch(FlickrSearch(term: DefaultAlbumTerm.lowercaseString))
        self.title = DefaultAlbumTerm
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let albumViewController = segue.destinationViewController as? AlbumTableViewController {
            albumViewController.didSelectSearchCallback = { title, search in
                self.title = title
                self.dataSource.setWithSearch(search)
            }
        }
    }
}
