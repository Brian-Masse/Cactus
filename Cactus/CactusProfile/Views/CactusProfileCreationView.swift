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
    
    @State var icon: String = ""
    
    
//    MARK: Struct Methods
    private func submit() {
        
        let cactusProfile = CactusProfile(ownerID: CactusModel.ownerID,
                                          userName: userName,
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          phoneNumber: 0,
                                          icon: icon)
        
        RealmManager.addObject(cactusProfile)
        
    }
    
    
//    MARK: Body
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            TextField("first Name", text: $firstName)
            TextField("last Name", text: $lastName)
            TextField("userName", text: $userName)
            
            TextField("email", text: $email)
            
            TextField("icon", text: $icon)
            
            
            Text("submit")
                .onTapGesture {
                    submit()
                }
        }
    }
}
