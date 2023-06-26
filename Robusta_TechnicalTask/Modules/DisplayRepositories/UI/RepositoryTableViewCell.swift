//
//  RepositoryTableViewCell.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 24/06/2023.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    private var repository: Repository?
    var isOwnerImageDownloadInProgress = false
    var isMoreInfoDownloadInProgress = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withRepository repository: Repository) {
        self.repository = repository
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        ownerImageView.layer.cornerRadius = ownerImageView.frame.height / 2.0
        
        repositoryNameLabel.text = repository.fullName
        ownerNameLabel.text = repository.owner?.name
        
        reloadOwnerImage()
        reloadCreationDate()
    }
    
    func reloadOwnerImage() {
        if let ownerImage = repository?.owner?.image {
            ownerImageView.image = ownerImage
        }
    }
    
    func reloadCreationDate() {
        if let moreInfo = repository?.moreInfo, let createdAtDateString = moreInfo.createdAt {
            creationDateLabel.text = DateFormatHandler.defaultHandler.displayDateString(fromString: createdAtDateString, toFormat: "dd-MMM-yyyy")
        }
    }
}
