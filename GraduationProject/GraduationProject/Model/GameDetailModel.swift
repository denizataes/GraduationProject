//
//  GameDetailModel.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 16.01.2023.
//

import Foundation
protocol GameDetailProtocol: AnyObject {
    func didDetailDataFetch()
    func didDataCouldntFetch()
}

class GameDetailModel{
    private(set) var gameDetail = [GameDetail]()
    weak var delegate: GameDetailProtocol?
    
    func fetchGameDetail(with gameID: String) {
        APICaller.shared.fetchSpecificGameDetails(with: gameID, expecting: GameDetail.self) { response in
            switch(response) {
            case .success(let data):
                self.gameDetail = [data]
                self.delegate?.didDetailDataFetch()
            case .failure(_):
                self.delegate?.didDataCouldntFetch()
            }
        }
    }
    
}



