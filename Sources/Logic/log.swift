//
//  log.swift
//  Corium
//
//  Created by Jaidan on 12/25/22.
//

import Foundation
import Rainbow

func info(_ items: Any) {
    print("[".lightBlack.bold + "*".green + "]".lightBlack.bold + " \(items)")
}

func debug(_ items: Any, verbose: Bool) {
    if (verbose) { print("[".lightBlack.bold + "#".yellow + "]".lightBlack.bold + " \(items)") }
}

func error(_ items: Any) {
    print("[".lightBlack.bold + "!".red.bold + "]".lightBlack.bold + " \(items)")
}
