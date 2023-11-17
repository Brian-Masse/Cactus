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
    
    
    var body: some View {
        
    
        VStack {
            
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
            
        }
        
        
    }
    
}
