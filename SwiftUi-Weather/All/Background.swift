//
//  Background.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI

struct BackgroundGradient: View {
    
    var colorTop   : Color
    var colorBottom: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [colorTop, colorBottom]),
                       startPoint: .bottomLeading,
                       endPoint: .topTrailing)
        .ignoresSafeArea()
    }
}
