//
//  PaymentReviewPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 11/06/24.
//

import SwiftUI

var quotationInfoArrayDetail:[QuotationInfoResponseModel.QuotationInfoRobj] = []

struct PaymentReviewPage: View {
    
    @State private var showProductPopUp = false
    
    @Binding var productName: String
    @Binding var premiumAmount: String
    @Binding var navigatePaymentReviewPage: Bool
    
    @State private var navigatePaymentProcessingPage = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    VStack {
                        
                        HStack {
                            VStack(spacing:5) {
                                Text("Quotation ID")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArrayDetail.indices, id: \.self) { index in
                                    let quote = quotationInfoArrayDetail[index]
                                    
                                    if let quotationID = quote.GetQuotesInfo {
                                        Text(quotationID.QuotationNumber ?? "")
                                            .font(isFontMedium(size: 18))
                                            .foregroundColor(inkBlueColour)
                                        
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                            
                            VStack(spacing:5) {
                                Text("Destination")
                                    .font(isFontMedium(size: 19))
                                
                                if selectedDestinationListValue.count == 1 {
                                    
                                    Text(Array(selectedDestinationListValue).first!)
                                        .font(isFontMedium(size: 17))
                                        .foregroundColor(inkBlueColour)
                                        .padding(2)
                                    
                                } else {
                                    HStack {
                                        
                                        if let firstCharacter = selectedDestinationListValue.first {
                                            Text(String(firstCharacter))
                                                .font(isFontMedium(size: 17))
                                                .foregroundColor(.black)
                                                .padding(.leading, 10)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(isFontMedium(size: 17))
                                            .padding(.trailing,10)
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 27)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                    .padding(.horizontal,6)
                                    .onTapGesture {
                                        showProductPopUp = true
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                        }
                        
                        HStack {
                            
                            VStack(alignment: .center, spacing:5) {
                                
                                Text("Trip start date")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArrayDetail.indices, id: \.self) { index in
                                    let quote = quotationInfoArrayDetail[index]
                                    
                                    if let quotation = quote.GetQuotesInfo {
                                        Text("\(quotation.FromDateString ?? "")")
                                            .font(isFontMedium(size: 17))
                                            .foregroundColor(inkBlueColour)
                                            .multilineTextAlignment(.center)
                                        
                                
                                    }
                                }
                                
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .padding(.vertical,5)
                            .frame(maxWidth:.infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                            
                            VStack(spacing:5) {
                                Text("Trip end date")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArrayDetail.indices, id: \.self) { index in
                                    let quote = quotationInfoArrayDetail[index]
                                    
                                    if let quotation = quote.GetQuotesInfo {
                                       
                                        Text(quotation.ToDateString ?? "")
                                            .font(isFontMedium(size: 17))
                                            .foregroundColor(inkBlueColour)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .padding(.vertical,5)
                            .frame(maxWidth:.infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding(10)
                   
                    
                    VStack(spacing:15) {
                        Text("Payment Review")
                            .font(isFontMedium(size: 22))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(appTheme)
                        
                       
                        
                        Text("Product Name")
                            .font(isFontMedium(size: 20))
                            .foregroundColor(.black.opacity(0.6))
                        
                        Text(productName)
                            .font(isFontBold(size: 20))
                                                
                        Text("Order Amount")
                            .font(isFontMedium(size: 20))
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.top,13)
                        
                        Text(premiumAmount)
                            .font(isFontBold(size: 20))
                        
                        
                        Button(action:{
                            navigatePaymentProcessingPage = true
                        })
                        {
                            Text("Verify & Pay")
                                .font(isFontMedium(size: 22))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(appTheme)
                                .cornerRadius(10)
                                .padding()
                        }
                          
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    .padding(.top,50)
                   
                   

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
                            
                            Button(action: {
                                withAnimation {
                                    navigatePaymentReviewPage = false
                                }
                            })
                            {
                                Image(systemName: "arrow.backward")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                            
                            Text("Payment Review")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                           
                        }
                    }

                }
                .toolbarBackground(appTheme,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }.navigationBarBackButtonHidden()
            .overlay {
                navigatePaymentProcessingPage ? PaymentProcessingPage() : nil
            }
        
            .overlay {
                if showProductPopUp {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showProductPopUp = false
                            }
                        
                        VStack {
                            Spacer()
                            
                            List {
                                ForEach(selectedDestinationListValue, id: \.self) { value in
                                    Text(value)
                                        .font(isFontMedium(size: 18))
                                        .padding(8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            showProductPopUp = false
                                        }
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                        .frame(height: 400)
                        .onTapGesture {
                            showProductPopUp = false
                        }
                    }
                }
            }
    }
}

#Preview {
    PaymentReviewPage(productName: .constant(""), premiumAmount: .constant(""), navigatePaymentReviewPage: .constant(false))
}
