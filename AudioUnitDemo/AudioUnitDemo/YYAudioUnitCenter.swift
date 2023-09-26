//
//  YYAudioUnitCenter.swift
//  AudioUnitDemo
//
//  Created by zk-fuhuayou on 2021/8/16.
//

import UIKit
import AudioUnit
class YYAudioUnitCenter: NSObject {


    
    let kOutputBus:AudioUnitElement = 0
    let kInputBus:AudioUnitElement = 1
    var osStatus:OSStatus?
    static var audioUnit:AudioComponentInstance?
    var desc:AudioComponentDescription = AudioComponentDescription()

    var recordCallback: AURenderCallback?
    
    static var bufferList:AudioBufferList = AudioBufferList()
    
    func iRecordCallback() -> AURenderCallback {
     
        func callback(inRefCon: UnsafeMutableRawPointer,
                       ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                       inTimeStamp:UnsafePointer<AudioTimeStamp>,
                       inBufNumber:UInt32,
                       inNumberFrames:UInt32,
                       ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {
            AudioUnitRender(YYAudioUnitCenter.audioUnit!, ioActionFlags, inTimeStamp, inBufNumber, inNumberFrames, &(YYAudioUnitCenter.bufferList))

            print("====", YYAudioUnitCenter.bufferList)
            return noErr
        }
        return callback
    }

    override init() {
        super.init()
        desc.componentType = kAudioUnitType_Output
        desc.componentSubType = kAudioUnitSubType_RemoteIO
        desc.componentFlags = 0
        desc.componentFlagsMask = 0
        desc.componentManufacturer = kAudioUnitManufacturer_Apple
        let inputComponent = AudioComponentFindNext(nil, &desc)
        if let inputComponent = inputComponent {
            osStatus = AudioComponentInstanceNew(inputComponent, &YYAudioUnitCenter.audioUnit);
            checkStatus(status: osStatus)
        }
        
        
        // 为录制打开 IO
        var flag:UInt32 = 1
        let sizeOfFlag = UInt32(MemoryLayout.size(ofValue: flag))
        osStatus = AudioUnitSetProperty(YYAudioUnitCenter.audioUnit!,
                                        kAudioOutputUnitProperty_EnableIO,
                                        kAudioUnitScope_Input,
                                        kInputBus,
                                        &flag,
                                        sizeOfFlag)
        checkStatus(status: osStatus)
        
        osStatus = AudioUnitSetProperty(YYAudioUnitCenter.audioUnit!,
                                        kAudioOutputUnitProperty_EnableIO,
                                        kAudioUnitScope_Output,
                                        kOutputBus,
                                        &flag,
                                        sizeOfFlag)
        checkStatus(status:osStatus)
        
        // 描述格式
        var audioFormat = AudioStreamBasicDescription()
        audioFormat.mSampleRate         = 44100.00
        audioFormat.mFormatID           = kAudioFormatLinearPCM
        audioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        audioFormat.mFramesPerPacket    = 1
        audioFormat.mChannelsPerFrame   = 1
        audioFormat.mBitsPerChannel = 16
        audioFormat.mBytesPerPacket = 2
        audioFormat.mBytesPerFrame      = 2
        // 设置格式
        osStatus = AudioUnitSetProperty(YYAudioUnitCenter.audioUnit!,
                                        kAudioUnitProperty_StreamFormat,
                                        kAudioUnitScope_Output,
                                        kInputBus,
                                        &audioFormat,
                                        UInt32(MemoryLayout.size(ofValue: audioFormat)));
        checkStatus(status: osStatus);
        
        osStatus = AudioUnitSetProperty(YYAudioUnitCenter.audioUnit!,
                                        kAudioUnitProperty_StreamFormat,
                                        kAudioUnitScope_Input,
                                        kOutputBus,
                                        &audioFormat,
                                        UInt32(MemoryLayout.size(ofValue:audioFormat)));
        checkStatus(status:osStatus);
        
        var callbackStruct = AURenderCallbackStruct()
        callbackStruct.inputProc = self.iRecordCallback()
        callbackStruct.inputProcRefCon = self.ptrToSelf()
        
        osStatus = AudioUnitSetProperty(YYAudioUnitCenter.audioUnit!,
                                        kAudioOutputUnitProperty_SetInputCallback,
                                        kAudioUnitScope_Global,
                                        kInputBus,
                                        &callbackStruct,
                                        UInt32(MemoryLayout.size(ofValue:callbackStruct)))
        checkStatus(status:osStatus)
    }
    
    func start() {
//        if let audioUnit = YYAudioUnitCenter.audioUnit {
//            let status = AudioOutputUnitStart(audioUnit)
//            checkStatus(status: status)
//        }
        
        if YYAudioUnitCenter.audioUnit == nil {
            return
        }
        
        let status = AudioOutputUnitStart(YYAudioUnitCenter.audioUnit!)
        checkStatus(status: status)
    }
    
    func stop() {
        if YYAudioUnitCenter.audioUnit != nil {
            let status = AudioOutputUnitStop(YYAudioUnitCenter.audioUnit!)
            checkStatus(status: status)
        }
    }
    
    func disposeAudioUnit() {
        if YYAudioUnitCenter.audioUnit == nil {
            return
        }
        
        var result = AudioOutputUnitStop(YYAudioUnitCenter.audioUnit!)
        if result != noErr {
            print("======== Audio Unit aready stop: --> ", #function)
        }
        
        result = AudioUnitUninitialize(YYAudioUnitCenter.audioUnit!)
        if result != noErr {
            print("======== Audio Unit Uninitialize fail: --> ", #function)
        }
        
        result = AudioComponentInstanceDispose(YYAudioUnitCenter.audioUnit!)
        if result != noErr {
            print("======== Audio Unit Dispose fail: --> ", #function)
        }
    }
    
    func checkStatus(status:OSStatus?) {
        print("============= OSStatus ====== : ", status ?? "Unknow.")
    }
    
    func ptrToSelf() -> UnsafeMutableRawPointer {
        let pointer =  Unmanaged.passUnretained(self).toOpaque()
        return pointer
    }
}



class YYAudio: NSObject {
    
    
    //采样的通道数，Apple只有一个
    let KAUChannelCount = 1 //channel's count.
    
    //采样格式的配置
    let KAUSampleRate = 44100.00 //smapling is 44.1k 采样率
    let KAUFormatID = kAudioFormatLinearPCM
    let KAUFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
    var KAUBytesPerPacket = 0 // 一个包里面有多少个字节
    let KAUFramesPerPackage = UInt32(1) // 一包有多少贞
    var KAUChannelsPerFrame = 1 //一贞里面的通道
    let KAUBitsPerChannel = 16 //channel's bits count. 采样的宽度 16 位

    var audioUnit:AudioUnit?
    
    override init() {
        super.init()
        KAUChannelsPerFrame = KAUChannelCount
        KAUBytesPerPacket = (Int(KAUFramesPerPackage) * KAUChannelsPerFrame * KAUBitsPerChannel) / 8
    }
    
    
    //init audio uinit.
    func iAudioUnit() -> AudioUnit? {
        if audioUnit != nil {
            return audioUnit
        }
        var desc:AudioComponentDescription = AudioComponentDescription()
        desc.componentType = kAudioUnitType_Output
        desc.componentSubType = kAudioUnitSubType_RemoteIO
        desc.componentFlags = 0
        desc.componentFlagsMask = 0
        desc.componentManufacturer = kAudioUnitManufacturer_Apple
        guard let inputComponent = AudioComponentFindNext(nil, &desc) else { return nil }
        let osStatus = AudioComponentInstanceNew(inputComponent, &audioUnit)
        checkStatus(status: osStatus, step: "Init AudioUnit")
        return audioUnit
    }
    
    //set format for sampling
    func setSamplingFormat() {
        
        var audioFormat = AudioStreamBasicDescription()
        audioFormat.mSampleRate         = KAUSampleRate
        audioFormat.mFormatID           = KAUFormatID
        audioFormat.mFormatFlags        = KAUFormatFlags
        audioFormat.mFramesPerPacket    = KAUFramesPerPackage
        audioFormat.mChannelsPerFrame   = UInt32(KAUChannelsPerFrame)
        audioFormat.mBitsPerChannel = UInt32(KAUBitsPerChannel)
        audioFormat.mBytesPerPacket = UInt32(KAUBytesPerPacket)
        audioFormat.mBytesPerFrame  =
    }
    
    
    func checkStatus(status:OSStatus, step:String) {
        print("=============step: \(step) ----- OSStatus: ====== : \(status)")
    }
    
    
}
