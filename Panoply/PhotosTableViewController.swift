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
        let dataSource = PhotosDataSource { isLoading in
            // TODO: show spinner if loading
            self.tableView.reloadData()
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.dataSource = dataSource
        dataSource.setWithSearch(FlickrSearch(term: "Kevin"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
