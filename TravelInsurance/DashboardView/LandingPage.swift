//
//  LandingPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 24/05/24.
//

import SwiftUI


struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
    let caption: String
    let text: String
}

struct LandingPage: View {
    let items: [CarouselItem] = [
        CarouselItem(imageName: "Car", caption: "Secure Your Travel",text: "Experience Joy on Every Journey"),
        CarouselItem(imageName: "Redcar", caption: "Swift Protection",text: "Your Journey, Our Protection"),
        CarouselItem(imageName: "MenandWomen", caption: "24/7 Support, Always Covered",text: "Reliable Support for Every Travel"),
        CarouselItem(imageName: "kenindia-logo", caption: "KENINDIA",text: "Hassle-Free Claims in Travel")
       
    ]

    @State private var selectedTab = 0
    
    @State private var navigateDashboardPage = false

    var body: some View {
        NavigationStack {
           
            VStack {
                
                Button(action: {
                    withAnimation {
                        navigateDashboardPage = true
                        Extensions.showLandingPage = false
                    }
                })
                {
                    Text("Skip >")
                        .bold()
                        .font(isFontMedium(size: 20))
                        .foregroundColor(inkBlueColour)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .padding(.top)
                }
                
//                NavigationLink("",destination: LoginPage(),isActive: $navigateLoginPage)
                
                TabView(selection: $selectedTab) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack(alignment: .center) {
                           
                            if index == 3 {
                                Image(items[index].imageName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 340,height: 350)
                                    .foregroundColor(appTheme)
                                    .padding(.bottom)
                                    .padding(.top,10)
                            } else {
                                Image(items[index].imageName)
//                                    .resizable()
//                                    .scaledToFit()
                                    .frame(width: 340,height: 350)
                                    .padding(.bottom)
                                    .padding(.top,10)
                            }
                            
//                            Divider()
//                                .frame(width: 330,height: 1)
//                                .background(Color.black)
                            
                            Text(items[index].caption)
                                .bold()
                                .font(isFontBlack(size: 25))
                                .foregroundColor(.black.opacity(0.7))
                            
                            Text(items[index].text)
                                .bold()
                                .font(isFontMedium(size: 18))
                                .foregroundColor(.black.opacity(0.7))
                                .padding(.top,30)
                             
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                
                HStack {
//                    Button(action: {
//                        withAnimation {
//                            if selectedTab > 0 {
//                                selectedTab -= 1
//                            }
//                        }
//                    }) {
//                        Text("<< Previous")
//                            .font(isFontMedium(size: 18))
//                            .foregroundColor(selectedTab != 0 ? appTheme : .clear)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                        
//                    }
//                    .disabled(selectedTab == 0)
//                    
                    ImageSliderIndicator(numberOfPages: items.count, selectedTab: $selectedTab)
                        .padding()
                        .padding(.leading)
                    
                    
                    Button(action: {
                        withAnimation {
                            if selectedTab < items.count - 1 {
                                selectedTab += 1
                            } else {
                                withAnimation {
                                    navigateDashboardPage = true
                                    Extensions.showLandingPage = false
                                }
                            }
                        }
                    }) {
                        Text("Next >>")
                            .font(isFontMedium(size: 18))
                            .foregroundColor(appTheme)
                            .padding()
                            .background(Color.white.opacity(0.4))
                            .cornerRadius(17)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                        
                    }
                    
                }
                .padding(10)
                
            }
            .background( purpleColor
                .ignoresSafeArea())
        }.navigationBarBackButtonHidden()
        
        .overlay(
            navigateDashboardPage ? DashboardPage() : nil
        )
        
       
    }
}


struct ImageSliderIndicator: View {
    let numberOfPages: Int
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { index in
                Circle()
                    .frame(width:15, height:15)
                    .foregroundColor(index == selectedTab ? appTheme : .gray.opacity(0.6))
            }
        }
    }
}






#Preview {
    LandingPage()
}
