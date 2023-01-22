import Foundation

class HomeViewModel {
    // MARK: - Properties
    private let model = HomeModel()
    var onErrorDetected: ((String) -> ())?
    var latestGames: (([LatestCellModel]) -> ())?
    var popularGames: (([SearchCellModel]) -> ())?
    
    var currentPage = 1
    init() {
        model.delegate = self
    }
    
    func didViewLoad() {
        model.fetchLatestData(pagination: 1)
        model.fetchPopularData(pagination: 1)
    }
    ///this method is triggered if the last item is reached.
    func fetchPopularDataWithPagination(page: Int){
        model.fetchPopularData(pagination: page)
    }
    ///this method is triggered if the last item is reached.
    func fetchLatestDataWithPagination(page: Int){
        model.fetchLatestData(pagination: page)
    }
    
}

extension HomeViewModel: HomeModelProtocol {
    
    func didPopularDataFetch() {
        let cellModels: [SearchCellModel] = model.popularData.map{.init(id: $0.id ?? 0, imageURL: $0.backgroundImage ?? "", playTime: String($0.playtime ?? 0), releaseDate: $0.released ?? "", title: $0.name ?? "", vote: String($0.rating ?? 0.0))}
        popularGames?(cellModels)
    }
    
    func didLatestDataFetch() {
        let cellModels: [LatestCellModel] = model.latestData.map{.init(id: $0.id ?? 0, imageURL: $0.backgroundImage ?? "", vote: String($0.rating ?? 0.0), title: $0.name ?? "")}
        latestGames?(cellModels)
    }
    
    func didDataCouldntFetch() {
        onErrorDetected?("Hata oluştu, lütfen daha sonra tekrar deneyiniz!".localized())
    }
}
