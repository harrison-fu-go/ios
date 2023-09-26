//
//  SwiftPointer.swift
//  YYSwiftLearning
//
//  Created by zk-fuhuayou on 2021/8/27.
//

import UIKit

class SwiftPointer: NSObject {
    var iIdentifier:String?
    var hello:(Int) -> Void = { result in
         print("====================", result)
    }
    //MARK:指针的测试
    func Testing() {
  
        //获取对象的指针， .pontee: 可以拿到指针指向的对象
        var person = Person(address: "深圳", name: "Huayou", age: 18)
        let userPointer = withUnsafePointer(to: &person, {UnsafeRawPointer($0)})//UnsafeRawPointer($0)

        //第一种获取指针的值： 转为： UnsafePointer<>
        let user = withUnsafePointer(to: &person) { result in
            return result.pointee
        }
        print("========== user: ", user)
        let usr = withUnsafePointer(to:&person, {$0.pointee})
        print("========== user1111: ", usr)
        
        //转换：UnsafeRawPointer to UnsafePointer
        var usr1 = userPointer.assumingMemoryBound(to: Person.self).pointee
        print("========== user1111 ======== : ", usr1)
        usr1.address = "China"
        print("========== userFinal ======== : ", user, usr, usr1)
        
        
        //第二种获取值
        let address = userPointer.load(fromByteOffset:0, as: String.self)
        print("address: \(address)")
        
        let name = userPointer.load(fromByteOffset:MemoryLayout<String>.size, as: String.self)
        print("name: \(name)")
        
        let age = userPointer.load(fromByteOffset:MemoryLayout<String>.size * 2, as: Int.self)
        print("name: \(age)")
        
        //把 self 转成 pointer, 需要新建一个
        var iSelf = self
        let usrrr = withUnsafePointer(to: &iSelf, {UnsafePointer($0)}).pointee
        usrrr.iIdentifier = "Fu"
        print("========== iSelf ==== ", usrrr.iIdentifier ?? "")
       
        //各种类型的长度
        print("=======String size: ", MemoryLayout<String>.size) //16
        print("=======NSString size: ", MemoryLayout<NSString>.size) //8
        print("=======Int size: ", MemoryLayout<Int>.size)
        print("=======UInt size: ", MemoryLayout<UInt>.size)
        print("=======Int64 size: ", MemoryLayout<Int64>.size)
        print("=======Int32 size: ", MemoryLayout<Int32>.size)
        print("=======Double size: ", MemoryLayout<Double>.size)
        print("=======Float size: ", MemoryLayout<Float>.size)
        print("=======Hose size", MemoryLayout<House>.size) //24
    }
    
    //MARK: 关于结构体指针的研究
    var person = Person(address: "宝安", name: "第一个程咬金", age: 18)
    func structPointerTesting() {
        /**
         结果得到的并不是同一个 对象。 结论：
         */
        var pPointer = withUnsafePointer(to: &person, {$0.pointee})
        pPointer.address = "福田"
        print("========== person ======== : ", person)
        print("========== pPointer ======== : ", pPointer)
    }
    
    
    
}
