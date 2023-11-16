//
//  ContentView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import SwiftUI
import SwiftData

struct CactusView: View {
    
    @ObservedObject var cactusModel: CactusModel = CactusModel.shared
    
    
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
                Text( "this is the app!" )
                
                Text("create Test Object")
                    .onTapGesture {
                    
                        
//                        let testObject = TestObject(ownerID: CactusModel.ownerID, name: "Brian Masse")
//                        RealmManager.addObject(testObject)
//                        
//                        print("this ran")
                    }
            }
        }
        .task { await cactusModel.initializeApp() }
        
    }
    
    
}
