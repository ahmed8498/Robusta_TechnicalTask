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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(withRepository repository: Repository) {
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        repositoryNameLabel.text = repository.fullName
        ownerNameLabel.text = repository.owner?.name
        
    }

}
