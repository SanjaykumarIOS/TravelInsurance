//
//  UserInfoModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 31/05/24.
//

import Foundation
import SwiftUI

class ProposalFormResponse: Decodable {
    let rcode: Int
    let rObj: ProposalFormRObj
    let isSuccess: Bool?
    let rmsg: [ProposalFormResponseMessage]
    let reqID: String?
    let trnID: String?
    
    class ProposalFormRObj: Decodable {
        let Quotes: Quotes?
        let Traveller: [Traveller]?
        let Coverages: [Coverage]?
        let Quotations: Quotations?
        let QuotationID: String?
        let DestinationCountry: [DestinationCountry]?
        let declarations: [Declaration]?
    }
    
    class Quotes: Decodable {
        let QuotesID: String?
        let QuotationID: String?
        let QuotationNumber: String?
        let ProductID: String?
        let ProductName: String?
        let ProductSourceID: Int?
        let TotalAmount: Double?
        let CoverageAmount: Int?
        let sTotalAmount: String?
        let CoverageTitle: String?
        let CoverageDescription: String?
        let CRTS: String?
        let CRTSString: String?
        
    }
    
    class Traveller: Decodable {
        let TravellerID: String?
        let QuotationID: String?
        var DOB: String?
        var Age: Int?
        let IsPolicyHolder: Bool
        var FirstName: String?
        var LastName: String?
        var Fullname: String?
        var PhoneNumberCountryCode: Int?
        var PhoneNumber: Int?
        var sPhoneNumber: String?
        var EmailId: String?
        var PolicyHolderPassPortNumber: String?
        var RelationshipTypeID: String?
        var RelationshipName: String?
        var PassportAttachmentID: String?
        let CRTS: String?
        let CRTSString: String?
        var FileUpload: String?
    }
    
    class Coverage: Decodable {
        let CoverageID: String?
        let CoverageName: String?
        let additionalData: String?
    }
    
    class Quotations: Decodable {
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
        var AddressLine1: String?
        var AddressLine2: String?
        var AddressLine3: String?
        let AddressLine4: String?
        let AddressLine5: String?
        let PaymentMethodID: String?
        let PaymentMethodName: String?
        let CRTS: String?
        let CRTSString: String?
        let AttachmentID: String?
        let QuotesID: String?
        var KRAPinTypeID: String?
        var KRAPinNumber: String?
        var Occupation: String?
        var Postaladdress: String?
        var BeneficiaryName: String?
        var BeneficiaryPhoneNumber: String?
    }
    
    class DestinationCountry: Decodable {
        let DestinationCountryID: String?
        let DestinationCountryName: String?
        let DestinationSourceID: Int?
        let DestinationCountryCode: String?
    }
    
    class Declaration: Decodable {
        let declarationid: String?
    }
}

struct ProposalFormResponseMessage: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}

enum AnyValue: Codable {
    case int(Int)
    case string(String)
    case double(Double)

    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        default:
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(intValue)
            return
        }
        if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(stringValue)
            return
        }
        if let doubleValue = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(doubleValue)
            return
        }
        
       
        throw DecodingError.typeMismatch(AnyValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode AnyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        }
    }
}
