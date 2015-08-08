#!/usr/bin/env xcrun swift

import Foundation

// MARK: NSUserDefaults extension
extension NSUserDefaults {
    var arguments: (String, String, String) {
        var assetPath  = stringForKey("path")
        var outputPath = stringForKey("exportPath")
        // enumName is optional and "ImageAsset" is used for enum as default value.
        var enumName   = stringForKey("enumName") ?? "ImageAsset"
        if assetPath == nil {
            fatalError("An asset catalog path must be specified by \"-path\".")
        }
        if outputPath == nil {
            fatalError("An output path must be specified by \"-exportPath\".")
        }
        return (assetPath!, outputPath!, enumName)
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
    
    func build(assets: [String], _ exportPath: String, _ enumName: String) -> Bool {
        let indent = "    " // indent is 4 spaces
        var file: String = ""
        /// file header
        file += "// Generated with Misen by tasanobu - https://github.com/tasanobu/Misen" + "\n"
        file += "\n"
        file += "import UIKit" + "\n"
        file += "\n"
        
        /// UIImage extension
        file += "// MARK: - UIImage extension" + "\n"
        file += "extension UIImage {" + "\n"
        // initializer
        file += indent + "convenience init!(assetName: \(enumName)) {" + "\n"
        file += indent + indent + "self.init(named: assetName.rawValue)" + "\n"
        file += indent + "}" + "\n"
        ///end of UIImage extension
        file += "}" + "\n"
        
        file += "\n"
        
        /// enum
        file += "// MARK: - " + enumName + "\n"
        file += "enum \(enumName): String {" + "\n"
        for str in assets {
            file += indent + "case \(str) = \"\(str)\"" + "\n"
        }
        file += "\n"
        file += indent + "var image: UIImage {" + "\n"
        file += indent + indent + "return UIImage(named: self.rawValue)!" + "\n"
        file += indent + "}" + "\n"
        /// end of enum
        file += "}" + "\n"
        
        let data = file.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return createFileAtPath(exportPath, contents: data, attributes: nil)
    }
}

// MARK: - Main
let (path, exportPath, enumName) = NSUserDefaults.standardUserDefaults().arguments
let fm = NSFileManager.defaultManager()

if let imagesets = fm.imagesets(inAssetsPath: path) where !imagesets.isEmpty {
    let result = fm.build(imagesets, exportPath, enumName)
    let resultStr = result ? "Succeeded" : "Failed"
    println("\(resultStr) to generate enum and UIImage extension file at \(exportPath).")
} else {
    println("[Error] No imageset is found and failed to export a file...")
}

