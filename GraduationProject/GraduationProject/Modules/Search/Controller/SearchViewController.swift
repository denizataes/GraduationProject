//
//  SearchViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata EĆ on 13.01.2023.
//

import UIKit

class SearchViewController: UIViewController{
    
    //MARK: Defining Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = SearchViewModel()
    private var searchGameList: [SearchCellModel] = []
    var timeout: Timer?
    let sections: [String] = SearchSection.allCases.map { $0.buttonTitle }
    let searchController = UISearchController()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    private func setupUI(){
        
        definesPresentationContext = true
        
        //MARK: NavigationController
        navigationController?.navigationBar.topItem?.title = "\("Ara".localized()) đ"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        //MARK: Table View
        tableView.register(UINib(nibName: "SearchGameTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        //MARK: SearchController
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = sections
        searchController.searchBar.setValue("Ä°ptal".localized(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "\("Oyun ara...".localized()) đź"
        
    }
    
    func setupBindings() {
        
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "UyarÄ±".localized(), message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Tamam".localized(), style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        viewModel.searchGames = { [weak self] searchGames in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if self!.currentPage > 1{
                    self?.searchGameList.append(contentsOf: searchGames)
                }
                else{
                    self?.searchGameList = searchGames
                }
                self?.tableView.reloadData()
                self?.currentPage += 1
            }
        }
    }
    
}
//MARK: TableView Delegate
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "gameDetailViewController") as? GameDetailViewController{
            let game = searchGameList[indexPath.row]
            let gameID = game.id
            vc.id = String(gameID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = searchGameList.count - 1
        if indexPath.row == lastElement {
            let searchBar = searchController.searchBar
            let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            
            switch(scopeButton)
            {
            case SearchSection.popularity.buttonTitle:
                self.viewModel.searchWithPagination(query: searchText ?? "", filter: SearchSection.popularity.buttonTextForQuery, page: currentPage)
                
            case SearchSection.released.buttonTitle:
                self.viewModel.searchWithPagination(query: searchText ?? "", filter: SearchSection.released.buttonTextForQuery, page: currentPage)
                
            case SearchSection.name.buttonTitle:
                self.viewModel.searchWithPagination(query: searchText ?? "", filter: SearchSection.name.buttonTextForQuery, page: currentPage)
                
            default:
                print("")
            }
            
        }
    }
    
}
//MARK: TableView Datasource
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
//MARK: UISearchbar Delegate
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        /// Not used
    }
    
    ///If searchController change this method will be trigger.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        currentPage = 0
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if searchText!.count == 0 {
            DispatchQueue.main.async {
                self.searchGameList.removeAll()
                self.tableView.reloadData()
            }
        }
        else if searchText!.count > 2{
            timeout?.invalidate()
            timeout = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
                self.activityIndicator.startAnimating()
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
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.popularity.buttonTextForQuery)
                        
                    case SearchSection.released.buttonTitle:
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.released.buttonTextForQuery)
                        
                    case SearchSection.name.buttonTitle:
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.name.buttonTextForQuery)
                        
                    default:
                        print("")
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
}
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPage = 0
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if searchText!.count == 0 {
            DispatchQueue.main.async {
                self.searchGameList.removeAll()
                self.tableView.reloadData()
            }
        }
        else if searchText!.count > 2{
            timeout?.invalidate()
            timeout = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
                self.activityIndicator.startAnimating()
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
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.popularity.buttonTextForQuery)
                        
                    case SearchSection.released.buttonTitle:
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.released.buttonTextForQuery)
                        
                    case SearchSection.name.buttonTitle:
                        self.viewModel.search(query: searchText ?? "", filter: SearchSection.name.buttonTextForQuery)
                        
                    default:
                        print("")
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        ///if the cancel button is clicked, empty the array, the screen remains blank
        self.activityIndicator.stopAnimating()
        self.searchGameList.removeAll()
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
