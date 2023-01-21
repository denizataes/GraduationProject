import Foundation
import CoreData
import UIKit

protocol HomeModelProtocol: AnyObject {
    func didPopularDataFetch()
    func didLatestDataFetch()
    func didDataCouldntFetch()
}

class HomeModel {
    // MARK: - Properties
    private(set) var popularData: [GameResult] = []
    private(set) var latestData: [GameResult] = []
    
    weak var delegate: HomeModelProtocol?
    
    func fetchLatestData(pagination: Int) {
        var url = APIConstants.LATEST_URL
        url = url + "&page=\(pagination)"
        
        APICaller.shared.fetchGames(url: url, expecting: GamesResponse.self, randomPageNumber: pagination) { response in
            switch(response) {
            case .success(let data):
                self.latestData = data.results ?? []
                self.delegate?.didLatestDataFetch()
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.didDataCouldntFetch()
            }
        }
    }
    
    func fetchPopularData(pagination: Int) {
        
        var url = APIConstants.LATEST_URL
        url = url + "&page=\(pagination)"
        APICaller.shared.fetchGames(url: url, expecting: GamesResponse.self, randomPageNumber: pagination) { response in
            switch(response) {
            case .success(let data):
                self.popularData = data.results ?? []
                self.delegate?.didPopularDataFetch()
            case .failure(_):
                self.delegate?.didDataCouldntFetch()
            }
        }
    }
}
