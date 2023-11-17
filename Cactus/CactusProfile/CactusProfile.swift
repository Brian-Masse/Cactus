//
//  CactusProfile.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift

class CactusProfile: Object {
    
//    MARK: Vars
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerID: String = ""
    
    @Persisted var userName: String = ""
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    
    @Persisted var email: String = ""
    @Persisted var phoneNumber: Int = 0
    
    @Persisted var icon: String = ""
    
//    MARK: Init
    convenience init( ownerID: String, userName: String, firstName: String, lastName: String, email: String, phoneNumber: Int, icon: String ) {
        self.init()
        
        self.ownerID = ownerID
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.icon = icon
        
    }
    
//    MARK: Convenience Functions
    func fullName() -> String {
        "\(firstName) \(lastName)"
    }
}
