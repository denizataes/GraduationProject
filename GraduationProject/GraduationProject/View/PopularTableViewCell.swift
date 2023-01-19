//
//  PopularTableViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 13.01.2023.
//

import UIKit
import Kingfisher

class PopularTableViewCell: UITableViewCell {


    @IBOutlet weak var viewComponent: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePhotoView()
        configureView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: PopularCellModel) {
        
        gameImageView.kf.setImage(with: URL(string: model.imageURL)) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueColor = averageColor?.withAlphaComponent(0.2)
                self.viewComponent.backgroundColor = opaqueColor
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        titleLabel.text = model.title
        durationLabel.text = "\(model.duration) \("Saat".localized())"
        releaseDateLabel.text = Utils.shared.convertDate(dateString: model.releaseDate)
    }
    
    private func configureView(){
        viewComponent.layer.cornerRadius = 10
        viewComponent.layer.masksToBounds = true
    }

    
    private func configurePhotoView(){
        gameImageView.kf.indicatorType = .activity
        
        (gameImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .purple
        gameImageView.layer.cornerRadius = 4
        gameImageView.layer.shadowRadius = 4
    }

}
struct PopularCellModel {
    let imageURL: String
    let duration: String
    let releaseDate: String
    let title: String
}
