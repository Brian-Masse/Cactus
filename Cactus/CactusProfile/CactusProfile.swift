//
//  CactusProfile.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift

class CactusProfile: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    
    @Persisted var userName: String = ""
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    
    @Persisted var email: String = ""
    @Persisted var phoneNumber: Int = 0
    
}
