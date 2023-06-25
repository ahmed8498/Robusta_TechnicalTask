//
//  RepositoryDetailsViewController.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 25/06/2023.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var repositoryPlacholderLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var ownerPlaceholderLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var descriptionPlaceholderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var lastUpdatedAtLabel: UILabel!
    @IBOutlet weak var numberOfForksLabel: UILabel!
    @IBOutlet weak var numberOfOpenIssuesLabel: UILabel!
    
    var viewModel: RepositoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    static func viewController(viewModel: RepositoriesViewModel?) -> RepositoryDetailsViewController? {
        let storyboard = UIStoryboard(name: UIConstants.Storyboards.Repositories.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: UIConstants.ViewControllers.RepositoryDetailsViewController.rawValue) as? RepositoryDetailsViewController {
            vc.viewModel = viewModel
            return vc
        } else {
            return nil
        }
    }
    
    
    private func setupUI() {
        guard let selectedRepository = viewModel?.getSelectedRepository() else {return}
        
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        ownerImageView.layer.cornerRadius = ownerImageView.frame.height / 2.0
        repositoryNameLabel.text = selectedRepository.name
        ownerImageView.image = selectedRepository.owner?.image
        ownerNameLabel.text = selectedRepository.owner?.name
        descriptionLabel.text = selectedRepository.description
        lastUpdatedAtLabel.text = selectedRepository.moreInfo?.lastUpdatedAt
        numberOfForksLabel.text = String(selectedRepository.moreInfo?.forksCount ?? 0)
        numberOfOpenIssuesLabel.text = String(selectedRepository.moreInfo?.openIssuesCount ?? 0)
        
        if let createdAtDateString = selectedRepository.moreInfo?.createdAt {
            createdAtLabel.text = DateFormatHandler.defaultHandler.displayDateString(fromString: createdAtDateString, toFormat: "dd-MMM-yyyy")
        }
        
        
        if let lastUpdatedAtDateString = selectedRepository.moreInfo?.lastUpdatedAt {
            lastUpdatedAtLabel.text = DateFormatHandler.defaultHandler.displayDateString(fromString: lastUpdatedAtDateString, toFormat: "dd-MMM-yyyy")
        }
    }
    


}
