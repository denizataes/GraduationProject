//
//  SearchViewModel.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 14.01.2023.
//

import Foundation
class SearchViewModel {
    private let model = SearchModel()
    var onErrorDetected: ((String) -> ())?
    var searchGames: (([SearchCellModel]) -> ())?
    
    init() {
      model.delegate = self
    }
    func search(query: String, filter: String){
        model.fetchSearchData(query: query, filter: filter)
    }
    
}

extension SearchViewModel: SearchModelProtocol {
    func didSearchDataFetch() {
        let cellModels: [SearchCellModel] = model.searchData.map{.init(id: $0.id ?? 0, imageURL: $0.backgroundImage ?? "", playTime: String($0.playtime ?? 0), releaseDate: $0.released ?? "", title: $0.name ?? "", vote: String($0.rating ?? 0.0))}
            searchGames?(cellModels)
    }
    
    func didDataCouldntFetch() {
        onErrorDetected?("Hata oluştu, lütfen daha sonra tekrar deneyiniz!".localized())
    }

}
