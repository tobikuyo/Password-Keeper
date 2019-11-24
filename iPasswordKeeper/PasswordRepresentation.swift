//
//  PasswordRepresentation.swift
//  iPasswordKeeper
//
//  Created by Tobi Kuyoro on 23/11/2019.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct PasswordRepresentation: Codable {
    
    let identifier: String
    let passwordString: String
    let website: String
    
}
