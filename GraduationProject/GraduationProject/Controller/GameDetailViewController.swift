//
//  GameDetailViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 15.01.2023.
//
import Kingfisher
import UIKit

class GameDetailViewController: UIViewController {
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var skipLabel: UILabel!
    @IBOutlet weak var mehLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var exceptionalVote: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var platformTableView: UITableView!
    var id: String = ""
    let viewModel = GameDetailViewModel()
    var genreList = [ResultVM]()
    var platformList = [ResultVM]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        setupUI()
        setupBindings()
        viewModel.didViewLoad(id: id)
    }
    
    private func setupUI(){
        //MARK: Delegates and datasources
        genreTableView.dataSource = self
        platformTableView.dataSource = self
        genreTableView.delegate = self
        platformTableView.delegate = self
        
        //MARK: View Setup
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.sizeToFit()
        gameImageView.kf.indicatorType = .activity
        (gameImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .purple
        gameImageView.layer.cornerRadius = 8
        gameImageView.layer.shadowRadius = 8
        
        //MARK: Register cell
        genreTableView.register(UINib(nibName: "GameDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        platformTableView.register(UINib(nibName: "GameDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        platformTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        genreTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
}

//MARK: TableView Datasources and Delegates
extension GameDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! GameDetailTableViewCell

        if tableView == genreTableView {
            let model = genreList[indexPath.item]
            cell.configure(imageURL: model.image, title: model.name)
        }
        else{
            let model = platformList[indexPath.item]
            cell.configure(imageURL: model.image, title: model.name)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == genreTableView {
            return genreList.count
        }
        else{
            return platformList.count
        }
    }
}


//MARK: Bindings
extension GameDetailViewController{
    func setupBindings() {
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Alert", message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Ok", style: .default))
                self?.removeSpinner()
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        viewModel.gameDetail = { [weak self] response in
            DispatchQueue.main.async{
                self?.platformList = response.platforms
                self?.genreList = response.genres
                self?.genreTableView.reloadData()
                self?.platformTableView.reloadData()
                
                self?.gameImageView.kf.setImage(with: URL(string: response.backgroundImage))
                self?.gameTitleLabel.text = response.name
                self?.releaseDateLabel.text = response.releaseDate
                self?.descriptionLabel.text = response.description
                self?.voteLabel.text = String(response.rating) + "/5"
                self?.mehLabel.text = String(response.meh) + "%"
                self?.recommendedLabel.text = String(response.recommended) + "%"
                self?.skipLabel.text = String(response.skip) + "%"
                self?.exceptionalVote.text = String(response.exceptional) + "%"
                self?.removeSpinner()
            }
        }
    }
}
