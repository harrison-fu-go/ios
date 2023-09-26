//
//  YYFilePathVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/9/18.
//

import Foundation
import UIKit

class YYFilePathVC: UIViewController, UIDocumentPickerDelegate {
    let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
    var document: OTADocument?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        debugPrint("===== documentPicker \(urls)")
        if let path = urls.first?.absoluteString as? String {
            document = OTADocument(fileURL: urls[0], filePath: path)
            document?.open {[weak self] success in
                guard let self = self, let path = self.document?.copyPath  else { return }
                print("======= open suncess: \(success) === \(path)")
            }
        }
    }

}

class OTADocument: UIDocument {
    
    let filePathStr: String
    var copyPath: String?
    
    public init(fileURL url: URL, filePath:String) {
        self.filePathStr = filePath
        super.init(fileURL: url)
    }
    
    func cachePath() -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let filePath = docPath.appending("/OTA/")
        try? FileManager.default.createDirectory(at: URL(fileURLWithPath: filePath), withIntermediateDirectories: true, attributes: nil)
        return filePath
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let fileData = contents as? NSData else {
            return
        }
        let fileName = "\(String(filePathStr.split(separator: "/").last ?? ""))"
        let path = "\(self.cachePath())\(fileName)"
        let success = fileData.write(to: URL(fileURLWithPath: path), atomically: true)
        self.copyPath = path
        print("======= save suncess: \(success)")
    }
}
