//
//  ApiService.swift
//  TravelInsurance
//
//  Created by SANJAY  on 12/06/24.
//

import SwiftUI
import CoreLocation
import UIKit



var deviceUDID = getDeviceID()

var currentDateTime = getCurrentDateTime()

var currentTimeZone = getCurrentTimeZone()

var strIPAddress = getIPAddress()

var systemOsVersion = systemVersion()

var devicemodel = deviceModels()

var deviceLatitude: String = ""

var devicelongitude: String = ""

var deviceJailbroken = jailbroken()


func getCurrentTimeZone() -> String {
    let timezone =  TimeZone.current.identifier
    print(timezone)
    return timezone
}

func getCurrentDateTime()->String {
    let date = Date()
    
    let df = DateFormatter()
    
    df.dateFormat = "dd-MMM-yyyy HH:mm"
    
    let dateString = df.string(from: date)
    print(dateString)
    return dateString
}

func getDeviceID() -> String {
    let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    print(udid)
    return udid
}


func getIPAddress() -> String {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            guard let interface = ptr?.pointee else { return "" }
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name: String = String(cString: (interface.ifa_name))
                if name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return address ?? ""
}

func systemVersion() -> String {
    
    let systemVersion = UIDevice.current.systemVersion
    print(systemVersion)
    return systemVersion
}

func deviceModels() -> String {
    
    let deviceModel = UIDevice.current.model
    print(deviceModel)
    return deviceModel
}


class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
        
        // Update global variables here
        deviceLatitude = String(latitude)
        devicelongitude = String(longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location request failed with error: \(error.localizedDescription)")
    }
}


func jailbroken() -> Bool {
    if TARGET_OS_SIMULATOR != 0 {
        return false
    }

    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
        fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
        fileManager.fileExists(atPath: "/bin/bash") ||
        fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
        fileManager.fileExists(atPath: "/etc/apt") ||
        fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
        fileManager.fileExists(atPath: "/private/var/lib/cydia/") ||
        fileManager.fileExists(atPath: "/private/var/stash") ||
        fileManager.fileExists(atPath: "/usr/bin/ssh") ||
        fileManager.fileExists(atPath: "/usr/libexec/sftp-server") {
        return true
    }

    if let path = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision"),
        let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
        let string = String(data: data, encoding: .ascii),
        string.contains("<key>get-task-allow</key><true/>") {
        return true
    }
    return false
}
