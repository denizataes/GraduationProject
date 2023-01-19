//
//  SearchGameTableViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 14.01.2023.
//

import UIKit
import Kingfisher

class SearchGameTableViewCell: UITableViewCell {

    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configurePhotoView()
        configureView()

    }


    func configure(with model: SearchCellModel) {
        
        gameImageView.kf.setImage(with: URL(string: model.imageURL)) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueColor = averageColor?.withAlphaComponent(0.4)
                self.backgroundColor = opaqueColor
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        titleLabel.text = model.title
        playTimeLabel.text = "\(model.playTime) \("Saat".localized())"
        releaseDateLabel.text = Utils.shared.convertDate(dateString: model.releaseDate)
        voteLabel.text = "\(model.vote)/5"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configurePhotoView(){
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        gameImageView.kf.indicatorType = .activity
        
        (gameImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .purple
        gameImageView.layer.cornerRadius = 4
        gameImageView.layer.shadowRadius = 4
    }
    
    private func configureView(){
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

}
struct SearchCellModel {
    let id: Int
    let imageURL: String
    let playTime: String
    let releaseDate: String
    let title: String
    let vote: String
}
