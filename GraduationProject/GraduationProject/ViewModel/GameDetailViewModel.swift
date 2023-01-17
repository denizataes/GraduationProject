//
//  GameDetailViewModel.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 16.01.2023.
//

import Foundation
class GameDetailViewModel{
    private let model = GameDetailModel()
    
    var onErrorDetected: ((String) -> ())?
    var gameDetail: ((GameVM) -> ())?
    
    init(){
        model.delegate = self
    }
    
    func didViewLoad(id: String) {
        model.fetchGameDetail(with: id)
    }
    
}


extension GameDetailViewModel: GameDetailProtocol{
    func didDetailDataFetch() {
        let detail = model.gameDetail[0]
        let name = detail.name
        let backgroundImage = detail.background_image
        let rating: Double? = detail.rating
        let releaseDate = detail.released
        let playTime = detail.playtime
        var exceptional: Double = 0.0
        var reccomended: Double = 0.0
        var skip: Double = 0.0
        var meh: Double = 0.0
        let description = detail.description_raw
        var platforms = [ResultVM]()
        var genres = [ResultVM]()
        
        detail.ratings.forEach({ item in
            switch (item.title){
            case .exceptional:
                exceptional = item.percent ?? 0.0
            case .meh:
                meh = item.percent ?? 0.0
            case .recommended:
                reccomended = item.percent ?? 0.0
            case .skip:
                skip = item.percent ?? 0.0
            case .none:
                print("")
            }
        })
        
        detail.platforms?.forEach({ platform in
            let name = platform.platform?.name
            let image = platform.platform?.imageBackground
            let platformModel = ResultVM(name: name ?? "", image: image ?? "")
            platforms.append(platformModel)
        })
        
        detail.genres?.forEach({ genre in
            let name = genre.name
            let image = genre.imageBackground
            let genreModel = ResultVM(name: name ?? "", image: image ?? "")
            genres.append(genreModel)
        })
        
        let vm = GameVM(name: name ?? "", backgroundImage: backgroundImage ?? "", rating: rating ?? 0.0, releaseDate: Utils.shared.convertDate(dateString: releaseDate) , playTime: playTime ?? 0, exceptional: exceptional, recommended: reccomended, meh: meh, skip: skip, description: description ?? "", platforms: platforms, genres: genres)
        
        gameDetail?(vm)
    }
    
    func didDataCouldntFetch() {
        onErrorDetected?("Hata oluştu, lütfen daha sonra tekrar deneyiniz!")
    }
}

struct GameVM{
    var name: String
    var backgroundImage: String
    var rating: Double
    var releaseDate: String
    var playTime: Int
    var exceptional: Double
    var recommended: Double
    var meh: Double
    var skip: Double
    var description: String
    var platforms: [ResultVM]
    var genres: [ResultVM]
}

struct ResultVM{
    var name: String
    var image: String
}
