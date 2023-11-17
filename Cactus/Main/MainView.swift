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
    
    
//    MARK: Body
    var body: some View {
        
    
        VStack(alignment: .leading) {
            
            UniversalButton(label: "profile", icon: "person") { showingProfileView = true }
            
            Text("Posts")
                .onTapGesture {
                    
                    let posts: [CactusPost] = RealmManager.retrieveObjects()
                    print(posts.count)
                }
            
            ForEach( posts ) { post in
                CactusPostView(post: post)
                Text("hello")
            }
            
            Text("Creation View")
            
            CactusPostCreationView()
            
            Spacer()
            UniversalText( CactusModel.ownerID, size: Constants.UISmallTextSize, font: Constants.mainFont )
            
        }
        .sheet(isPresented: $showingProfileView) {
            CactusProfileView(profile: cactusProfile)
        }
        
        
    }
    
}
