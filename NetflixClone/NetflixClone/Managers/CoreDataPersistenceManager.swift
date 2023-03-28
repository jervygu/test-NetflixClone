//
//  CoreDataPersistenceManager.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/28/23.
//

import UIKit
import CoreData

class CoreDataPersistenceManager {
    static let shared = CoreDataPersistenceManager()
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    func downloadShow(with model: Show, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = ShowEntity(context: context)
        
        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print("downloadShow: \(error.localizedDescription)")
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchShowFromCoreData(completion: @escaping(Result<[ShowEntity], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<ShowEntity>
        
        request = ShowEntity.fetchRequest()
        
        do {
            let shows = try context.fetch(request)
            completion(.success(shows))
            
            print("fetchShowFromCoreData shows: \(shows)")
            
        } catch {
            print("fetchShowFromCoreData: \(error.localizedDescription)")
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    
    func deleteShowFromCoreData(with model: ShowEntity, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print("deleteShowFromCoreData: \(error.localizedDescription)")
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
}
