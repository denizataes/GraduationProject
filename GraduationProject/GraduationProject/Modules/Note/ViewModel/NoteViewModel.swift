import Foundation
import CoreData

class NoteViewModel {
    
    // MARK: - Properties and closures
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
    
    ///sort notes by date
    func orderByDate(vm: [NoteVM]) -> [NoteVM]{
        let convertedObjects = vm
            .sorted { $0.createdDate > $1.createdDate }
        return convertedObjects
    }


    ///Pulls notes from coredata
    func fetchNotes() {
        CoreDataManager.shared.fetch(objectType: Notes.self) { [weak self] response in
            switch response {
            case .success(let notes):
                let noteList: [NoteVM] = notes.map{.init(id:$0.id ?? UUID() ,gameID: $0.gameID ?? "", gameName: $0.name ?? "", noteTitle: $0.noteTitle ?? "", noteDescription: $0.noteDescription ?? "", imageBackground: $0.backgroundImage ?? "", createdDate: $0.createdDate ?? Date())
                }
                self?.noteList?(self?.orderByDate(vm: noteList) ?? [])
            case .failure(_):
                self?.onErrorDetected?("Notlar yüklenirken hata oluştu! Lütfen daha sonra tekrar deneyin.".localized())
            }
        }
    }
    
    ///shows notification above
    func showNotification(title: String, type: NotificationType){
        delegate?.didNotificationShow(title: title, type: type)
    }
    
    ///Deletes the note
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


