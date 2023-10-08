//
//  关于use_frameworks! 的分析.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/10/8.
//

/*use_frameworks!
 
 use_frameworks!
 静态库： 编译时拷贝一份到目标程序中，目标程序编译完成后，不依赖外部的库也可以运行。
 动态库： 编译时只是存放动态库的引用，多程序可以共用，在运行时才加载，不会使运用体积变大
 Framework: 实际上只是一种打包方式，将库的二进制文件，头文件和有关的资源文件打包在一起，方便管理和分发

 通过cocopods方式管理运用程序时，在Profile文件中，使用 use_frameworks! 和不使用 的区别
 1. 使用 use_frameworks! 时候，dymanic frameworks 方式 -> .framework
 cocopods 会生成对应的frameworks文件，
 Link Binary With Libraries 时候，会生成Pods_工程名.framework, 包含了其他用cocopods导入的第三方框架的.framework文件
 
 
 2. 不使用 use_frameworks! 时， dymanic frameworks 方式 -> .a
 cocopods 会生成对应的.a文件(静态链接库)
 Link Binary With Libraries 时候，会生成Pods_工程名.a, 包含了其他用cocopods导入的第三方框架的.a文件
 
 A. 纯oc项目，通过cocopods导入OC库时，一般都不使用 use_frameworks!
 B. 纯swift项目，通过cocopods导入swift库时，必须使用 use_frameworks!
 C. 只要通过cocopods导入swift库时，都必须使用 use_frameworks!
 D. 使用动态链接库dynamic frameworks时，都必须使用 use_frameworks!
 F. swift 项目中通过pod导入OC项目
 1） 使用use_frameworks，在桥接文件里加上#import "AFNetworking/AFNetworking.h"
 2） 不使用frameworks，桥接文件加上 #import "AFNetworking.h"
 
 系统提供的库都是dylib动态库
 什么是tbd， “text_based stud libraries” 的缩写 Xcode7引入的技术，为了减少XCode中相应的SDK的体积，实际上是一个文本。
 其中有支持的架构，二进制文件的位置以及库中所有的symbols的声明，是动态库的一个描述

 
 **/
