//
//  RepositoriesViewController.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import UIKit
import Combine

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var viewModel: RepositoriesViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search for repository..."
        viewModel = RepositoriesViewModel()
        bindData()
        loadRepositories()
    }
    
    func bindData() {
        viewModel?.$error
                   .receive(on: DispatchQueue.main)
                   .sink(receiveValue: { [weak self] error in
                       if error != nil {
                           self?.showErrorAlert(error: error!)
                       }
                   })
                   .store(in: &cancellables)
        
        
        viewModel?.$paginatedListOfRepositories
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] listOfRepositoriesResponse in
                if listOfRepositoriesResponse != nil {
                    self?.repositoriesTableView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
    
    func loadRepositories() {
        viewModel?.getRepositories()
    }

}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPaginatedListCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.Cells.RepositoryTableViewCell.rawValue, for: indexPath) as? RepositoryTableViewCell, let viewModel = viewModel, let repository = viewModel.getPaginatedRepository(at: indexPath.row) {
            cell.setup(withRepository: repository)
            
            //isOwnerImageDownloadInProgress used to avoid calling of downloadRepositoryImage twice if download started but not finished and repoistoriesTableView is reloaded due to paging
            if !viewModel.isOwnerImageDownloaded(atIndex: indexPath.row) || !cell.isOwnerImageDownloadInProgress {
                cell.isOwnerImageDownloadInProgress = true
                viewModel.downloadRepositoryImage(atIndex: indexPath.row)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.showErrorAlert(error: error)}
                    }, receiveValue: {  ownerImageResponse in
                            print("Image Result at \(indexPath.row)")
                        cell.reloadOwnerImage()
                    })
                    .store(in: &cancellables)
            }
            
            //isMoreInfoDownloadInProgress used to avoid calling of getRepositoryMoreInfo twice if download started but not finished and repoistoriesTableView is reloaded due to paging
            if !viewModel.isRepoMoreInfoFetched(atIndex: indexPath.row) || !cell.isMoreInfoDownloadInProgress {
                cell.isMoreInfoDownloadInProgress = true
                viewModel.getRepositoryMoreInfo(atIndex: indexPath.row)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.showErrorAlert(error: error) }
                    }, receiveValue: {  moreInfoResponse in
                        cell.reloadCreationDate()
                    })
                    .store(in: &cancellables)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        if viewModel.shouldLoadMoreData(), indexPath.row == viewModel.getPaginatedListCount() - 1 {
            viewModel.getNextRepositories()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelectedRepositoryIndex(index: indexPath.row)
        if let repositoryDetailsVC = RepositoryDetailsViewController.viewController(viewModel: viewModel) {
            navigationController?.pushViewController(repositoryDetailsVC, animated: true)
        }
    }
    
}

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 1 {
            viewModel?.updateSearchString(withString: searchText)
        }
    }
}
