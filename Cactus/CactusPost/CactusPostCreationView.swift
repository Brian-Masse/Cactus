//
//  CactusPostCreationView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI

struct CactusPostCreationView: View {
    
    @State var postTitle: String = ""
    @State var postDescription: String = ""
    
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            Text("Create Post")
            
            TextField("title", text: $postTitle, axis: .vertical)
                .lineLimit(1)
            
            TextField("description", text: $postDescription, axis: .vertical)
                .lineLimit(1...5)
            
            Text("Create")
                .onTapGesture {
                    
                    let post = CactusPost(ownerID: CactusModel.ownerID,
                                          postTitle: postTitle,
                                          postDescription: postDescription)
                    RealmManager.addObject(post)
                    
//                    let testObject = TestObject(ownerID: CactusModel.ownerID, name: "hello world")
//                    RealmManager.addObject(testObject)
                    
                }
        }
        
        
    }
    
    
}
