//
//  NoteCollectionViewCell.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 18.01.2023.
//

import UIKit
import Kingfisher

class NoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        
        self.layer.cornerRadius = 6
        gameImageView.kf.indicatorType = .activity
        (gameImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .systemYellow
        gameImageView.layer.cornerRadius = 20
        gameImageView.layer.shadowRadius = 20
        gameTitleLabel.adjustsFontSizeToFitWidth = true
        gameTitleLabel.sizeToFit()
        noteDescriptionLabel.sizeToFit()
        noteTitleLabel.sizeToFit()


    }
    
    func configure(with model: NoteCellModel) {
        gameImageView.kf.setImage(with: URL(string: model.imageBackground)) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueColor = averageColor?.withAlphaComponent(0.5)
                self.backgroundColor = opaqueColor
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        gameTitleLabel.text = model.gameTitle
        createdDateLabel.text = model.createdDate
        noteTitleLabel.text = model.noteTitle.uppercased()
        noteDescriptionLabel.text = model.noteDescription
    }

}

struct NoteCellModel{
    var gameTitle: String
    var imageBackground: String
    var createdDate: String
    var noteTitle: String
    var noteDescription: String
}
