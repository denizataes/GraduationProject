//
//  ViewController.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    private let viewModel = HomeViewModel()
    private var popularGameList: [SearchCellModel] = []
    private var latestGameList: [LatestCellModel] = []
    private var currentPopularPage = 1
    private var currentLatestPage = 1
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
        viewModel.didViewLoad()
    }
    
    private func setupUI(){
        
        // MARK: NavigationController
        navigationController?.navigationBar.topItem?.title = "\("Ana Sayfa".localized())🔥"
        
        // MARK: CollectionView
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // MARK: TableView
        tableView.register(UINib(nibName: "SearchGameTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isHidden = true
        
    }
}

// MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "gameDetailViewController") as? GameDetailViewController{
            let game = latestGameList[indexPath.item]
            let gameID = game.id
            vc.id = String(gameID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = latestGameList.count - 1
        if indexPath.item == lastElement {
            viewModel.fetchLatestDataWithPagination(page: currentLatestPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

// MARK: CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestGameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath) as! LatestCollectionViewCell
        let model = latestGameList[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
}

// MARK: TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = popularGameList.count - 1
        if indexPath.row == lastElement {
            viewModel.fetchPopularDataWithPagination(page: currentPopularPage)
        }
    }
}

// MARK: TableViewDatasource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return popularGameList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchGameTableViewCell
        let model = popularGameList[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "gameDetailViewController") as? GameDetailViewController{
            let game = popularGameList[indexPath.row]
            let gameID = game.id
            vc.id = String(gameID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

private extension HomeViewController {
    
    func setupBindings() {
        
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.collectionViewActivityIndicator.stopAnimating()
                self?.tableViewActivityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Uyarı".localized(), message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Tamam".localized(), style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        viewModel.latestGames = { [weak self] latestGames in
            DispatchQueue.main.async {
                
                if self!.currentLatestPage > 1{
                    self?.latestGameList.append(contentsOf: latestGames)
                }
                else{
                    self?.latestGameList = latestGames
                }
                
                self?.collectionView.reloadData()
                self?.currentLatestPage += 1
                self?.collectionViewActivityIndicator.stopAnimating()
            }
            
        }
        
        viewModel.popularGames = { [weak self] popularGames in
            DispatchQueue.main.async {
                
                if self!.currentPopularPage > 1{
                    self?.popularGameList.append(contentsOf: popularGames)
                }
                else{
                    self?.popularGameList = popularGames
                }
                
                
                self?.currentPopularPage += 1
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.tableViewActivityIndicator.stopAnimating()
            }
        }
    }
    
}
