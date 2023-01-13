//
//  ViewController.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        APICaller.shared.fetchGames(url: APIConstants.POPULAR_URL, expecting: GamesResponse.self, randomPageNumber: Int.random(in: 4...10)) { [weak self] result in
//            switch result {
//            case .success(let response):
//                response.results.forEach { game in
//                    print(game.name)
//                    print(game.background_image)
//                }
//            case .failure(let error):
//                print(error)
//            }
//
//        }
        
//        APICaller.shared.fetchPlatform(url: APIConstants.PLATFORM_URL, expecting: Platform.self, randomPageNumber: Int(1)) { [weak self] result in
//            switch result {
//            case .success(let response):
//                response.results?.forEach({ platform in
//                    print(platform.name)
//
//                })
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        APICaller.shared.fetchGenres(url:  APIConstants.GENRE_URL, expecting: Genre.self) { [weak self] result in
//            switch result {
//            case .success(let response):
//                response.results?.forEach({ genre in
//                    print("GenreID = \(genre.id)")
//
//                })
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
        APICaller.shared.fetchGamesByGenre(url: APIConstants.API_KEY, genreID: 4 , expecting: Game.self
                                           , pageNumber: 1) { [weak self] result in
                        switch result {
                        case .success(let response):
                            print(response.name)

                        case .failure(let error):
                            print(error.localizedDescription)
                        }
        }

    }


}

