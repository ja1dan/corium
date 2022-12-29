//
//  plist.swift
//  Corium
//
//  Created by Jaidan on 12/24/22.
//

import Foundation

struct AppInfo : Codable {
    let BundleIconFile, BundleName, BundleIdentifier, BundlePath: String
}

func readBundle(path: String) -> AppInfo {
    // get bundle info
    let bundle = Bundle(path: path)!
    let infoDict = bundle.infoDictionary!
    let bundleIconFile = infoDict["CFBundleIconFile"] as! String
    let bundleName = infoDict["CFBundleName"] as! String
    let bundleID = infoDict["CFBundleIdentifier"] as! String
    
    // assign to object
    let appInfo = AppInfo.init(BundleIconFile: bundleIconFile, BundleName: bundleName, BundleIdentifier: bundleID, BundlePath: path)
    
    // ret
    return appInfo
}
