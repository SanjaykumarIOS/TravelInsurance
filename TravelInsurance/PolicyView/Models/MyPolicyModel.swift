//
//  MyPolicyModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 12/06/24.
//

import SwiftUI
import Foundation

class MyPolicyResponse: Decodable {
    let rcode: Int
    let rObj: MyPolicyRObj
    let isSuccess: Bool?
    let rmsg: [MyPolicyResponseMessage]
    let reqID: String?
    let trnID: String?
    
    class MyPolicyRObj: Decodable {
        let TotalRecords: Int?
        let MyPolicy: [MyPolicy]?
        
        class MyPolicy: Decodable {
            let QuotationID: String?
            let QuotationNumber: String?
            let OriginCountryID: String?
            let OriginCountryName: String?
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
            let QuotesID: String?
            let PaymentMethodName: String?
            let AddressLine1: String?
            let AddressLine2: String?
            let AddressLine3: String?
            let AddressLine4: String?
            let AddressLine5: String?
            let AttachmentID: String?
            let PolicyNumber: String?
            let CRUSER: String?
            let createdBy: String?
            let CRTS: String?
            let CRTSString: String?
            let TotalRecords: Int?
        }
    }
}




class MyPolicyResponseMessage: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}
