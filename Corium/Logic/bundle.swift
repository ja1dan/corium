//
//  bundle.swift
//  Corium
//
//  Created by Jaidan on 12/24/22.
//

import Foundation
import LaunchServicesBridge

struct AppInfo : Codable {
    let name: String
    let identifier: String
    let path: String
    let carPath: URL
    
    init(name: String, identifier: String, path: String) {
        self.name = name
        self.identifier = identifier
        self.path = path
        self.carPath = URL(fileURLWithPath: "\(self.path)/Contents/Resources/Assets.car")
    }
    
    init(applicationProxy: LSApplicationProxy) {
        self.name = applicationProxy.localizedName()
        self.identifier = applicationProxy.applicationIdentifier()
        self.path = applicationProxy.bundleURL().path
        self.carPath = URL(fileURLWithPath: "\(self.path)/Contents/Resources/Assets.car")
    }
}

struct BundleInfo {
    let allApps = LSApplicationWorkspace.default().allInstalledApplications()
    let bundles: [AppInfo] = LSApplicationWorkspace.default().allInstalledApplications().map { proxy in
        AppInfo(applicationProxy: proxy)
    }
    
    func readBundle(path: String) -> AppInfo? {
        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        return bundles.first { $0.path == path }
    }
    
    func readBundle(id: String) -> [AppInfo]? {
        
        // filter and find apps that match the ID
        let filtered = bundles.filter { bundle in
            return bundle.identifier == id
        }
        
        // return the app(s) we found
        return filtered
    }

    func readBundle(name: String) -> [AppInfo]? {
        // filter and find apps that match the ID
        let filtered = bundles.filter { bundle in
            return bundle.name.lowercased() == name.lowercased()
        }
        
        // return the app(s) we found
        return filtered
    }
}
