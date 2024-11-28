//
//  SiriSTT.swift
//  YYAppIntelligence
//
//  Created by Harrison Fu on 2024/10/22.
//

import Foundation
import Speech
class SiriSTT: ObservableObject {
    static let shared = SiriSTT()
    private var isUserSpeaking = false
    private var silenceTimer: YYTimer?
    var currentSpeakStr = ""
    init() {
//        _ = createRecognizer(localeStr: "en_US")
        _ = createRecognizer(localeStr: "zh_CN")
    }
    var recognizers = [(String, SFSpeechRecognizer)]()
    var tasks = [(String, SFSpeechRecognitionTask)]()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    private let audioEngine = AVAudioEngine()
    var inputNode: AVAudioInputNode {
        return audioEngine.inputNode
    }
    
    //new.
    var recognitionTask: SFSpeechRecognitionTask?
    @Published var currentCount = 0
    @Published var currentFinalText = ""
    var currentErrorCount = 0
    
    // 请求语音识别权限
    func requestAuthorization(callback: @escaping (Bool)->Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    callback(true)
                case .denied, .restricted, .notDetermined:
                    callback(false)
                @unknown default:
                    callback(false)
                }
            }
        }
    }
    
    
    // 开始语音识别
    func startRecording() {
        // 确保没有现有的识别任务
        cancelAllTasks()
        
        // 配置音频会话
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        //create request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        ///启动识别任务
        for (key, recognizer) in recognizers {
            let recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result , error in
                if let result = result {
                    print("\(key)识别结果:\(result.bestTranscription.formattedString)")
                    self.currentSpeakStr = result.bestTranscription.formattedString
                }
                if result?.isFinal == true {
                    self.audioEngine.pause()
                    self.inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                }
                if let error = error as? NSError, error.code != 1110 { //|| result?.isFinal == true {
                    print("\(key)错误: \(String(describing: error))")
                }
            }
            tasks.append((key, recognitionTask))
        }
        
        let recordingFormat = self.inputNode.outputFormat(forBus: 0)
        self.inputNode.installTap(onBus: 0, bufferSize: 10, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
//            DispatchQueue.global().async {
//                self.processAudioBuffer(buff: buffer)
//            }
        }
        
        audioEngine.prepare()
        
        try! audioEngine.start()
        print("Say something, I'm listening!")
        
    }
    
    // 处理音频缓冲区，计算音量
     private func processAudioBuffer(buff: AVAudioPCMBuffer) {
         guard let buffer = deepCopyPCMBuffer(buff) else { return }
         let channelData = buffer.floatChannelData![0]
         let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelData[$0] }
         
         // 计算RMS（均方根）来判断音量
         let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(channelDataValueArray.count))
         
         // 定义一个阈值来判断是否在说话
         let silenceThreshold: Float = 0.01
         
         if rms > silenceThreshold {
//             print("录音--> 检测到声音，重置计时器")
             resetSilenceTimer()  // 检测到声音，重置计时器
//             self.recognitionRequest?.append(buffer)
         } else {
//             print("录音--> 静音，启动计时器")
             startSilenceTimer()  // 静音，启动计时器
         }
     }
    
    // 重置静音计时器
    private func resetSilenceTimer() {
        isUserSpeaking = true
        silenceTimer?.invalidate()
        silenceTimer = nil
        self.recognitionRequest = nil
    }
    
    // 开始静音计时器
    private func startSilenceTimer() {
        if self.silenceTimer == nil {
            self.silenceTimer = YYTimer(interval: 3.0, repeats: false, block: { _ in
                self.stopRecording()
            })
        }
    }
    
    // 停止音频采样
    func stopRecording() {
        
        audioEngine.pause()
        inputNode.removeTap(onBus: 0)
        
        self.silenceTimer?.invalidate()
        self.silenceTimer = nil
        cancelAllTasks()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        print("停止录音--> 输出当前讲话： \(self.currentSpeakStr)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startRecording()
        }
    }
}

extension SiriSTT {
    
    //create recognizer.
    func createRecognizer(localeStr: String) -> SFSpeechRecognizer? {
        let locale = Locale(identifier: localeStr)
        if let recognizer = SFSpeechRecognizer(locale: locale) {
            recognizers.append((localeStr, recognizer))
            return recognizer
        }
        return nil
    }
    
    //create reqeust.
    func createRequest(localeStr: String) -> SFSpeechAudioBufferRecognitionRequest? {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        return request
    }
    
    //cancel tasks
    func cancelAllTasks() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
    
    func deepCopyPCMBuffer(_ buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        guard let format = buffer.format as AVAudioFormat? else { return nil }
        
        // 创建一个新的AVAudioPCMBuffer并分配相同的容量
        guard let newBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: buffer.frameCapacity) else { return nil }
        
        newBuffer.frameLength = buffer.frameLength

        // 复制通道数据 (AudioBufferList)
        for channel in 0..<Int(buffer.format.channelCount) {
            if let sourceData = buffer.floatChannelData?[channel],
               let destinationData = newBuffer.floatChannelData?[channel] {
                memcpy(destinationData, sourceData, Int(buffer.frameLength) * MemoryLayout<Float>.size)
            }
        }
        
        return newBuffer
    }
}

extension SiriSTT {
    
    func convertMP3ToPCM(fileURL: URL) -> AVAudioPCMBuffer? {
        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            let audioFormat = audioFile.processingFormat
            let frameCount = UInt32(audioFile.length)
            guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount) else {
                return nil
            }
            
            try audioFile.read(into: pcmBuffer)
            return pcmBuffer
        } catch {
            print("Error reading MP3 file: \(error)")
            return nil
        }
    }
    
    func startSpeechRecognition(with buffer: AVAudioPCMBuffer, format: AVAudioFormat) {
        let locale = Locale(identifier: "zh-CN")
        let speechRecognizer = SFSpeechRecognizer(locale: locale)
        let request = SFSpeechAudioBufferRecognitionRequest()
//        request.requiresOnDeviceRecognition = true
        // 设置语音识别任务
        self.recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                self.currentFinalText = result.bestTranscription.formattedString
            } 
            
            if let error = error as? NSError{ //错误
                let text = "Transcription error(\(self.currentCount)): code->\(error.code) mess->\(error.localizedDescription)"
                print(text)
                XsLoggerPrint(text)
                self.currentErrorCount = self.currentErrorCount + 1
            }
            
            if result?.isFinal == true {
                let text = "Transcription \(self.currentCount): \(self.currentFinalText)"
                print(text)
                XsLoggerPrint(text)
                self.currentCount = self.currentCount + 1
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                    self.startRecognitionMp3()
                }
            }
        })
        
        // 使用 buffer 的音频数据流传递给 request
        request.append(buffer)
        request.endAudio()
    }
    
    func startRecognitionMp3() {
        if let fileURL = Bundle.main.url(forResource: "zh-CN", withExtension: "mp3"),
           let pcmBuffer = convertMP3ToPCM(fileURL: fileURL) {
            startSpeechRecognition(with: pcmBuffer, format: pcmBuffer.format)
        }
    }
}
