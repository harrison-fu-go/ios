//
//  Log.swift
//  YYAppIntelligence
//
//  Created by Harrison Fu on 2024/10/23.
//

import Foundation
import CocoaLumberjack

#if DEBUG
let NTLAsyncLogMessage = false
#else
let NTLAsyncLogMessage = true
#endif

public enum NLogLevel {
    case debug
    case release
}

//MARK: ---- Config.
public class XsLogConfig {
    public static let nativeTag = "source:xs-native"
    public static let flutterTag = "source:xs-flutter"
    public static let separateMark = "||"
    public static let maxFileCount:UInt = 6
    public static let shared = XsLogConfig()
    public var level = NLogLevel.debug
    public var openLogFileWriting = true //The switch of the log.
    public var isAsync = NTLAsyncLogMessage
    private var targetFile:String?
    public static var isSetup = false
    static func dateFormatter(fm:String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = fm
        return dateFormatter
    }
    
    static var logPath:URL {
        var path = FileManager.default.urls(for: .cachesDirectory,
                                            in: .userDomainMask)[0]
        path = path.appendingPathComponent("XS_LOG")
        let filehandle = FileManager.default
        try? filehandle.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        return path
    }
    
    public static func setupDDLog() {
        DDOSLogger.sharedInstance.logFormatter = ConsoleLogFormat()
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        let fileManager = NTDDLogFileManagerDefault(logsDirectory: XsLogConfig.logPath.path)
        let fileLogger: DDFileLogger = DDFileLogger(logFileManager: fileManager) // File Logger
        fileLogger.rollingFrequency = 0//（60 * 60 * 24// 1 days）no use.
        fileLogger.logFileManager.maximumNumberOfLogFiles = maxFileCount
        fileLogger.maximumFileSize = 8 * 1024 * 1024 // 8M bytes for each file
        fileLogger.logFormatter = DDLogFormat()
        fileLogger.doNotReuseLogFiles = self.doNotReuseLogFiles()
        //fileLogger.logFileManager.logsDirectory
        DDLog.add(fileLogger)
        self.isSetup = true
    }
    
    func createNewFileName() -> String {
        let formatter = XsLogConfig.dateFormatter(fm: "YYYY-MM-dd")
        let dataStr = formatter.string(from: Date())
        var index = 0
        let subpaths = try? FileManager.default.subpathsOfDirectory(atPath: XsLogConfig.logPath.path)
        if let subpaths = subpaths, subpaths.count > 0 {
            let dayFiles = subpaths.filter { $0.contains(dataStr) }.sorted(by: { name1 , name2 in
                return name1.localizedStandardCompare(name2) == ComparisonResult.orderedAscending
            })
            if let last = dayFiles.last, let indexStr = last.split(separator: "-").last  {
                let idx = (indexStr as NSString).deletingPathExtension
                index = (Int(idx) ?? -1) + 1
            }
        }
        let indexStr = String(format: "%03d", index)
        return "NLog-\(dataStr)-\(indexStr).log"
    }
    
    static func doNotReuseLogFiles() -> Bool {
        let todayStr = XsLogConfig.dateFormatter(fm: "YYYY-MM-dd").string(from: Date())
        let subpaths = try? FileManager.default.subpathsOfDirectory(atPath: XsLogConfig.logPath.path)
        if let subpaths = subpaths, subpaths.count > 0 {
            return subpaths.filter { $0.contains(todayStr) }.count == 0
        } else {
            return false
        }
    }
}

//MARK: ---- Print.
public func XsLoggerPrint<T>(_ message: @autoclosure () -> T,
                            filePath: StaticString = #file,
                            function:StaticString = #function,
                            rowCount: Int = #line,
                            logLevel: NLogLevel = .debug,
                            customTag:String = "Xs",
                            isFlutter: Bool = false) {
    if !XsLogConfig.isSetup {
        XsLogConfig.setupDDLog()
    }
    let tagStr = (isFlutter ? XsLogConfig.flutterTag : XsLogConfig.nativeTag) + XsLogConfig.separateMark + customTag
    if XsLogConfig.shared.openLogFileWriting {
        if XsLogConfig.shared.level == .release {
            if logLevel == .release {
                DDLogVerbose(message(),
                             file: filePath ,
                             function: function,
                             line: UInt(rowCount),
                             tag: tagStr,
                             asynchronous:XsLogConfig.shared.isAsync)
            }
        } else {
            DDLogVerbose(message(),
                         file: filePath ,
                         function: function,
                         line: UInt(rowCount),
                         tag: tagStr,
                         asynchronous: XsLogConfig.shared.isAsync)
        }
    }
}

//MARK: ---- CUSTOM DDLOG.
public class DDLogFormat: DDLogFileFormatterDefault {
    public override func format(message logMessage: DDLogMessage) -> String? {
        if let tag = logMessage.representedObject as? String, tag.contains(XsLogConfig.nativeTag) { //native.
            let cusTag = tag.replacingOccurrences(of: XsLogConfig.nativeTag+XsLogConfig.separateMark, with: "")
            let dateAndTime = XsLogConfig.dateFormatter(fm: "MM-dd HH:mm:ss:SSS").string(from: logMessage.timestamp)
            return "\(dateAndTime) \(cusTag) [\(logMessage.fileName) \(logMessage.function ?? "") Row:\(logMessage.line)] \(logMessage.message)"
        } else if let tag = logMessage.representedObject as? String, tag.contains(XsLogConfig.flutterTag) { //flutter.
            return "\(logMessage.message)"
        } else { //others. no use.
            let dateAndTime = XsLogConfig.dateFormatter(fm: "MM-dd HH:mm:ss:SSS").string(from: logMessage.timestamp)
            return "\(dateAndTime) [\(logMessage.fileName) \(logMessage.function ?? "") Row:\(logMessage.line)] \(logMessage.message)"
        }
    }
}

public class ConsoleLogFormat:NSObject, DDLogFormatter {
    public func format(message logMessage: DDLogMessage) -> String? {
        return "[\(logMessage.fileName) Row:\(logMessage.line)] \(logMessage.message)"
    }
}

class NTDDLogFileManagerDefault: DDLogFileManagerDefault {
    
    override var newLogFileName: String {
        let newName = XsLogConfig.shared.createNewFileName()
        print("Will create new file: \(newName)")
        return newName
    }
    
    override func isLogFile(withName fileName: String) -> Bool {
        return true
    }
}

public func XsRemoveLogs() {
    let path = XsLogConfig.logPath.path
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(atPath: path)
        for file in fileURLs {
            let filePath = (path as NSString).appendingPathComponent(file)
            try FileManager.default.removeItem(atPath: filePath)
        }
        print("=== 删除Log成功")
    } catch {
        print("=== 删除失败：\(error.localizedDescription)")
    }
}
