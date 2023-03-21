//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Anwesh on 3/21/23.
//

import SwiftUI

struct WeatherView: View {
    let weatherViewDataModel: WeatherViewDataModel
    
    init(weatherData: WeatherModel?) {
        let dataList = weatherData?.list?.map({ item in
            WeatherData(date: item.dtTxt.toDate() ?? Date(), temp: String(item.main.temp), description: item.weather.first?.description ?? "")
        })
        self.weatherViewDataModel = WeatherViewDataModel(city: weatherData?.city?.name ?? "No City Name", data: dataList ?? [])
    }
    
    var body: some View {
        VStack {
            ScrollView{
                VStack(spacing: 10, content:{
                    Text("City").font(.callout)
                    Text(weatherViewDataModel.city).font(.title)
                }).padding(.vertical, 15)
                HStack{
                    Text("Weather info").font(.system(size: 16)).padding(.horizontal, 15)
                    Spacer()
                }
                ForEach(0..<weatherViewDataModel.data.count, id: \.self) { index in
                    let data = weatherViewDataModel.data[index]
                    VStack {
                        HStack(spacing: 10, content: {
                            VStack(spacing: 5, content: {
                                Text(data.date.getDayOfWeekString())
                                Text(data.date.isDateInToday() ? "Today" : data.date.getDate()).lineLimit(1).minimumScaleFactor(0.5).font(.system(size: 22, weight: .semibold))
                            }).frame(maxWidth: 100).foregroundColor(.black)
                            Spacer(minLength: 5)
                            VStack{
                                Text(data.date.getTimeinAmPm()).font(.system(size: 18, weight: .semibold))
                            }.foregroundColor(.black)
                            
                            Spacer(minLength: 10)
                            VStack{
                                Text("\(data.temp)℃").font(.system(size: 45)).lineLimit(1).minimumScaleFactor(0.5)
                            }.foregroundColor(.black)
                            Spacer()
                        })
                        Spacer()
                        HStack{
                            Text(data.description).foregroundColor(Color(uiColor: .darkGray))
                        }
                    }.padding().background(
                        RoundedRectangle(cornerRadius: 15)
                    ).foregroundColor(Color.init(uiColor: .white.withAlphaComponent(0.9))).padding(.horizontal, 15).padding(.vertical, 5)
                    
                }
            }.foregroundColor(.white)
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        ).background(
            Color.init(.black.withAlphaComponent(0.9))
        )
        
        
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        let data1 = WeatherData(date: Date(), temp: "30", description: "")
        let data2 = WeatherData(date: Date(), temp: "40", description: "")
        let data3 = WeatherData(date: Date(), temp: "50", description: "")
        let data4 = WeatherData(date: Date(), temp: "60", description: "")
        
//        let weatherViewDataModel: WeatherViewDataModel = .init(city: "Hyderabad", data: [data1, data2, data3, data4])
        
        //        WeatherView(weatherViewDataModel: )
    }
}


