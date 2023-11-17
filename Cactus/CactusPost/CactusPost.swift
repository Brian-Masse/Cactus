//
//  CactusPost.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift

class CactusPost: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var ownerID: String = ""

    @Persisted var postTitle: String = ""
    @Persisted var postDescription: String = ""
    
    convenience init( ownerID: String, postTitle: String, postDescription: String ) {
        self.init()
        
        self.ownerID = ownerID
        self.postTitle = postTitle
        self.postDescription = postDescription
    }
    
}
