//
//  Main app
//

import Foundation

func printUsage() {
    print("Usage: watts [--duration <seconds>] [--quiet]")
    print("Options:")
    print("  --duration <seconds>  Set the total duration for measurement (default: 10)")
    print("  --quiet               Only output the final wattage value")
    print("  --help                Show this help message")
    exit(0)
}

var duration = 5 // default duration in seconds
var quietMode = false

if CommandLine.arguments.contains("--help") {
    printUsage()
}

if let durationIndex = CommandLine.arguments.firstIndex(of: "--duration") {
    if durationIndex + 1 < CommandLine.arguments.count {
        if let durationValue = Int(CommandLine.arguments[durationIndex + 1]) {
            duration = durationValue
        }
    }
}

if CommandLine.arguments.contains("--quiet") {
    quietMode = true
}

autoreleasepool {
    let interval = 0.25 // seconds
    let numberOfReadings = Int(Double(duration) / interval)
    var wattageReadings: [Double] = []
    if !quietMode {
        print("Measuring power consumption over \(duration) seconds...")
    }
    for _ in 0..<numberOfReadings {
        if let wattage = SMC.shared.getValue("PSTR") {
            wattageReadings.append(wattage)
        }
        Thread.sleep(forTimeInterval: interval)
    }

    if !wattageReadings.isEmpty {
        let averageWattage = wattageReadings.reduce(0, +) / Double(wattageReadings.count)
        if quietMode {
            print(String(format: "%.1f", averageWattage))
        } else {
            print(String(format: "Average Watts: %.1f", averageWattage))
        }
    } else {
        if !quietMode {
            print("Could not read wattage.")
        }
    }
    exit(0)
}
