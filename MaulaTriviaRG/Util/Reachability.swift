//
//  Reachability.swift
//  MaulaTriviaRG
//
//  Created by Muhammad Ihsan Maula on 11/24/17.
//  Copyright © 2017 Muhammad Ihsan Maula. All rights reserved.
//

import Foundation
import SystemConfiguration

open class Reachability: NSObject {
    static let sharedInstance = Reachability()
    /**
     * Check if internet connection is available
     */
    open class func isConnectedToNetwork() -> Bool {
        let ipAddress = getIpAddress()
        let ipType = validateIpAddress(ipAddress)
        
        if ipType == "ipv6" {
            return ipv6ReachAbility()
        }else if ipType == "ipv4"{
            return ipv4ReachAbility()
        }
        
        return false
    }
    
    open class func validateIpAddress(_ ipToValidate: String) -> String {
        
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        
        if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer.
            return "ipv6"
        }
        else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer.
            return "ipv4"
        }
        
        return "ipv4";
    }
    
    open class func ipv6ReachAbility()->Bool{
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return isReachable && !needsConnection
    }
    
    open class func ipv4ReachAbility()->Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return isReachable && !needsConnection
    }
    
    // get ip address
    open static func getIpAddress() -> String {
        var address : String = ""
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "" }
        guard let firstAddr = ifaddr else { return "" }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
}
