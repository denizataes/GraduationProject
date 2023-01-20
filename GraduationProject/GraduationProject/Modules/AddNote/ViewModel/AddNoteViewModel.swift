import Foundation
import CoreData

class AddNoteViewModel {
    
    var onErrorDetected: (() -> ())?
    var didNoteSave: (() -> ())?
    var didNoteUpdate: (() -> ())?
    
    func saveNote(vm: NoteVM){
        let context = CoreDataManager.shared.managedContext
        if let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context) {
            let favObj = NSManagedObject(entity: entity, insertInto: context)
            favObj.setValue(UUID(), forKey: "id")
            favObj.setValue(vm.gameID, forKey: "gameID")
            favObj.setValue(vm.imageBackground, forKey: "backgroundImage")
            favObj.setValue(vm.gameName, forKey: "name")
            favObj.setValue(vm.noteDescription, forKey: "noteDescription")
            favObj.setValue(vm.noteTitle, forKey: "noteTitle")
            favObj.setValue(vm.createdDate, forKey: "createdDate")
            CoreDataManager.shared.save(object: favObj) { result in
                switch(result){
                case .success(()):
                    self.didNoteSave?()
                case .failure(_):
                    self.onErrorDetected?()
                }
            }
        }
    }
    
    func updateNote(vm: NoteVM) {
        let context = CoreDataManager.shared.managedContext
        if NSEntityDescription.entity(forEntityName: "Notes", in: context) != nil {
            CoreDataManager.shared.fetch(objectType: Notes.self, predicate: .init(format: "id = '\(vm.id.uuidString)'")) {[weak self] res in
                switch(res){
                case .success(let note):
                    let updateNote = note[0]
                    updateNote.noteDescription = vm.noteDescription
                    updateNote.noteTitle = vm.noteTitle
                    updateNote.createdDate = Utils.shared.getDate()
                    CoreDataManager.shared.save(object: updateNote) { result in
                        switch(result){
                        case .success(()):
                            self?.didNoteUpdate?()
                        case .failure(_):
                            self?.onErrorDetected?()
                        }
                    }
                case .failure(_):
                    self?.onErrorDetected?()
                }
            }
        }
    }
}

struct NoteVM{
    var id: UUID
    var gameID: String
    var gameName: String
    var noteTitle: String
    var noteDescription: String
    var imageBackground: String
    var createdDate: String
}
