//
//  CactusProfileView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI


struct CactusProfileView: View {
    
    let profile: CactusProfile
    
//    MARK: View Builders
    @ViewBuilder
    private func makeProfileMetaDataLabel( title: String, content: String ) -> some View {
        
        VStack(alignment: .leading) {
            UniversalText( title, size: Constants.UISubHeaderTextSize, font: Constants.titleFont, true )
            UniversalText( content, size: Constants.UIDefaultTextSize, font: Constants.mainFont )
        }
        .padding(.bottom)
    }
    
//    MARK: Body
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                ResizeableIcon(icon: profile.icon, size: Constants.UITitleTextSize)
                UniversalText( profile.fullName(), size: Constants.UITitleTextSize, font: Constants.titleFont, true)
                Spacer()
            }
            UniversalText( profile.ownerID, size: Constants.UISmallTextSize, font: Constants.mainFont)
                .padding(.bottom)
        
            
            makeProfileMetaDataLabel(title: "email", content: profile.email)
            makeProfileMetaDataLabel(title: "phone number", content: "\(profile.phoneNumber)")
                .padding(.bottom)
            
            
            Spacer()
        }.padding()
    }
    
}
