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

            HStack {
                UniversalText(post.postTitle, size: Constants.UISubHeaderTextSize, font: Constants.titleFont, true)
                Spacer()
            }
            .padding(.bottom, 5)
            UniversalText( post.postDescription, size: Constants.UIDefaultTextSize, font: Constants.mainFont )
            
        }
        .padding()
        .secondaryOpaqueRectangularBackground()
        
    }
    
}
