//
//  MyQuotationsModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 10/06/24.
//

import SwiftUI
import Foundation

class MyQuotationResponse: Decodable {
    let rcode: Int
    let rObj: MyQuotationRObj
    let isSuccess: Bool?
    let rmsg: [MyQuotationResponseMessage]
    let reqID: String?
    let trnID: String?
    
    class MyQuotationRObj: Decodable {
        let TotalRecords: Int?
        let MyQuotation: [MyQuotation]?
        
        class MyQuotation: Decodable {
            let QuotationID: String?
            let QuotationNumber: String?
            let OriginCountryID: String?
            let OriginCountryName: String?
            let OriginCountrySourceID: Int?
            let DestinationCountryName: String?
            let TravelPurposeID: String?
            let TravelPurposeName: String?
            let FromDate: String?
            let FromDateString: String?
            let ToDate: String?
            let ToDateString: String?
            let NoofDays: Int?
            let NoofTravellers: Int?
            let QuotationStatusName: String?
            let QuotationSourceName: String?
            let ExpiredString: String?
            let CRTS: String?
            let CRTSString: String?
            let TotalRecords: Int?
        }
    }
}




class MyQuotationResponseMessage: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}
