//
//  SearchSection.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 14.01.2023.
//
import Foundation

enum SearchSection: String, CaseIterable{
    case popularity
    case released
    case name
    
    var buttonTitle: String{
        switch self{
        case .popularity: return "Popülerlik".localized()
        case .released: return "Çıkış Tarihi".localized()
        case .name: return "İsim".localized()
        }
    }
    
    var buttonTextForQuery: String{
        switch self{
        case .popularity: return "-rating"
        case .released: return "-released"
        case .name: return "-name"
        }
    }
}
