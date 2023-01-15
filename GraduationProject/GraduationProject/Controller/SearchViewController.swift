//
//  SearchViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 13.01.2023.
//

import UIKit

class SearchViewController: UIViewController{
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController()
    private let viewModel = SearchViewModel()
    private var searchGameList: [SearchCellModel] = []

    let sections: [String] = SearchSection.allCases.map { $0.buttonTitle }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configure()
        
    }
    private func configure(){
        
        //MARK: NavigationController
        navigationController?.navigationBar.topItem?.title = "Ara 👀"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = false
        definesPresentationContext = true

        //MARK: Register cell
        tableView.register(UINib(nibName: "SearchGameTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")

        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: SearchController
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = sections
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("İptal", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Oyun ya da oyuncu ara... 🎮👩🏼‍💻👨🏼‍💻"

        
        //MARK: Register cell
        tableView.register(UINib(nibName: "AlbumSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "albumSearchTableViewCell")
      
        
    }

}
extension SearchViewController: UITableViewDelegate{
    
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchGameTableViewCell
        let model = searchGameList[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    

    
}
extension SearchViewController: UISearchResultsUpdating{
    ///If searchController change this method will be trigger.
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if searchText!.count == 0 {
            DispatchQueue.main.async {
                self.searchGameList.removeAll()
                self.tableView.reloadData()
            }
        }
        else if searchText!.count > 2{

            let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            
            activityIndicator.startAnimating()
            switch(scopeButton)
            {
            case SearchSection.popularity.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.popularity.buttonTextForQuery)
                
            case SearchSection.released.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.released.buttonTextForQuery)
                
            case SearchSection.name.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.name.buttonTextForQuery)
                
            default:
                print("")
            }
        }
    }
}


//MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate{
    ///If searchController textfield change then search by query.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if searchText!.count == 0 {
            DispatchQueue.main.async {
                self.searchGameList.removeAll()
                self.tableView.reloadData()
            }
        }
        else if searchText!.count > 2{
            switch(scopeButton)
            {
            case SearchSection.popularity.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.popularity.buttonTextForQuery)
                
            case SearchSection.released.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.released.buttonTextForQuery)
                
            case SearchSection.name.buttonTitle:
                viewModel.search(query: searchText ?? "", filter: SearchSection.name.buttonTextForQuery)
                
            default:
                print("")
            }
        }
        
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        ///if the cancel button is clicked, empty the array, the screen remains blank
        self.activityIndicator.stopAnimating()
        self.searchGameList.removeAll()
        self.tableView.reloadData()
    }
    
    func setupBindings() {
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Alert", message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Ok", style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        viewModel.searchGames = { [weak self] searchGames in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.searchGameList = searchGames
                self?.tableView.reloadData()
            }
            
        }
    }
}
