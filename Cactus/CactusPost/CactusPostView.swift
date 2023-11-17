//
//  CactusPostView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI

struct CactusPostView: View {
    
    let post: CactusPost
    
    var body: some View {
        
        
        VStack(alignment: .leading) {

            Text( post.postTitle )
            Text( post.postDescription )
            
        }
        .padding()
        .background(
            Rectangle()
                .foregroundStyle(.gray)
        )
        
    }
    
}
