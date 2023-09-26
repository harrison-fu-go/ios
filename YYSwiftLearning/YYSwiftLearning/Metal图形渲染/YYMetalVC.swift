//
//  YYMetalVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/2/7.
//

import UIKit
import Metal
import MetalKit
let sW = UIScreen.main.bounds.width
let sH = UIScreen.main.bounds.height
class YYMetalVC: UIViewController {
    let label:UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        label.frame = CGRect(x: 50, y: 100, width: 300, height: 200)
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        guard  let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Your GPU does not support Metal!")
        }
        label.text = "Your system has the following GPU(s):\n" + "\(device.name)\n"
        
        //matal view.
        let metalView = YYMetalView(frame: CGRect(x: 0, y: 300, width: sW, height: 300))
        self.view.addSubview(metalView)
    }
    
}


class YYMetalView: MTKView {
    
    override func draw(_ rect: CGRect) {
        device = MTLCreateSystemDefaultDevice()
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0)
            rpd.colorAttachments[0].loadAction = .clear
            let commandBuffer = device!.makeCommandQueue()?.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}
