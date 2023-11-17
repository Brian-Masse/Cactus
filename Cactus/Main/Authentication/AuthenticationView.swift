//
//  AuthenticationView.swift
//  Cactus
//
//  Created by Brian Masse on 11/16/23.
//

import Foundation
import SwiftUI

struct AuthenticationView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var errorMessage: String = ""
    
    let authenticationManager = CactusModel.authenticationManager

//    MARK: Struct Methods
    private func authenticateWithEmail() {
        Task {
            if let error = await authenticationManager.authenticateUserWithEmail(email, password: password) { errorMessage = error } else {
                await CactusModel.shared.postAuthenitcationInitialization()
            }
        }
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            UniversalText("Sign Up for Cactus", size: Constants.UITitleTextSize, font: Constants.titleFont)
                .padding(.bottom)
            
            TextFieldWithPrompt(title: "email", binding: $email)
            TextFieldWithPrompt(title: "password", binding: $password, privacy: true)
                
            
            UniversalButton(label: "done", icon: "checkmark") { authenticateWithEmail() }
            
            Spacer()
            
        }
        .universalBackground(padding: true)
    }
    
}
