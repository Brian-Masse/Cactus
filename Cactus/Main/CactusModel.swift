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
        realmManager.currentUser()?.id ?? ""
    }
    
//    MARK: State
    enum AppState: String, Identifiable {
        case authenitcation
        case openingRealm
        case creatingProfile
        case app
        case error
        
        var id: String {
            self.rawValue
        }
    }
    
    @Published private(set) var appState: AppState = .authenitcation
    
//    MARK: Vars
    
    @Published var activeColor: Color = Colors.main
    
    @Published private(set) var cactusProfile: CactusProfile!
    
//    MARK: Initialization Structure
//    This is the main logic + structure from opening the app to being signed in using it.
//    It should also handle errors
    @MainActor
    func initializeApp() async {
        CactusModel.realmManager.openInitialApps()
        
        let user = CactusModel.authenticationManager.checkActiveUser()
        if user != nil { await self.postAuthenitcationInitialization() }
    }
    
    @MainActor
    func postAuthenitcationInitialization() async {
        
        self.appState = .openingRealm

        await CactusModel.realmManager.openInitialRealms()
        if CactusModel.realmManager.realm() == nil { self.appState = .error; return }
        
        let profile = CactusModel.authenticationManager.checkProfile()
        if profile == nil { self.appState = .creatingProfile }
        else { self.appState = .app }
    
    }
    
    @MainActor
    func postProfileCreationIntialization(_ profile: CactusProfile) {
        self.cactusProfile = profile
        self.appState = .app
    }
    
//    MARK: Class Methods
    func setProfile(_ profile: CactusProfile) {
        self.cactusProfile = profile
    }
    
    func setAppState( _ state: AppState ) {
        self.appState = state
    }
    
}
