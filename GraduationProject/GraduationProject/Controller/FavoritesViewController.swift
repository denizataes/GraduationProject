//
//  FavoritesViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 17.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = FavoriteViewModel()
    var favoriteList = [FavoriteVM]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.didViewLoad()
    }
    
    private func setupUI(){
        activityIndicator.startAnimating()
        
        // MARK: NavigationController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "Favorilerim ❤️"
        
        //MARK: Tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //MARK: Register cell
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
    }
    

}

extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let model = favoriteList[indexPath.row]
        cell.configure(with: .init(id: model.gameID, name: model.name, backgroundImage: model.backgroundImage, date: model.createdDate))
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "gameDetailViewController") as? GameDetailViewController{
            let game = favoriteList[indexPath.row]
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
                let alertController = UIAlertController(title: "Alert", message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Ok", style: .default))
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
