//
//  ContentView.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight = true
    
    var body: some View {
        
        ZStack {
            
            BackgroundGradient(colorTop: isNight ? Color("MyColor2Night") :       Color("MyColor2Day"),
                               colorBottom: isNight ? Color("MyColor1Night") : Color("MyColor1Day") )
            
            VStack  {
                
                CityTextView(city: "Los Angeles LA")
                   
                MainView(image: "cloud.sun.fill", temperature: 33)
  
                DayTempView()
                
                ButtonMein()
                
                VStack {
                    
                    Button {
                        isNight.toggle()
                    } label: {
                        Text("Change Mode")
                            .frame(width: 110, height: 40)
                            .background(Color.white)
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
