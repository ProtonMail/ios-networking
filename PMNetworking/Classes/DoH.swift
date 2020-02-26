//
//  DoH.swift
//  Created by ProtonMail on 2/24/20.
//
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonMail.
//
//  ProtonMail is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonMail is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.


import Foundation


struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

struct DNSCache {
    let primary : Bool
    let dns : DNS
    let lastTimeout : Date
    let retry : Int
}

public protocol DoHConfig {
    var apiHost : String { get }
    var defaultHost : String { get }
}

protocol DoHInterface {
    func getHostUrl() -> String
}

open class DoH : DoHInterface {
    
    private var caches : [String: DNS] = [:]
    private var providers : [DoHProviderPublic] = []
    
    public func getHostUrl() -> String {
        let config = self as! DoHConfig
        
        if let found = self.cache(get: config.apiHost) {
            print("Found from cache")
            let newurl = URL(string: config.defaultHost)!
            let host = newurl.host
            let hostUrl = newurl.absoluteString.replacingOccurrences(of: host!, with: found.url)
            return hostUrl
        }
        
        //doing google for now. will add others
        if let dns = Google().fetch(sync: config.apiHost) {
            self.cache(set: config.apiHost, dns: dns)
            let url = dns.url
            let newurl = URL(string: config.defaultHost)!
            let host = newurl.host
            let hostUrl = newurl.absoluteString.replacingOccurrences(of: host!, with: url)
            return hostUrl
        }
        return config.defaultHost
    }
    
    public init() throws {
        guard let config = self as? DoHConfig else {
            throw RuntimeError("Class didn't extend DoHConfig")
        }
        print("")
    }
    
    func cache(get host: String) -> DNS? {
        
        guard let found = self.caches[host] else {
            return nil
        }
//        if (found.ttl <= Date().timeIntervalSince1970){
//            //remove cache
//            return nil
//        }
        return found
    }
    func cache(set host: String, dns : DNS) {
        self.caches[host] = dns
    }
    
    func cache(clear host: String) {
        
    }
    
    func clearAll() {
        
    }
}

protocol test {
    
}

//extension test {
//    var cache = [String]()
//}

//
//fileprivate init() {}
//   fileprivate var cache = Dictionary<String,HTTPDNSResult>()
//   fileprivate var DNS = HTTPDNSFactory().getDNSPod()
//
//   /// HTTPDNS sharedInstance
//   public static let sharedInstance = HTTPDNS()
//
//   /**
//    Switch HTTPDNS provider
//
//    - parameter provider: DNSPod or AliYun
//    - parameter key:      provider key
//    */
//   open func switchProvider (_ provider:Provider, key:String!) {
//       self.cleanCache()
//       switch provider {
//       case .dnsPod:
//           DNS = HTTPDNSFactory().getDNSPod()
//           break
//       case .aliYun:
//           DNS = HTTPDNSFactory().getAliYun(key)
//           break
//       case .google:
//           DNS = HTTPDNSFactory().getGoogle()
//           break
//       }
//   }
//
//   /**
//    Get DNS record async
//
//    - parameter domain:   domain name
//    - parameter callback: callback block with DNS record
//    */
//   open func getRecord(_ domain: String, callback: @escaping (_ result:HTTPDNSResult?) -> Void) {
//       let res = getCacheResult(domain)
//       if (res != nil) {
//           return callback(res)
//       }
//       DNS.requsetRecord(domain, callback: { (res) -> Void in
//           if let res = res {
//               callback(self.setCache(domain, record: res))
//           } else {
//               return callback(nil)
//           }
//       })
//   }
//
//   /**
//    Get DNS record sync (if not exist in cache return nil)
//
//    - parameter domain: domain name
//
//    - returns: DSN record
//    */
//   open func getRecordSync(_ domain: String) -> HTTPDNSResult! {
//       guard let res = getCacheResult(domain) else {
//           guard let res = self.DNS.requsetRecordSync(domain) else {
//               return nil
//           }
//           return self.setCache(domain, record: res)
//       }
//       return res
//   }
//
//   /**
//    Clean all DNS record cahce
//    */
//   open func cleanCache() {
//       self.cache.removeAll()
//   }
//
//   func setCache(_ domain: String, record: DNSRecord?) -> HTTPDNSResult? {
//       guard let _record = record else { return nil }
//       let timeout = Date().timeIntervalSince1970 + Double(_record.ttl) * 1000
//       var res = HTTPDNSResult.init(ip: _record.ip, ips: _record.ips, timeout: timeout, cached: true)
//       self.cache.updateValue(res, forKey:domain)
//       res.cached = false
//       return res
//   }
//
//   func getCacheResult(_ domain: String) -> HTTPDNSResult! {
//       guard let res = self.cache[domain] else {
//           return nil
//       }
//       if (res.timeout <= Date().timeIntervalSince1970){
//           self.cache.removeValue(forKey: domain)
//           return nil
//       }
//       return res
//   }
