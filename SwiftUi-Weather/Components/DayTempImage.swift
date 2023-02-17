//
//  DayTempImage.swift
//  SwiftUi-Weather
//
//  Created by Alex Karamanets on 22.11.2022.
//

import SwiftUI


struct WeatherDayView: View {
    
    var dayOfWeak: String
    var imageOfWeak: String
    var temperatureOfWeak: Int
    
    
    var body: some View {
        VStack {
            Text(dayOfWeak)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(.black)
            Image(systemName: imageOfWeak)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperatureOfWeak)º")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
}



struct DayTempView: View {
    var body: some View {
        HStack (alignment: .top, spacing: 29){
            WeatherDayView(dayOfWeak: "TUE", imageOfWeak: "cloud.sun.fill", temperatureOfWeak: 32)
            
            WeatherDayView(dayOfWeak: "WED", imageOfWeak: "cloud.sun.rain.fill", temperatureOfWeak: 22)
            
            WeatherDayView(dayOfWeak: "THU", imageOfWeak: "cloud.bolt.rain.fill", temperatureOfWeak: 22)
            
            WeatherDayView(dayOfWeak: "FRI", imageOfWeak: "cloud.sun.rain.fill", temperatureOfWeak: 28)
            
            WeatherDayView(dayOfWeak: "SAT", imageOfWeak: "sun.max.fill", temperatureOfWeak: 36)
        }
        .padding(.bottom, 40)
        Spacer()
            .frame(height: 40)
    }
}

