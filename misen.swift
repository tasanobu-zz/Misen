#!/usr/bin/env xcrun swift

import Foundation

// MARK: NSUserDefaults extension
extension NSUserDefaults {
    var arguments: (String, String) {
        var assetPath  = self.stringForKey("path")
        var outputPath = self.stringForKey("exportPath")
        if assetPath == nil {
            fatalError("An asset catalog path must be specified by \"-path\".")
        }
        if outputPath == nil {
            fatalError("An output path must be specified by \"-exportPath\".")
        }
        return (assetPath!, outputPath!)
    }
}
// MARK: NSDate extension
extension NSDate {
    var formatString: String {
        var df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.stringFromDate(self)
    }
}
// MARK: NSFileManager
extension NSFileManager {
    func imagesets(inAssetsPath path: String) -> [String]? {
        var error: NSError?
        var imagesets = self.subpathsOfDirectoryAtPath(path, error: &error)?
            .filter { $0.hasSuffix("imageset") }
            .map { $0.lastPathComponent.componentsSeparatedByString(".")[0] }
        if let err = error {
            println("[Warning] An error occurred in \(__FUNCTION__).\n\t error: \(err)")
        }
        return imagesets
    }
    
    func writeimagesets(imagesets: [String], atPath path: String) -> Bool {
        let indent = "    " // indent is 4 spaces
        var file: String = ""
        // file header
        file += "//\n"
        file += "// \(path.lastPathComponent)\n"
        file += "//\n"
        file += "// Created by Misen(https://github.com/tasanobu/Misen) on \(NSDate().formatString)\n"
        file += "//\n"
        file += "//\n"
        // file body
        file += "\n"
        file += "import UIKit\n"
        file += "\n"
        file += "extension UIImage {\n"
        // initializer
        file += "\n"
        file += "\(indent)convenience init!(assetIdentifier: AssetsIdentifier) {\n"
        file += "\(indent)\(indent)self.init(named: assetIdentifier.rawValue)\n"
        file += "\(indent)}\n"
        // enum
        file += "\n"
        file += "\(indent)enum AssetsIdentifier: String {\n"
        for str in imagesets {
            file += "\(indent)\(indent)case \(str) = \"\(str)\"\n"
        }
        file += "\(indent)}\n"
        // end of file
        file += "}\n"
        
        let data = file.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return self.createFileAtPath(path, contents: data, attributes: nil)
    }
}

// MARK: - Main
let (path, exportPath) = NSUserDefaults.standardUserDefaults().arguments
if let imagesets = NSFileManager.defaultManager().imagesets(inAssetsPath: path) where !imagesets.isEmpty {
    let result = NSFileManager.defaultManager().writeimagesets(imagesets, atPath: exportPath)
    println("Succeeded to create an UIImage extension file at \(exportPath).")
} else {
    println("[Error] No imageset is found and failed to export a file...")
}

