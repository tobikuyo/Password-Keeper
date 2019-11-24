//
//  PasswordController.swift
//  iPasswordKeeper
//
//  Created by Tobi Kuyoro on 23/11/2019.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class PasswordController {
    
    let fireBaseURL = URL(string: "https://password-keeper-87eb9.firebaseio.com/")!
    
    func put(password: Password, completion: @escaping()-> Void = {} ) {
        
        let identifier = password.identifier ?? UUID()
        password.identifier = identifier
        
         let requestURL = fireBaseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let representation = password.passwordRepresntation else {
            NSLog("Error")
            completion()
            return
        }
        
        do {
           request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error{
                NSLog("Error putting task: \(error)")
                completion()
                return
            }
            completion()
            }.resume()
        
        
    }
    
    
    
    func fetchEntryFromServer(completion: @escaping()-> Void = {}){
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error{
                NSLog("error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else{
                NSLog("Error getting data task:")
                completion()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                
                let passwordRepresentation = Array(try decoder.decode([String: PasswordRepresentation].self, from: data).values)
            
                self.update(with: passwordRepresentation)
            } catch {
                NSLog("Error decoding: \(error)")
            }
        
        
        
       }.resume()
        
    }
        
        
        func update(with representations: [PasswordRepresentation]){
            
            
            let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
            
            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
            
            //Make a mutable copy of Dictionary above
            var passwordToCreate = representationsByID
            
            
            let context = CoreDataStack.share.container.newBackgroundContext()
            context.performAndWait {
                
                
                
                do {
                    
                    let fetchRequest: NSFetchRequest<Password> = Password.fetchRequest()
                    //Name of Attibute
                    fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                    
                    //Which of these tasks already exist in core data?
                    let exisitingPassword = try context.fetch(fetchRequest)
                    
                    //Which need to be updated? Which need to be put into core data?
                    for password in exisitingPassword {
                        guard let identifier = password.identifier,
                            // This gets the task representation that corresponds to the task from Core Data
                            let representation = representationsByID[identifier] else{return}
                        
                         password.passwordString = representation.passwordString
                         password.website = representation.website
                        
                        passwordToCreate.removeValue(forKey: identifier)
                        
                    }
                    //Take these tasks that arent in core data and create
                    for representation in passwordToCreate.values{
                        Password(passwordRepresentation: representation, context: context)
                    }
                    
                    CoreDataStack.share.save(context: context)
                    
                } catch {
                    NSLog("Error fetching tasks from persistent store: \(error)")
                }
            }
            
            
        }
        
        
        //CRUD
        
    @discardableResult func cratePassword(with passwordString: String, website: String) -> Password {
        let password = Password(passwordString: passwordString, website: website, context: CoreDataStack.share.mainContext)
        
        put(password: password)
        CoreDataStack.share.save()
        
        return password
    }
    
    
    
    func updatePassword(password: Password, with passwordString: String, website: String){
        
        password.passwordString = passwordString
        password.website = website
        
        put(password: password)
        CoreDataStack.share.save()
        
    }
    
    func delete(password: Password){
        
        CoreDataStack.share.mainContext.delete(password)
        CoreDataStack.share.save()
        
    }
}

