//
//  FavoriteTableViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 17.01.2023.
//

import UIKit
import Kingfisher

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupUI(){
        gameImageView.kf.indicatorType = .activity
        (gameImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .systemRed
        gameImageView.layer.cornerRadius = 5
        gameImageView.layer.shadowRadius = 5
        gameTitleLabel.adjustsFontSizeToFitWidth = true
        gameTitleLabel.sizeToFit()
        
        
        gameImageView.layer.shadowColor = UIColor.black.cgColor
        gameImageView.layer.shadowOffset = CGSizeMake(0, 5)
        gameImageView.layer.shadowOpacity = 1
    }
    
    func configure(with model: FavoriteCellModel) {
        gameImageView.kf.setImage(with: URL(string: model.backgroundImage)) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                self.gameTitleLabel.textColor = averageColor
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        gameTitleLabel.text = model.name.uppercased()
        dateLabel.text = model.date
    }
    
}

struct FavoriteCellModel{
    var id: String
    var name: String
    var backgroundImage: String
    var date: String
}
