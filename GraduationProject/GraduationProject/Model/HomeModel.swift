import Foundation
import CoreData
import UIKit

protocol HomeModelProtocol: AnyObject {
  
  func didPopularDataFetch()
  func didLatestDataFetch()
  func didDataCouldntFetch()
}

class HomeModel {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  private(set) var popularData: [GameResult] = []
  private(set) var latestData: [GameResult] = []
  
  weak var delegate: HomeModelProtocol?
  
  func fetchPopularData() {
      APICaller.shared.fetchGames(url: APIConstants.LATEST_URL, expecting: GamesResponse.self, randomPageNumber: 1) { response in
          switch(response) {
          case .success(let data):
              self.latestData = data.results ?? []
              self.delegate?.didLatestDataFetch()
          case .failure(_):
              self.delegate?.didDataCouldntFetch()
          }
      }
  }
    
    func fetchLatestData() {
        APICaller.shared.fetchGames(url: APIConstants.POPULAR_URL, expecting: GamesResponse.self, randomPageNumber: 1) { response in
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
