//
//  SearchViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 13.01.2023.
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
    }
    
    private func setupUI(){
        
        definesPresentationContext = true
        
        //MARK: NavigationController
        navigationController?.navigationBar.topItem?.title = "\("Ara".localized()) 👀"
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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = sections
        searchController.searchBar.setValue("İptal".localized(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "\("Oyun ara...".localized()) 🎮"
        
    }
    
    func setupBindings() {
        
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Uyarı".localized(), message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Tamam".localized(), style: .default))
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
