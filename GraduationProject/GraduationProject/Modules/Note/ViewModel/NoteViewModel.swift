import Foundation
import CoreData

class NoteViewModel {
    
    // MARK: - Properties
    var onErrorDetected: ((String) -> ())?
    var noteList: (([NoteVM]) -> ())?
    var didNoteDeleted: (() -> ())?
    weak var delegate: NotificationManagerProtocol?
    
    init(){
        delegate = LocalNotificationManager.shared
    }
    
    func didViewLoad() {
        fetchNotes()
    }
    
    func orderByDate(vm: [NoteVM]) -> [NoteVM] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "DD.MM.YYYY HH:mm"
        let convertedObjects = vm
            .map { return ($0, dateFormatter.date(from: $0.createdDate)!) }
            .sorted { $0.1 < $1.1 }
            .map(\.0)
        return convertedObjects
    }

    
    func fetchNotes() {
        CoreDataManager.shared.fetch(objectType: Notes.self) { [weak self] response in
            switch response {
            case .success(let notes):
                let noteList: [NoteVM] = notes.map{.init(id:$0.id ?? UUID() ,gameID: $0.gameID ?? "", gameName: $0.name ?? "", noteTitle: $0.noteTitle ?? "", noteDescription: $0.noteDescription ?? "", imageBackground: $0.backgroundImage ?? "", createdDate: $0.createdDate ?? "")
                }
                self?.noteList?(self?.orderByDate(vm: noteList) ?? [])
            case .failure(_):
                self?.onErrorDetected?("Notlar yüklenirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
            }
        }
    }
    
    func showNotification(title: String, type: NotificationType){
        delegate?.didNotificationShow(title: title, type: type)
    }
    
    func deleteNotes(id: UUID){
        let context = CoreDataManager.shared.managedContext
        if NSEntityDescription.entity(forEntityName: "Notes", in: context) != nil {
            CoreDataManager.shared.fetch(objectType: Notes.self, predicate: .init(format: "%K == %@", "id", id as CVarArg)) {[weak self] result in
                switch(result){
                case .success(let note):
                    CoreDataManager.shared.delete(object: note) { response in
                        switch(response){
                        case .success():
                            self?.didNoteDeleted?()
                        case .failure(_):
                            self?.onErrorDetected?("Not silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
                        }
                    }
                case .failure(_):
                    self?.onErrorDetected?("Not silinirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
                }
            }
        }
    }
}


