//
//  GameDetailTableViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 16.01.2023.
//

import UIKit
import Kingfisher

class GameDetailTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePhotoView()
    }
    
    private func configurePhotoView(){
        cellImageView.kf.indicatorType = .activity
        
        (cellImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .systemGray2
        cellImageView.layer.cornerRadius = 5
        cellImageView.layer.shadowRadius = 5
    }
    
    func configure(imageURL: String, title: String)
    {
        titleLabel.text = title
        cellImageView.kf.setImage(with: URL(string: imageURL))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
