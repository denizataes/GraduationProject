import CoreData
import UIKit

enum CoreDataError: Error {
    case failedToGetData
    case failedToSaveData
    case failedToDeleteData
}

class CoreDataManager {

// MARK: - Properties
static let shared = CoreDataManager()

private let appDelegate = UIApplication.shared.delegate as! AppDelegate

var managedContext: NSManagedObjectContext {
    return appDelegate.persistentContainer.viewContext
}

// MARK: - CRUD operations

    func save(object: NSManagedObject, onCompletion: @escaping (Result<Void, CoreDataError>) -> Void) {
    do {
        try managedContext.save()
        onCompletion(.success(()))
    } catch{
        onCompletion(.failure(CoreDataError.failedToSaveData))
    }
}

    func delete(object: [NSManagedObject], onCompletion: @escaping (Result<Void, CoreDataError>) -> Void) {
    do{
        object.forEach { obj in
            managedContext.delete(obj)
        }
        try managedContext.save()
        onCompletion(.success(()))
    } catch{
        onCompletion(.failure(CoreDataError.failedToDeleteData))
    }
}

func fetch<T: NSManagedObject>(objectType: T.Type, onCompletion: @escaping (Result<[T], CoreDataError>) -> Void) {
    let entityName = String(describing: objectType)
    let fetchRequest = NSFetchRequest<T>(entityName: entityName)
    do {
        let objects = try managedContext.fetch(fetchRequest)
        onCompletion(.success(objects))
    } catch{
        onCompletion(.failure(CoreDataError.failedToGetData))
    }
}

    func fetch<T: NSManagedObject>(objectType: T.Type, predicate: NSPredicate, onCompletion: @escaping (Result<[T], CoreDataError>) -> Void) {
    let entityName = String(describing: objectType)
    let fetchRequest = NSFetchRequest<T>(entityName: entityName)
    fetchRequest.predicate = predicate
    do {
        let objects = try managedContext.fetch(fetchRequest)
        onCompletion(.success(objects))
    } catch  {
        onCompletion(.failure(CoreDataError.failedToGetData))
    }
}

}
