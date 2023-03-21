//
//  HomeView.swift
//  WeatherApp
//
//  Created by Anwesh on 3/20/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                NavigationLink(destination: WeatherView(weatherData: viewModel.weatherData), isActive: $viewModel.showWeatherView) { EmptyView()}
                if viewModel.errorMessage.count > 0{
                    ErrorView(errorMessage: $viewModel.errorMessage)
                }
                ScrollView(){
                    VStack{
                        Text("Weather App").font(.title).padding(.top, 20)
                        Text("Enter City Name").padding(15)
                        TextField("Enter City", text: $viewModel.cityName).padding(.horizontal, 20) .textFieldStyle(.roundedBorder).foregroundColor(.black)
                        Button {
                            viewModel.getWeatherData()
                        } label: {
                            Text("Go").frame(width: 100, height: 20)
                        }.buttonStyle(.borderedProminent).padding(.all, 20)
                        
                        
                        Group{
                            ForEach(0..<viewModel.impCities.count, id: \.self) { index in
                                let city = viewModel.impCities[index]
                                Button {
                                    viewModel.cityName = city
                                    viewModel.getWeatherData()
                                } label: {
                                    Text(city).frame(width: 100, height: 20)
                                }.buttonStyle(.plain).padding()
                            }
                            
                        }
                        
                    }.padding(.vertical, 29)
                }.padding(15)
            }.background(content: {
                Color.init(uiColor: .black.withAlphaComponent(0.7))
            }).ignoresSafeArea().foregroundColor(.white)
            
        }.navigationSplitViewStyle(NavigationStackViewStyle)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ErrorView: View {
    @Binding var errorMessage: String
    var body: some View {
        if errorMessage.count > 0{
            VStack{
                Spacer()
                HStack(alignment: .center, content: {
                    Text(errorMessage).padding(.all, 20).foregroundColor(.black).font(.system(size: 16, weight: .medium))
                }).frame(maxWidth: .infinity).background {
                    Color.yellow
                }.cornerRadius(15).padding(15)
            }.onAppear {
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    hideError()
                }
            }.onTapGesture {
                hideError()
            }
        }
    }
    
    func hideError(){
        DispatchQueue.main.async {
            withAnimation {
                errorMessage = ""
            }
        }
    }
}
