//
//  AuthenticationManager.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import RealmSwift

class AuthenticationManager {
    
    func authenticateUser( for appID: String, credentials: RealmSwift.Credentials ) async -> RealmSwift.User? {
        
        if let app = CactusModel.realmManager.getApp( appID ) {
            do {
                return try await app.login(credentials: credentials)
            } catch {
                print( "authentcationManager failed to log user in with credentials: \(credentials), \(error.localizedDescription)" )
            }
        }
        print( "authenticationManager failed to log user in with credentials: \(credentials), no app was found." )
        return nil
    }
    
    private func checkActiveUser( forApp appID: String ) -> RealmSwift.User? {
        if let app = CactusModel.realmManager.getApp( appID ) {
            return app.currentUser
        }
        return nil
    }
    
    func getCurrentUser( forApp app: String ) -> RealmSwift.User? {
        checkActiveUser(forApp: app)
    }
    
    func getOrLoginCurrentUser( forApp app: String ) async -> RealmSwift.User? {
        await authenticateUser(for: app, credentials: .anonymous)
    }
    
}
