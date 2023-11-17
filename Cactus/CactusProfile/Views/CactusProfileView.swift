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
    
    var body: some View {
        
        VStack {
            
            Text( profile.firstName )
            Text( profile.lastName )
            
            
            Spacer()
        }
    }
    
}
