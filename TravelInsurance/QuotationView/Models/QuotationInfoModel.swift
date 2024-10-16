//
//  QuotationInfoModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 30/05/24.
//

import Foundation

// Main Response Model
class QuotationInfoResponseModel: Decodable {
    let rcode: Int
    let rObj: QuotationInfoRobj
    let isSuccess: Bool?
    let rmsg: [QuotationInfoResponseMessage]
    let reqID: String?
    let trnID: String?
    
    // Response Object Model
    class QuotationInfoRobj: Decodable {
        let GetQuotes: [Quote]?
        let QuotationID: String?
        let DestinationCountry: [DestinationCountry]?
        let Traveller: [Traveller]?
        let GetQuotesInfo: GetQuotesInfo?
        let premiumBreaks: [PremiumBreaks]?
       
    }
    
    class PremiumBreaks: Decodable {
        let PremiumText: String?
        let PremiumValue: Double?
        let QuotesID: String?
        let QuotationID: String?
        let isNegative: Bool
        let Sequence: Int?
    }
    
    // Quote Model
    class Quote: Decodable {
        let QuotesID: String?
        let QuotationID: String?
        let QuotationNumber: String?
        let ProductID: String?
        let ProductName: String?
        let ProductSourceID: Int?
//        let TotalAmount: Int?
        let CoverageAmount: Int?
        let sTotalAmount: String?
        let CoverageTitle: String?
        let CoverageDescription: String?
        let CRTS: String?
        let CRTSString: String?
    }
    
    // Destination Country Model
    class DestinationCountry: Decodable {
        let DestinationCountryID: String?
        let DestinationCountryName: String?
        let DestinationSourceID: Int?
        let DestinationCountryCode: String?
    }
    
    // Traveller Model
    class Traveller: Decodable {
        let TravellerID: String?
        let QuotationID: String?
        let DOB: String?
        let Age: Int?
        let IsPolicyHolder: Bool?
        let FirstName: String?
        let LastName: String?
        let Fullname: String?
        let PhoneNumberCountryCode: Int?
        let PhoneNumber: Int?
        let sPhoneNumber: String?
        let EmailId: String?
        let PolicyHolderPassPortNumber: String?
        let RelationshipTypeID: String?
        let RelationshipName: String?
        let PassportAttachmentID: String?
        let CRTS: String?
        let CRTSString: String?
    }

    // Get Quotes Information Model
    class GetQuotesInfo: Decodable {
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
        let QuotationStatusID: String?
        let QuotationStatusName: String?
        let QuotationSourceID: String?
        let QuotationSourceName: String?
        let QuotationExpiredDate: String?
        let AddressLine1: String?
        let AddressLine2: String?
        let AddressLine3: String?
        let AddressLine4: String?
        let AddressLine5: String?
        let PaymentMethodID: String?
        let PaymentMethodName: String?
        let CRTS: String?
        let CRTSString: String?
        let AttachmentID: String?
        let QuotesID: String?
        
    }
}


// Response Message Model
class QuotationInfoResponseMessage: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}
