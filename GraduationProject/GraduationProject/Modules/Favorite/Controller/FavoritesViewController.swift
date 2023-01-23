//
//  FavoritesViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 17.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = FavoriteViewModel()
    var favoriteList = [FavoriteVM]()
    var filteredData = [FavoriteVM]()
    let searchController = UISearchController()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
    
    private func setupUI(){
        activityIndicator.startAnimating()
        
        // MARK: NavigationController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "\("Favorilerim".localized()) ❤️"
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationItem.searchController = searchController
        
        //MARK: Tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        
        //MARK: NotificationCenter
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favoriteUpdate"), object: nil, queue: nil) { _ in
            self.viewModel.didViewLoad()
            self.tableView.reloadData()
        }
        
        //MARK: SearchController
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("İptal".localized(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Favorilerde ara...".localized()
    }
    

}

extension FavoritesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = favoriteList
        if searchText.isEmpty == false {
            filteredData = favoriteList.filter({ $0.name.lowercased().contains(searchText.lowercased())})
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        ///if the cancel button is clicked, empty the array, the screen remains blank
        self.activityIndicator.stopAnimating()
        self.filteredData.removeAll()
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
}

extension FavoritesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchBar = searchController.searchBar
        return searchBar.text!.count > 0 ? filteredData.count : favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let model = filteredData.count > 0 ? filteredData[indexPath.item] : favoriteList[indexPath.item]
        cell.configure(with: .init(id: model.gameID, name: model.name, backgroundImage: model.backgroundImage, date: model.createdDate))
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil".localized()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "gameDetailViewController") as? GameDetailViewController{
            let game = filteredData.count > 0 ? filteredData[indexPath.row] : favoriteList[indexPath.row]
            vc.id = game.gameID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.favoriteList[indexPath.row]
            self.favoriteList.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.viewModel.deleteFavorite(id: model.gameID)
            self.tableView.endUpdates()
        }
    }
    
}

extension FavoritesViewController {
    
    func setupBindings() {
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Uyarı".localized(), message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Tamam".localized(), style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        viewModel.favoriteList = { [weak self] favList in
            DispatchQueue.main.async{
                self?.activityIndicator.stopAnimating()
                self?.favoriteList = favList
                self?.tableView.reloadData()
            }
        }
    }
    
}
