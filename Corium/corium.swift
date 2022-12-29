//
//  corium.swift
//  Corium
//
//  Created by Jaidan on 12/28/22.
//

import ArgumentParser
import Foundation
import QuartzCore

@main
struct Corium: ParsableCommand {
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "A full-fledged theme engine, written in Swift.",

        // Commands can define a version for automatic '--version' support.
        version: "0.0.1",

        // Pass an array to `subcommands` to set up a nested tree of subcommands.
        // With language support for type-level introspection, this could be
        // provided by automatically finding nested `ParsableCommand` types.
        subcommands: [Theme.self, Reset.self]
    )
}

struct ThemeOptions: ParsableArguments {
    @Argument(help: "Path of the app to theme.")
    var app: String = ""
    
    @Argument(help: "Path of the image to use.")
    var imagePath: String = ""
}

struct ResetOptions: ParsableArguments {
    @Argument(help: "Path of the app.")
    var app: String = ""
}

extension Corium {
    struct Theme: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Change the icon of an app.")

        @OptionGroup var options: ThemeOptions

        func run() throws {
            // check that correct options were passed
            guard (options.app != "") else {
                error("No app path was specified")
                throw ExitCode.failure
            }
            guard (options.imagePath != "") else {
                error("No image path was specified")
                throw ExitCode.failure
            }
            // check if root
            if (getuid() != 0) {
                error("Rerun as root!")
                throw ExitCode.failure
            }
            // get bundle info
            let bInfo = BundleInfo()
            let app = bInfo.readBundle(path: options.app)
            // make sure bundle was found
            guard (app != nil) else {
                error("Could not find app with path \(options.app).")
                throw ExitCode.failure
            }
            // change icon
            try Icons().changeIcon(carPath: app!.carPath, imagePath: options.imagePath)
            // run uicache
            info("Refreshing icon cache...")
            uicache()
        }
    }
    
    struct Reset: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Reset the icon of an app.")

        @OptionGroup var options: ThemeOptions

        func run() throws {
            // check that correct options were passed
            guard (options.app != "") else {
                error("No app path was specified")
                throw ExitCode.failure
            }
            // check if root
            if (getuid() != 0) {
                error("Rerun as root!")
                throw ExitCode.failure
            }
            // get bundle info
            let bInfo = BundleInfo()
            let app = bInfo.readBundle(path: options.app)
            // make sure bundle was found
            guard (app != nil) else {
                error("Could not find app with path \(options.app).")
                throw ExitCode.failure
            }
            // change icon
            try Icons().restoreBackup(carPath: app!.carPath)
            // run uicache
            info("Refreshing icon cache...")
            uicache()
        }
    }
}

