//
//  ContentView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import SwiftUI
import SwiftData
import RealmSwift

struct CactusView: View {
    
    @ObservedObject var cactusModel: CactusModel = CactusModel.shared
    
    let realmManager = CactusModel.realmManager
    
    var body: some View {
    
        VStack {
            switch cactusModel.appState {
            case .error:
                Text("an error occured")
                
            case .authenitcation:
                Text("authenticating an anoynmous user")
                
            case .openingRealm:
                Text( "opening the default realm" )
                
            case .app:
                MainView()
                    .environment(\.realmConfiguration, realmManager.mainRealmConfiguration)
            }
        }
        .task { await cactusModel.initializeApp() }
        
    }
    
    
}
