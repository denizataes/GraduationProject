//
//  ViewController.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import UIKit


class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = HomeViewModel()
    
    @IBOutlet weak var collectionViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    private var popularGameList: [PopularCellModel] = []
    private var latestGameList: [LatestCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureNavBar()
        configureDelegate()
        viewModel.didViewLoad()


    }
    
    private func configureNavBar() {
        
        //collectionView!.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        navigationController?.navigationBar.topItem?.title = "Ana Sayfa"
    }
    
    private func configureDelegate() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        collectionView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.register(UINib(nibName: "PopularTableViewCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }


}

// MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
 
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularTableViewCell
        let model = popularGameList[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
    
}

private extension HomeViewController {
  
//  private func setupUI() {
//    tableHelper = .init(tableView: tableView, viewModel: viewModel)
//  }
  
  func setupBindings() {
      viewModel.onErrorDetected = { [weak self] messages in
          DispatchQueue.main.async {
              self?.collectionViewActivityIndicator.stopAnimating()
              self?.tableViewActivityIndicator.stopAnimating()
              let alertController = UIAlertController(title: "Alert", message: messages, preferredStyle: .alert)
              alertController.addAction(.init(title: "Ok", style: .default))
              self?.present(alertController, animated: true, completion: nil)
          }
      }
      
      viewModel.latestGames = { [weak self] latestGames in
          self?.latestGameList = latestGames
          
          DispatchQueue.main.async {
              self?.collectionView.reloadData()
              self?.tableViewActivityIndicator.stopAnimating()
          }
          
      }
      
      viewModel.popularGames = { [weak self] popularGames in
          DispatchQueue.main.async {
              self?.popularGameList = popularGames
              self?.tableView.reloadData()
              self?.tableViewActivityIndicator.stopAnimating()
              
          }
      }
  }
}