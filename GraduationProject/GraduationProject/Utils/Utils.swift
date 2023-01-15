//
//  SearchViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 10.01.2023.
//

import Foundation

class Utils{
    static let shared = Utils()
    
    ///Convert string to datetime.
    func convertDate(dateString: String?) -> String{
        guard dateString != "" else {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-DD"
        let date = dateFormatter.date(from: dateString!)
        dateFormatter.dateFormat = "DD.mm.yyyy"
        let monthAndYear = dateFormatter.string(from: date!)
        return monthAndYear
        
    }
}


