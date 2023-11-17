//
//  CactusModel.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI

class CactusModel: ObservableObject {
    
//    MARK: Static Vars
    static let shared: CactusModel = CactusModel()
    static let realmManager: RealmManager = RealmManager()
    static let authenticationManager: AuthenticationManager = AuthenticationManager()
    
    static var ownerID: String {
        realmManager.currentUser(enumAppID: .cactusMain)?.id ?? ""
    }
    
//    MARK: State
    enum AppState: String, Identifiable {
        case authenitcation
        case openingRealm
        case app
        case error
        
        var id: String {
            self.rawValue
        }
    }
    
    @Published var appState: AppState = .authenitcation
    
    var activeColor: Color = Colors.main
    
//    MARK: Initialization Structure
    @MainActor
    func initializeApp() async {
        
        CactusModel.realmManager.openInitialApps()
        
//        this piece should be replaced with displaying a UI for the user to SignIn
//        Then it should connect to the authenticationManager to log them in
//        This is a temporary work around to just create an anonymous user to use the app
//        let user = await CactusModel.authenticationManager.getOrLoginCurrentUser(forApp: RealmManager.AppID.cactusMain.rawValue)
//        if user == nil { self.appState = .error; return }
    }
    
    @MainActor
    func postAuthenitcationInitialization() async {
        
        self.appState = .openingRealm

        await CactusModel.realmManager.openInitialRealms()
        if CactusModel.realmManager.realm() == nil { self.appState = .error; return }
        self.appState = .app
        
    }
    
}
