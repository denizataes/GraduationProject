//
//  SearchViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 10.01.2023.
//

import Foundation
import UIKit

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
    /// get formatted date
    func getDate() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD.MM.YY HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(MAXFLOAT)//alabileceği maximumum değer
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}


