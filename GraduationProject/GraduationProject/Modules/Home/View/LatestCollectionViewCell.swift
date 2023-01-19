//
//  PopularCollectionViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 13.01.2023.
//

import UIKit


class LatestCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePhotoView()
    }
    
    func configure(with model: LatestCellModel) {
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .purple
        imageView.kf.setImage(with: URL.init(string: model.imageURL))
        titleLabel.text = model.title
        voteLabel.text = "\(model.vote)/5"
    }
    
    private func configurePhotoView(){
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowRadius = 15
    }
}

struct LatestCellModel {
    let id: Int
    let imageURL: String
    let vote: String
    let title: String
}
