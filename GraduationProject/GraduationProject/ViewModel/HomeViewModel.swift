import Foundation

class HomeViewModel {
  
  private let model = HomeModel()
  
  var onErrorDetected: ((String) -> ())?
  var latestGames: (([LatestCellModel]) -> ())?
  var popularGames: (([SearchCellModel]) -> ())?
  
  init() {
    model.delegate = self
  }
  
  func didViewLoad() {
    model.fetchLatestData()
    model.fetchPopularData()
  }
  
  func itemPressed(_ index: Int) {
    //    TODO:
  }
}

extension HomeViewModel: HomeModelProtocol {
  
  func didPopularDataFetch() {
      
      let cellModels: [SearchCellModel] = model.popularData.map{.init(imageURL: $0.backgroundImage ?? "", playTime: String($0.playtime ?? 0), releaseDate: $0.released ?? "", title: $0.name ?? "", vote: String($0.rating ?? 0.0) )}
      popularGames?(cellModels)
      
  }
  
  func didLatestDataFetch() {
      let cellModels: [LatestCellModel] = model.latestData.map{.init(imageURL: $0.backgroundImage ?? "", vote: String($0.rating ?? 0.0), title: $0.name ?? "")}
      latestGames?(cellModels)
  }
  
  func didDataCouldntFetch() {
    onErrorDetected?("Hata oluştu, lütfen daha sonra tekrar deneyiniz!")
  }
}
