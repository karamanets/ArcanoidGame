//
//  Buttom.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI

struct ButtonMein: View {
    
    var body: some View {
        
        Button {
            // same code
        } label: {
            Text("Change day time")
                .frame(width: 280, height: 50)
                .background(Color.white)
                .font(.system(size: 25, weight: .medium, design: .default))
                .foregroundColor(.black )
                .cornerRadius(11)
        }
        Spacer()
            .frame(height: 40)
    }
}

