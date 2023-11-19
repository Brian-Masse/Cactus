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
    @State var postPermission: CactusPost.PostPermission = .defaultPermission
    
//    MARK: Struct Methods
    private func submit() {
        let post = CactusPost(ownerID: CactusModel.ownerID,
                              postTitle: postTitle,
                              postDescription: postDescription,
                              postPermission: postPermission)
        RealmManager.addObject(post)
        
        presentationMode.wrappedValue.dismiss()
    }
    
//    MARK: ViewBuilders
    @ViewBuilder
    private func makePersmissionSelectorNode( _ persmission: CactusPost.PostPermission ) -> some View {
        HStack {
            Spacer()
            UniversalText( persmission.getDescription(), size: Constants.UIDefaultTextSize, font: Constants.titleFont, true)
            Spacer()
        }
        .if(persmission == postPermission) { view in view.tintRectangularBackground() }
        .if(persmission != postPermission) { view in view.secondaryOpaqueRectangularBackground() }
        .onTapGesture { withAnimation { postPermission = persmission } }
    }
    
    @ViewBuilder
    private func makePersmissionSelector() -> some View {
        
        HStack {
            ForEach( CactusPost.PostPermission.allCases ) { content in
                makePersmissionSelectorNode(content)
            }
        }
        
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
            
            makePersmissionSelector()
        
            Spacer()
            
            UniversalButton(label: "Create", icon: "arrow.checkmark") {
                submit()
            }
            .padding(.bottom)
            
        }
        .padding()
    }
}
