//
//  icons.swift
//  Corium
//
//  Created by Jaidan on 12/24/22.
//

import Foundation
import AssetCatalogWrapper
import AppKit
import ArgumentParser

func convertToCGImage(imagePath: String) throws -> CGImage {
    // check that image path exists
    guard FileManager.default.fileExists(atPath: imagePath) else {
        error("Image path \(imagePath) doesn't exist.")
        throw ExitCode.failure
    }
    // convert image to cgimage
    let image = NSImage(contentsOfFile: imagePath)
    var imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
    return image!.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
}

struct Icons {
    func changeRendition(car: CUICatalog, rendition: Rendition, path: URL, image: CGImage) {
        try! car.editItem(rendition, fileURL: path, to: .image(image))
    }
    
    func makeCopy(carPath: URL) {
        // check if backup has already been made
        if (!FileManager.default.fileExists(atPath: "\(carPath.path).bak")) {
            // copy untouched .car to new .car
            try! FileManager.default.copyItem(atPath: carPath.path, toPath: "\(carPath.path).bak")
        }
    }
    
    func restoreBackup(carPath: URL) throws {
        // ensure that backup exists
        guard FileManager.default.fileExists(atPath: "\(carPath.path).bak") else {
            info("App has no Assets.car to restore.")
            throw ExitCode.success
        }
        // remove modified .car
        try! FileManager.default.removeItem(atPath: carPath.path)
        // move backup to normal path
        try! FileManager.default.moveItem(atPath: "\(carPath.path).bak", toPath: carPath.path)
    }
    
    func changeIcon(carPath: URL, imagePath: String, verbose: Bool) throws {
        // get assets.car
        let renditions = try? AssetCatalogWrapper.shared.renditions(forCarArchive: carPath)
        guard (renditions != nil) else {
            error("Failed to wrap \(carPath.path)")
            throw ExitCode.failure
        }
        debug("Got Assets.car at \(carPath.path)", verbose: verbose)
        // convert to cgimage
        let cgImage = try! convertToCGImage(imagePath: imagePath)
        // make copy of assets
        makeCopy(carPath: carPath)
        // get all asset renditions
        for rend in renditions!.1 {
            // get images
            for r in rend.renditions {
                // if image type is 'icon,' change the icon
                if (r.type == RenditionType.icon) {
                    changeRendition(car: renditions!.0, rendition: r, path: carPath, image: cgImage)
                }
            }
        }
    }
}
