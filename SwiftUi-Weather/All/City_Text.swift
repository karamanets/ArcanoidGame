//
//  City_Text.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI

struct CityTextView: View {
    
    var city: String
    
    var body: some View {
        
        Text(city)
            .font(.system(size: 32, weight: .bold, design: .default ))
            .foregroundColor(.black)
            .padding()
        
    }
}
