//
//  PushManagerViewModel.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/10.
//

import Foundation

enum PushType {
    case call
    case message
    case wechat
    case qq
    case dingTalk //钉钉
    case weCom //企业微信
    case music
    case email
    case others
}

struct PushManagerViewModel {
    
    let allSwitch = true   
    let pageContents = [
        ["type":PushType.call, "icon": Asset.Connection.phone.image, "title":"电话", "switch":false],
        ["type":PushType.message, "icon":Asset.Connection.message.image, "title":"信息", "switch":true],
        ["type":PushType.wechat, "icon":Asset.Connection.wachat.image, "title":"微信", "switch":false],
        ["type":PushType.qq, "icon":Asset.Connection.qq.image, "title":"QQ", "switch":true],
        ["type":PushType.dingTalk, "icon":Asset.Connection.dingtalk.image, "title":"钉钉", "switch":true],
        ["type":PushType.weCom, "icon":Asset.Connection.weCom.image, "title":"企业微信", "switch":false],
        ["type":PushType.music, "icon":Asset.Connection.music.image, "title":"音乐", "switch":false],
        ["type":PushType.email, "icon":Asset.Connection.mail.image, "title":"邮件", "switch":true],
        ["type":PushType.others, "icon":Asset.Connection.other.image, "title":"其他", "switch":true]
    ]
    
    
}
