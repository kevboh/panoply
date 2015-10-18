//
//  PhotoCell.swift
//  Panoply
//
//  Created by Kevin Barrett on 10/18/15.
//  Copyright © 2015 Postlight. All rights reserved.
//

import UIKit
import Moya

/// A table view cell to display a Photo.
class PhotoCell: UITableViewCell {
    static let reuseIdentifier = "PhotoCellReuseIdentifier"
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    private var cancelToken : Cancellable?
    
    /// The Photo this cell will display.
    /// Setting this triggers a request for the photo's image.
    var photo : Photo? {
        didSet {
            cancelToken?.cancel()
            photoImageView.image = nil
            
            // Get new photo.
            cancelToken = photo?.getImage { result in
                self.photoImageView.image = result.value
            }
            
            // Set labels
            titleLabel.text = photo?.title
            ownerLabel.text = photo?.ownerName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        photo = nil
    }
}

// I'd like this to be private, but Interface Builder doesn't like that.
/// A simple gradient view to help photo metadata pop a bit more.
class PhotoCellGradientView : UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = [
                UIColor.clearColor().CGColor,
                UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor
            ]
        }
    }
}
