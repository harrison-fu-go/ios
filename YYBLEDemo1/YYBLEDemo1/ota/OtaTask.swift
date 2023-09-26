//
//  OtaTask.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/14.
//

import Foundation
import CryptoSwift
import CryptoKit

class OtaTask {
    
    // MARK:  常量
    let REQUEST_CTRL_OTA_START = 0
    let RESPONSE_CTRL_OTA_START = 1
    let REQUEST_CTRL_NEW_BLOCK = 2
    let REQUEST_CTRL_DATA_FINISH = 3
    let REQUEST_SIGNATURE_DATA_SEND = 4
    let RESPONSE_SIGNATURE = 5
    let RESPONSE_MEMORY_ADDRESS_ERROR = 6
    let maxSegmentBytesLength = 19
    
    private var allSegmentSize = 100
    private var allBlockSize = 100
    var currentBlock: Block? = nil
    var blocks = [Block]()//remove
    private var currentSegmentCache = [Segment]()
    let path:String
    var data:Data?
    
    init(path: String) {
        self.path = path
        data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path))
    }
    
    func startPkt() -> Data?{
        guard let crc32 = data?.crc32() else {
            return nil
        }
        var cmd = Data()
        cmd.append(UInt8(REQUEST_CTRL_OTA_START))
        cmd.append(contentsOf: UInt16(19).toBytes(endian: false))
        cmd.append(contentsOf: crc32.reversed())
        cmd.append(contentsOf: UInt32(data?.count ?? 0).toBytes())
        //001300fd50858dfcc50000
        return cmd
    }
    
    //当上一个Block的Segment所有发送完成时（read ack确认）
    func loadNextBlockPacket() -> Data?{
        self.currentBlock = blocks.isEmpty ? nil : blocks.remove(at: 0)
        currentSegmentCache.removeAll()
        guard currentBlock != nil else {
            return nil
        }
        //装载当前Block的Segment
        currentBlock?.segments.forEach({ (segment) in
            currentSegmentCache.append(segment)
        })
        //开始新的Block的命令
        let bytes: [UInt8] = [
            REQUEST_CTRL_NEW_BLOCK.toUInt8(), currentBlock!.index.toUInt8(), (currentBlock!.index >> 8).toUInt8()
        ]
        return Data(bytes: bytes, count: 3)
    }
    
    func loadAllDataOfBlock() -> Data{
        var data = Data()
        for datum in currentSegmentCache {
            data.append(contentsOf: datum.bytes)
        }
        return data
    }
    
    
    //当发送下一个Segment时
    func loadNextSegment() -> Data? {
        guard currentSegmentCache.count > 0 else {
            return nil
        }
        let currentSegment = currentSegmentCache.remove(at: 0)
        var cmd = Data()
        cmd.append(contentsOf: currentSegment.bytes)
        return cmd
    }
    
    //当模块indicate恢复可以开始任务时
    func setup(maxSegmentNumInBlock: Int){
        guard data != nil else {
            return
        }
        //清除可能残留的任务数据
        blocks.removeAll()
        allSegmentSize = 0
        allBlockSize = 0
        //计算一个Block里面最大可能存放多少字节
        let maxBlockBytesLength = maxSegmentNumInBlock * maxSegmentBytesLength
        let allBytesSize = data!.count
        let allBytes: [UInt8] = [UInt8](data!)
        var blockIndex = 0
        for index in stride(from: 0, to: allBytesSize, by: maxBlockBytesLength){
            let remain = allBytesSize - index
            let len = remain <= maxBlockBytesLength ? remain : maxBlockBytesLength
            let range = index ..< (index + len)
            var bytesOfBlock = [UInt8]()
            bytesOfBlock.append(contentsOf: allBytes[range])
            let block = parseBlock(blockIndex: blockIndex, bytesOfBlock: bytesOfBlock)
            blocks.append(block)
            allSegmentSize += block.segments.count
            blockIndex += 1
        }
        allBlockSize = blocks.count
    }
    
   private func parseBlock(blockIndex:Int, bytesOfBlock:[UInt8]) -> Block {
        var segments = [Segment]()
        var segIndex = 0
        for index in stride(from: 0, to: bytesOfBlock.count, by: maxSegmentBytesLength){
            let remain = bytesOfBlock.count - index
            let len = remain <= maxSegmentBytesLength ? remain : maxSegmentBytesLength
            let range = index ..< (index + len)
            var bytes = [UInt8]()
            bytes.append(segIndex.toUInt8())
            bytes.append(contentsOf: bytesOfBlock[range])
            let seg = Segment(index: segIndex, bytes: bytes)
            segments.append(seg)
            segIndex += 1
        }
        return Block(index: blockIndex, segments: segments)
    }
    
    //read ack 时
    func needResendSegments(ack:Data) -> Bool {
        guard currentBlock != nil else {
            return false
        }
        let segNum = currentBlock!.segments.count
        var needResendIndex = -1
        for i in 0 ..< segNum{
            let temp = UInt8(1 << (i % 8))
            let sent = ack[ i/8 ] & temp != 0
            if !sent {
                needResendIndex = i
            }
        }
        if needResendIndex >= 0 {
            currentSegmentCache.removeAll()
            let range = needResendIndex ..< currentBlock!.segments.count
            currentSegmentCache.append(contentsOf: currentBlock!.segments[range])
            return true
        }else {
            return false
        }
    }
}

struct Block {
    let index:Int
    let segments: [Segment]
}

struct Segment {
    let index:Int
    let bytes:[UInt8]
}
