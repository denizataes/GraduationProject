//
//  SearchModel.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 14.01.2023.
//

import Foundation
import UIKit

protocol SearchModelProtocol: AnyObject {
    func didSearchDataFetch()
    func didDataCouldntFetch()
}

class SearchModel{
    // MARK: - Properties
    private(set) var searchData: [GameResult] = []
    weak var delegate: SearchModelProtocol?
    
    func fetchSearchData(query: String, filter: String, page: Int) {
        APICaller.shared.fetchGamesWithSearchQuery(url: APIConstants.SEARCH_URL,
                                                   page: page,
                                                   filter: filter,
                                                   query: query,
                                                   expecting: GamesResponse.self) { response in
            switch(response) {
            case .success(let data):
                self.searchData = data.results ?? []
                self.delegate?.didSearchDataFetch()
            case .failure(_):
                self.delegate?.didDataCouldntFetch()
            }
        }
    }
    
}
