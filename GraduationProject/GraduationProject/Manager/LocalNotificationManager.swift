//
//  LocalNotificationManager.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 19.01.2023.
//

import Foundation
import UserNotifications

class LocalNotificationManager: NotificationManagerProtocol {
    // MARK: - Properties
    static let shared = LocalNotificationManager()
    
    func didNotificationShow(title: String, type: NotificationType) {
        let content = UNMutableNotificationContent()
        content.title = "\("Başarılı".localized())✅"
        if title.count > 0{
            content.body = ("\(title) \(type.description)")
        }
        else{
            content.body = ("\(type.description)")
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "showNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

enum NotificationType: String, CaseIterable{
    case noteAdd
    case favoriteAdd
    case noteDelete
    case favoriteDelete
    case noteUpdate
    
    var description: String{
        switch self{
            
        case .favoriteAdd: return "\("oyunu favorilerine eklendi.".localized())❤️"
        case .noteAdd: return "\("oyunu ile ilgili düşüncelerin notlarına eklendi.".localized())🤔"
        case .noteDelete: return "\("Notun silindi.".localized())🗑️"
        case .favoriteDelete: return "\("Favorin silindi.".localized())🗑️"
        
        case .noteUpdate: return "adlı not güncellendi.".localized()
        }
    }
}
