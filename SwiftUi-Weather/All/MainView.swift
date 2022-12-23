//
//  MainView.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI

struct MainView: View {
    
    var image      : String
    var temperature: Int
    
    var body: some View {
        
        VStack  {
            Image(systemName: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)º")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.black)
                .padding(.bottom, 40)
            
            
            Spacer()
                .frame(height: 20)
        }
    }
}
