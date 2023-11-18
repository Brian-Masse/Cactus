//
//  CactusProfileCreationView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI


struct CactusProfileCreationView: View {
    
//    MARK: Vars
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    
    @State var email: String = ""
    @State var phoneNumber: Int = 0
    
    @State var icon: String = "greetingcard"
    
    
//    MARK: Struct Methods
    @MainActor
    private func submit() {
        
        let cactusProfile = CactusProfile(ownerID: CactusModel.ownerID,
                                          userName: userName,
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          phoneNumber: 0,
                                          icon: icon)
        
        RealmManager.addObject(cactusProfile)
        
        CactusModel.shared.postProfileCreationIntialization(cactusProfile)
    }
    
    
//    MARK: Body
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                UniversalText("Create Profile", size: Constants.UITitleTextSize, font: Constants.titleFont, true)
                Spacer()
            }
            UniversalText( CactusModel.ownerID, size: Constants.UISmallTextSize, font: Constants.mainFont )
                .padding(.bottom)
            
            TextFieldWithPrompt(title: "First Name", binding: $firstName)
            TextFieldWithPrompt(title: "Last Name", binding: $lastName)
            TextFieldWithPrompt(title: "User Name", binding: $userName)
            
            TextFieldWithPrompt(title: "email", binding: $email)
            
            TextFieldWithPrompt(title: "icon", binding: $icon)
            
            Spacer()
            
            UniversalButton(label: "submit", icon: "checkmark") { submit() }
                .padding(.bottom)
        }
    }
}
