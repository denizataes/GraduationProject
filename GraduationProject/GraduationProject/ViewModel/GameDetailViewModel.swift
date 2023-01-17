//
//  GameDetailViewModel.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 16.01.2023.
//

import Foundation
import CoreData
class GameDetailViewModel{
    private let model = GameDetailModel()
    
    var didFavorited: ((Bool) -> ())?
    var onErrorDetected: ((String) -> ())?
    var gameDetail: ((GameVM) -> ())?
    
    var didFavoriteSaved: (() ->())?
    var onErrorFavorite: (() -> ())?
    var didFavoriteDelete: (() ->())?
    
    var onErrorDeleteFavorite: (() -> ())?
    
    init(){
        model.delegate = self
    }
    
    func didViewLoad(id: String) {
        model.fetchGameDetail(with: id)
        isFavorited(with: id)
    }
    
    func saveFavorite(vm: FavoriteVM){
        let context = CoreDataManager.shared.managedContext
        if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context) {
            let favObj = NSManagedObject(entity: entity, insertInto: context)
            favObj.setValue(vm.gameID, forKey: "gameID")
            favObj.setValue(vm.backgroundImage, forKey: "backgroundImage")
            favObj.setValue(vm.name, forKey: "name")
            favObj.setValue(vm.createdDate, forKey: "createdDate")
            CoreDataManager.shared.save(object: favObj) { result in
                switch(result){
                case .success(()):
                    self.didFavoriteSaved?()
                case .failure(_):
                    self.onErrorFavorite?()
                }
            }
        }
    }
    
    func deleteFavorite(id: String){
        let context = CoreDataManager.shared.managedContext
        if NSEntityDescription.entity(forEntityName: "Favorites", in: context) != nil {
            CoreDataManager.shared.fetch(objectType: Favorites.self, predicate: .init(format: "gameID==\(id)")) {[weak self] result in
                switch(result){
                case .success(let favorite):
                    CoreDataManager.shared.delete(object: favorite) { response in
                        switch(response){
                        case .success():
                            self?.didFavoriteDelete?()
                        case .failure(_):
                            self?.onErrorDeleteFavorite?()
                        }
                    }
                case .failure(_):
                    self?.onErrorDeleteFavorite?()
                }
            }
        }
    }
    
    
    
    func isFavorited(with gameID: String){
        CoreDataManager.shared.fetch(objectType: Favorites.self,
                                     predicate: .init(format: "gameID==\(gameID)")){[weak self] res in
            switch res {
            case .success(let fav):
                if fav.count >= 1 {
                    self?.didFavorited?(true)
                }
                else{
                    self?.didFavorited?(false)
                }
            case .failure(_):
                self?.onErrorDetected?("Hata oluştu, lütfen daha sonra tekrar deneyiniz!")
            }
            
        }
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

struct FavoriteVM {
    var gameID: String
    var backgroundImage: String
    var name: String
    var createdDate: String
}
