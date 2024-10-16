//
//  Extenstionss.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI

class Extensions: NSObject {
    
    class var userUid : String
    {
        get {
            if let userUid = UserDefaults.standard.value(forKey: "userUid") as? String {
                return userUid
            }
            return ""
            
        }set{
            UserDefaults.standard.set(newValue, forKey: "userUid")
        }
    }
    
    class var token : String
    {
        get {
            if let token = UserDefaults.standard.value(forKey: "token") as? String {
                return token
            }
            return ""
            
        }set{
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    class var showLandingPage : Bool
    {
        get {
            if let showLandingPage = UserDefaults.standard.value(forKey: "showLandingPage") as? Bool {
                return showLandingPage
            }
            return true
            
        } set {
            UserDefaults.standard.set(newValue, forKey: "showLandingPage")
        }
    }
    
    class var navigateProposalForm : Bool
    {
        get {
            if let navigateProposalForm = UserDefaults.standard.value(forKey: "navigateProposalForm") as? Bool {
                return navigateProposalForm
            }
            return false
            
        } set {
            UserDefaults.standard.set(newValue, forKey: "navigateProposalForm")
        }
    }
    
    class func getValidationDict()->NSDictionary
    {
        let errorDict = ["ERR100": "Something went wrong",
                         "ERR001": "Connection Error: Unable to establish a connection. Please check your internet connection and try again.",
                         "ERR002": "Processing Request: Please hold on for a moment while I process your request.",
                         "ERR003": "Model Downloading: Please wait while the machine learning model is being downloaded. This will just take a few seconds. Thank you for your patience!",
                         "VAL001": "Please select a start date before proceeding.",
                         "VAL002": "Ensure your end date is on or after the start date.",
                         "VAL003": "A maximum of 50 travelers can be insured per policy.",
                         "VAL004": "Please specify the number of travelers.",
                         "VAL005": "Select a trip start date to continue.",
                         "VAL006": "Select a trip end date to continue.",
                         "VAL007": "Enter the date of birth for traveler %d to continue.",
                         "VAL008": "At least one traveler must be over 3 years old.",
                         "VAL009": "Select at least one travel destination to proceed.",
                         "VAL010": "Please select a country code to continue.",
                         "VAL011": "Enter your phone number to continue.",
                         "VAL012": "Enter your email address to continue.",
                         "VAL013": "The email address entered is invalid. Please check and try again.",
                         "VAL014": "Enter your policy ID to continue.",
                         "VAL015": "Enter your date of birth to continue.",
                         "VAL016": "Select a travel purpose to continue.",
                         "VAL017": "Select a relationship for the traveler to continue.",
                         "VAL018": "Select at least one proposer to continue.",
                         "VAL019": "Enter your house number to continue.",
                         "VAL020": "Enter your road name to continue.",
                         "VAL021": "Enter your pin code to continue.",
                         "VAL022": "Please select only two products for comparison.",
                         "VAL023": "Enter the first name for Traveler %d to continue.",
                         "VAL024": "Enter the last name for Traveler %d to continue.",
                         "VAL025": "Enter the name as per the passport for Traveler %d to continue.",
                         "VAL026": "Enter the email address for Traveler %d to continue.",
                         "VAL027": "Enter the date of birth for Traveler %d to continue.",
                         "VAL028": "Enter the age for Traveler %d to continue.",
                         "VAL029": "Select the country code for Traveler %d to continue.",
                         "VAL030": "Enter the mobile number for Traveler %d to continue.",
                         "VAL031": "Enter the passport number for Traveler %d to continue.",
                         "VAL032": "Select the relationship with the proposer for Traveler %d to continue.",
                         "VAL033": "Enter a valid email address for Traveler %d to continue.",
                         "VAL034": "Please select a date to proceed.",
                         "VAL036": "Upload the passport for Traveler %d to continue.",
                         "VAL037": "Kindly select at least one KRA Pin Type to proceed.",
                         "VAL038": "Please provide the KRA pin number to proceed.",
                         "VAL039": "Please enter the Beneficiary Name to proceed.",
                         "VAL040": "Please enter the Insured's Occupation to proceed.",
                         "VAL041": "Please enter the Beneficiary's Mobile Number to proceed.",
                         "VAL042": "Please enter a valid KRA pin number to proceed.",
                         "VAL043": "Please select the declaration to continue.",
                         "VAL044": "Please select the consent to continue.",
                         "VAL045": "We are sorry for the inconvenience! Unfortunately, due to age restrictions, we are unable to offer a travel policy to individuals over 80 years old. We understand this might be disappointing, and we’re here to help with any questions or concerns you may have. Feel free to reach out to us at travel@kenindia.com or visit our office for further assistance. Thank you for your understanding!",
                         "VAL504": "It looks like there's already a travel insurance policy for the provided passport number covering the same dates. Please review your details or contact support for assistance.",
                         "API001": "We're currently experiencing some technical difficulties with our servers. Please hang tight and try again shortly. We appreciate your patience and understanding!"
        ]
        return errorDict as NSDictionary
    }
    
}



extension Text {
    func halfTextColorChange(fullText: String, changeText: String) -> Text {
        guard let range = fullText.range(of: changeText) else {
            return self
        }
        
        let beforeChange = String(fullText[..<range.lowerBound])
        let afterChange = String(fullText[range.upperBound...])
        
        return Text(beforeChange)
            .foregroundColor(.black) +
            Text(changeText)
            .foregroundColor(.red) +
            Text(afterChange)
            .foregroundColor(.black)
    }
}







