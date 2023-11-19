//
//  CactusPost.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift

class CactusPost: Object, Identifiable{
    
//    MARK: PostPermisson
    enum PostPermission: Int, Identifiable, CaseIterable {
        static let defaultPermission: PostPermission = .publicPost
        
        case privatePost
        case publicPost
        case onlyFollowers
        
        var id: Int {
            self.rawValue
        }
        
        func getDescription() -> String {
            switch self {
            case .privatePost: return "private"
            case .publicPost: return "public"
            case .onlyFollowers: return "only followers can view"
            }
        }
        
        static func getPermission(from int: Int) -> PostPermission {
            PostPermission(rawValue: int) ?? .defaultPermission
        }
        
    }
    
    
//    MARK: Vars
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var ownerID: String = ""

    @Persisted var postTitle: String = ""
    @Persisted var postDescription: String = ""
    
    @Persisted var postPermission: Int = PostPermission.defaultPermission.rawValue
    
    convenience init( ownerID: String, postTitle: String, postDescription: String, postPermission: PostPermission ) {
        self.init()
        
        self.ownerID = ownerID
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.postPermission = postPermission.rawValue
    }
    
//    MARK: Convenience Functions
    
    func getPostPermission() -> PostPermission {
        PostPermission.getPermission(from: postPermission)
    }
    
}
