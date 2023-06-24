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
        viewModel = RepositoriesViewModel()
        bindData()
        loadRepositories()
    }
    
    func bindData() {
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
        print(viewModel?.getPaginatedListCount() ?? 0)
        return viewModel?.getPaginatedListCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.Cells.RepositoryTableViewCell.rawValue, for: indexPath) as? RepositoryTableViewCell, let repository = viewModel?.getPaginatedRepository(at: indexPath.row) {
            cell.setup(withRepository: repository)
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
    
}

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 1 {
            viewModel?.updateSearchString(withString: searchText)
        }
    }
}
