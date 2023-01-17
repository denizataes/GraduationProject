import Foundation
import CoreData

class FavoriteViewModel {

  var onErrorDetected: ((String) -> ())?
  var favoriteList: (([FavoriteVM]) -> ())?
  
  func didViewLoad() {
      fetchFavorites()
  }
  
  func fetchFavorites() {
      CoreDataManager.shared.fetch(objectType: Favorites.self) { [self] response in
          switch response {
          case .success(let favorites):
              let favList: [FavoriteVM] = favorites.map{.init(gameID: $0.gameID ?? "", backgroundImage: $0.backgroundImage ?? "", name: $0.name ?? "", createdDate: $0.createdDate ?? "")}
              favoriteList?(favList)
              
          case .failure(_):
              self.onErrorDetected?("Favoriler yüklenirken hata oluştu! Lütfen daha sonra tekrar deneyin.")
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
                            print("Deleted")
                        case .failure(_):
                            self?.onErrorDetected?("Favori silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.")
                        }
                    }
                case .failure(_):
                    self?.onErrorDetected?("Favori silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.")
                }
            }
        }
    }
}
