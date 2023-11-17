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
                return nil
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
 
    
//    MARK: Credential Specific Login
    private func registerUser(_ email: String, _ password: String) async -> Error? {
        
        let client = CactusModel.realmManager.getApp( RealmManager.mainApp )!.emailPasswordAuth
        do {
            try await client.registerUser(email: email, password: password)
            return nil
        } catch {
            if error.localizedDescription == "name already in use" { return nil }
            print("failed to register user: \(error.localizedDescription)")
            return error
        }
    }
    
    func authenticateUserWithEmail( _ email: String, password: String ) async -> String? {
        
        let fixedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let fixedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if fixedEmail.isEmpty || fixedPassword.isEmpty { return "unable to authenticate user, invalid username or password" }
        
        let credentials = Credentials.emailPassword(email: fixedEmail, password: fixedPassword)
        
        if let error = await registerUser(fixedEmail, fixedPassword) {
            print( "error registering user: \(error.localizedDescription)")
            return error.localizedDescription
        }
        
        let user = await authenticateUser(for: RealmManager.mainApp, credentials: credentials)
        
        if user == nil { return "failed to authenticate user" }
        return nil
        
    }
}
