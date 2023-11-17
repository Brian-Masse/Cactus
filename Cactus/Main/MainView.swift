//
//  MainView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI
import RealmSwift

struct MainView: View {
    
    @ObservedResults( CactusPost.self ) var posts
    
    let cactusProfile = CactusModel.shared.cactusProfile!
    
    @State var showingProfileView: Bool = false
    @State var showingPostCreationView: Bool = false
    
    
//    MARK: Body
    var body: some View {
        
    
        VStack(alignment: .leading) {
            
            UniversalText("Cactus", size: Constants.UITitleTextSize, font: Constants.titleFont, true)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach( posts ) { post in
                        CactusPostView(post: post)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                UniversalButton(label: "profile", icon: "person") { showingProfileView = true }
                UniversalButton(label: "Post", icon: "plus") { showingPostCreationView = true }
                
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showingProfileView) {
            CactusProfileView(profile: cactusProfile)
        }
        .sheet(isPresented: $showingPostCreationView) {
            CactusPostCreationView()
        }
        
        
    }
    
}
