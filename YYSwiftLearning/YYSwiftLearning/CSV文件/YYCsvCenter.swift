//
//  YYCsvCenter.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/9/14.
//

import Foundation
import CSV

public class NTCSVCenter {
    var streamCSVWriter:CSVWriter?
    let inFolder:String
    var csvName:String?
    public init(inFolder:String, csvName:String? = nil) {
        self.inFolder = inFolder
        self.csvName = csvName
    }
    
    public func folderPath() -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let folderPath = docPath.appending("/\(self.inFolder)")
        try? FileManager.default.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
        return folderPath
    }
    
    func csvPath(name:String) -> String {
        let name = name.replacingOccurrences(of: ".csv", with: "")
        return "\(folderPath())/\(name).csv"
    }
    
    public func saveData(datas:[[String]], headers:[String]? = nil, toFile: String? = nil) {
        if let toFile = toFile {
            csvName = toFile
        }
        guard let csvName = self.csvName else {
            debugPrint("=== NTCSVCenter: write to which csv file? ")
            return
        }
        let path = self.csvPath(name: csvName)
        guard let stream = OutputStream(toFileAtPath:path , append: true) else {
            debugPrint("=== NTCSVCenter: create OutputStream failed")
            return
        }
        do {
            let csv = try CSVWriter(stream: stream)
            if let headers = headers { //header
                try csv.write(row: headers)
            } else {
                try csv.write(field: "")// /n append to new row.
            }
            for data in datas {
                try csv.write(row: data)
            }
            csv.stream.close()
            debugPrint("=== NTCSVCenter: Did save!")
        } catch {
            debugPrint("=== NTCSVCenter: Save error: \(error)")
        }
    }
}

public extension NTCSVCenter {
    
    func startStreamSave(toFile: String, headers:[String]) -> Bool{
        self.csvName = toFile
        guard let csvName = self.csvName else {
            debugPrint("=== NTCSVCenter: write to which csv file? ")
            return false
        }
        let path = self.csvPath(name: csvName)
        guard let stream = OutputStream(toFileAtPath:path , append: true) else {
            debugPrint("=== NTCSVCenter: create stream OutputStream failed")
            return false
        }
        do {
            let csv = try CSVWriter(stream: stream)
            try csv.write(row: headers)//header
            self.streamCSVWriter = csv
            debugPrint("=== NTCSVCenter: Init stream writer successfully!")
            return true
        } catch {
            debugPrint("=== NTCSVCenter: Init stream writer error: \(error)")
            return false
        }
        
    }
    
    func streamSave(datas:[[String]]) -> Bool {
        do {
            guard let csv = self.streamCSVWriter else {
                debugPrint("=== NTCSVCenter: Stream writer had deinit")
                return false
            }
            try csv.write(field: "")//append to new row.
            for data in datas {
                try csv.write(row: data)
            }
            return true
        } catch {
            debugPrint("=== NTCSVCenter: Stream writer save error: \(error)")
            return false
        }
    }
    
    func streamStop() {
        self.streamCSVWriter?.stream.close()
        self.streamCSVWriter = nil
    }
    
}
