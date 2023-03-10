import Foundation
import CoreData

class FavoriteViewModel {
    
    // MARK: - Properties
    var onErrorDetected: ((String) -> ())?
    var favoriteList: (([FavoriteVM]) -> ())?
    weak var delegate: NotificationManagerProtocol?
    
    init(){
        delegate = LocalNotificationManager.shared
    }
    
    func didViewLoad() {
        fetchFavorites()
    }
    ///sort favorites by day
    func orderByDate(vm: [FavoriteVM]) -> [FavoriteVM]{
        let convertedObjects = vm
            .sorted { $0.createdDate > $1.createdDate }
        return convertedObjects
    }


    ///pulls favorites from coredata
    func fetchFavorites() {
        CoreDataManager.shared.fetch(objectType: Favorites.self) { [self] response in
            switch response {
            case .success(let favorites):
                let favList: [FavoriteVM] = favorites.map{.init(gameID: $0.gameID ?? "", backgroundImage: $0.backgroundImage ?? "", name: $0.name ?? "", createdDate: $0.createdDate ?? Date() )}
                favoriteList?(orderByDate(vm: favList))
            case .failure(_):
                self.onErrorDetected?("Favoriler yüklenirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
            }
        }
        
    }
    ///delete from favorites
    func deleteFavorite(id: String){
        let context = CoreDataManager.shared.managedContext
        if NSEntityDescription.entity(forEntityName: "Favorites", in: context) != nil {
            CoreDataManager.shared.fetch(objectType: Favorites.self, predicate: .init(format: "gameID==\(id)")) {[weak self] result in
                switch(result){
                case .success(let favorite):
                    CoreDataManager.shared.delete(object: favorite) { response in
                        switch(response){
                        case .success():
                            self?.showNotification(title: "", type: NotificationType.favoriteDelete)
                        case .failure(_):
                            self?.onErrorDetected?("Favori silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
                        }
                        
                        
                    }
                case .failure(_):
                    self?.onErrorDetected?("Favori silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
                }
            }
        }
    }
    ///delete from favorites
    func showNotification(title: String, type: NotificationType){
        delegate?.didNotificationShow(title: title, type: type)
    }
    
}
