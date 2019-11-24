//
//  Password+Convenience.swift
//  iPasswordKeeper
//
//  Created by Tobi Kuyoro on 23/11/2019.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Password {
    
    var passwordRepresntation: PasswordRepresentation? {
        
        guard let passwordString = passwordString,
        let website = website,
            let identifier = identifier?.uuidString else { return nil }
        
        return PasswordRepresentation(identifier: identifier, passwordString: passwordString, website: website)
    }
    
    convenience init(passwordString: String, website: String, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.passwordString = passwordString
        self.website = website
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(passwordRepresentation: PasswordRepresentation, context: NSManagedObjectContext) {
        guard let identifier = UUID(uuidString: passwordRepresentation.identifier) else { return nil }
        
        self.init(passwordString: passwordRepresentation.passwordString, website: passwordRepresentation.website, identifier: identifier, context: context)
    }
}
