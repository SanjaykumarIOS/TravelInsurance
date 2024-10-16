//
//  DashboardPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 30/05/24.
//

import SwiftUI

struct DashboardPage: View {
    
    @State private var showingLogoutAlert = false
    
    @State private var navigateLoginPage = false
    
    @State private var navigateGetQuotePage = false
    @State private var navigateMyQuotationPage = false
    @State private var navigateMyPolicyPage = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                ScrollView {
                    VStack {
                        
                        VStack(alignment:.center, spacing:5) {
                            Text("Hello, Guest")
                                .font(isFontMedium(size: 19))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black.opacity(0.4))
                            
                            if Extensions.token.isEmpty {
                                HStack {
                                    Text("You haven't LoggedIn?")
                                        .font(isFontMedium(size: 19))
                                        .foregroundColor(.black.opacity(0.4))
                                    
                                    Button(action:{
                                        withAnimation {
                                            navigateLoginPage = true
                                        }
                                    })
                                    {
                                        Text("Login")
                                            .font(isFontMedium(size: 20))
                                            .bold()
                                            .underline()
                                            .foregroundColor(.blue)
                                        
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                        VStack {
                            
                            
                            Text("Choose a service:")
                                .font(isFontMedium(size: 21))
                                .bold()
                                .foregroundColor(appTheme)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing:10) {
                                Image(systemName: "cart")
                                    .resizable()
                                    .frame(width: 40,height: 43)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text("Get Quote")
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 160,height: 100)
                            .background(appTheme)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                withAnimation {
                                    navigateGetQuotePage = true
                                }
                            }
                            
                            Text("Manage my account:")
                                .font(isFontMedium(size: 21))
                                .bold()
                                .foregroundColor(appTheme)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing:15) {
                                VStack(spacing:10) {
                                    Image(systemName: "doc.text")
                                        .resizable()
                                        .frame(width: 35,height: 45)
                                        .foregroundColor(appTheme)
                                        .scaleEffect(x: -1, y: 1)
                                    
                                    Text("My Quotations")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.black.opacity(0.5))
                                }
                                .frame(width: 160,height: 120)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .onTapGesture {
                                    withAnimation {
                                        
                                        if Extensions.token.isEmpty {
                                            navigateLoginPage = true
                                        } else {
                                            navigateMyQuotationPage = true
                                        }
                                    }
                                }
                                
                                VStack(spacing:10) {
                                    Image("script")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 46,height: 46)
                                        .foregroundColor(appTheme)
                                        .overlay(
                                            Image("script")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 49, height: 49)
                                                .foregroundColor(appTheme)
                                                .offset(x: 0, y: 0)
                                        )
                                    
                                    
                                    Text("My Policies")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.black.opacity(0.5))
                                }
                                .frame(width: 120,height: 120)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    withAnimation {
                                        if Extensions.token.isEmpty {
                                            navigateLoginPage = true
                                        } else {
                                            navigateMyPolicyPage = true
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    .padding()
                   
                }
               
                .onAppear {
                    
                }
                
                // ALERT VIEW
                .alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title)
                }
                
                //  TOOL BAR
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        HStack {
                            
                            Text("Dashboard")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                            
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        if Extensions.token.isEmpty {
                            
                            Button(action: {
                           
                                withAnimation {
                                    navigateLoginPage = true
                                }


                            }, label: {
                                
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .frame(width:30, height: 30)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .padding(.bottom,8)
                                
                                
                            })
                            
                          
                        } else {
                            
                            Button(action: {
                                showingLogoutAlert = true
                             
                            }, label: {
                                
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .frame(width:30, height: 30)
                                    .foregroundColor(.white)
                                    .rotationEffect(Angle(degrees: 180))
                                    .padding(5)
                                    .padding(.bottom,8)
                                
                                
                            })
                            .alert(isPresented: $showingLogoutAlert) {
                                Alert(
                                    title: Text("Logout"),
                                    message: Text("Are you sure you want to logout?"),
                                    primaryButton: .default(Text("Yes")) {
                                        
                                        Extensions.token = ""
                                       
                                        showingLogoutAlert = false
                                        
                                    },
                                    secondaryButton: .cancel(Text("No")) {
                                        showingLogoutAlert = false
                                    }
                                    
                                )
                            }
                            

                        }
                         
                    }
                }
                .toolbarBackground(appTheme,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
            }
        }.navigationBarBackButtonHidden()
        
            .overlay {
                navigateLoginPage ? LoginPage(navigateDashboard: $navigateLoginPage) : nil
                
                navigateGetQuotePage ? QuotationFields(navigateDashboard: $navigateGetQuotePage) : nil
                
                navigateMyPolicyPage ? MyPolicyPage() : nil
                
                navigateMyQuotationPage ? MyQuotations(navigateMyQuotationPage: $navigateMyQuotationPage) : nil
            }
    }
}

#Preview {
    DashboardPage()
}
