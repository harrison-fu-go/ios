//
//  IMessage.swift
//  YYiMessage
//
//  Created by Harrison Fu on 2024/10/24.
//
import MessageUI
import Foundation
import UIKit
import SwiftUI

class Message:NSObject, MFMessageComposeViewControllerDelegate {
    
    static let shared = Message()
    func sendMess() -> UIViewController? {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "This is a test message"
            messageVC.recipients = ["+86 15820727194"]  // 收件人
            messageVC.messageComposeDelegate = self
            return messageVC
        }
        return nil
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
}


// 自定义 UIViewController 的表示
struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
    
    // 创建并返回 UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        var myViewController = UIViewController()
        myViewController.view.backgroundColor = .red
        //        if let vc = Message.shared.sendMess() {
        //            myViewController = vc
        //        }
        return myViewController
    }
    
    // 更新 UIViewController（当数据发生变化时）
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 可以在此更新 UI
    }
}

// 自定义包装类，处理展示时的动画
struct AnimatedViewControllerWrapper: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        MyUIViewControllerRepresentable()
            .onAppear {
                // 通过 CATransition 实现从右到左的动画
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .push
                transition.subtype = .fromRight // 从右到左的动画效果
                transition.timingFunction = CAMediaTimingFunction(name: .linear)
                
                if let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.layer.add(transition, forKey: kCATransition)
                    }
                }
                // 获取当前 window 并应用动画
                //UIApplication.shared.windows.first?.layer.add(transition, forKey: kCATransition)
            }
    }
}
