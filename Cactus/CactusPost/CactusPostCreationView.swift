//
//  CactusPostCreationView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI

struct CactusPostCreationView: View {
    
//    MARK: Vars
    @Environment(\.presentationMode) var presentationMode
    
    @State var postTitle: String = ""
    @State var postDescription: String = ""
    
//    MARK: Struct Methods
    private func submit() {
        let post = CactusPost(ownerID: CactusModel.ownerID,
                              postTitle: postTitle,
                              postDescription: postDescription)
        RealmManager.addObject(post)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    
//    MARK: Body
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            HStack {
                UniversalText("Create Post", size: Constants.UITitleTextSize, font: Constants.titleFont, true)
                Spacer()
            }
            .padding(.bottom, 7)
            
            TextFieldWithPrompt(title: "title", binding: $postTitle)

            TextFieldWithPrompt(title: "description", binding: $postDescription)
        
            UniversalButton(label: "Create", icon: "arrow.checkmark") {
                submit()
            }
                
            Spacer()
        }
        .padding()
    }
}
