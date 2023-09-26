//
//  YYRadarChart.swift
//  YYRadarChart
//
//  Created by HarrisonFu on 2022/5/3.
//

import Foundation
import UIKit
enum RadarSide: Int {
    case top, `left`, `right`
}
class YYRadarChart: UIView {
    let pointWidth = 1.0
    let SW = UIScreen.main.bounds.width
    let marginLeft = 57.0
    let marginRight = 57.0
    var chartWidth:Double
    let marginTop = 48.0 + 15.0
    let chartHeight = 284.0
    let centerH:Double
    let topPoint:CGPoint
    let leftPoint:CGPoint
    let rightPoint:CGPoint
    let centerPoint: CGPoint
    let baseLineColor = UIColor(red: 63.0/255.0, green:65.0/255.0, blue: 66.0/255.0, alpha: 1.0).cgColor
    //#4651A9
    let textColor = UIColor(red: 0x46/255.0, green: 0x51/255.0, blue: 0xa9/255.0, alpha: 1.0)

    //selected points
    var selectedTopPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var selectedLeftPoint: CGPoint  = CGPoint(x: 0.0, y: 0.0)
    var selectedRightPoint: CGPoint  = CGPoint(x: 0.0, y: 0.0)
    
    //selected area.
    let selectedAreaLayer = CAShapeLayer()
    
    //drag buttons
    var dragTop: UIView?
    var dragLeft: UIView?
    var dragRight: UIView?

    //selected center lines.
    let centerLinesLayer = CAShapeLayer()
    override init(frame: CGRect) {
        chartWidth = SW - marginLeft - marginRight
        centerH = chartHeight / 2.0 + 20
        topPoint = CGPoint(x:(SW - pointWidth)/2.0, y: marginTop)
        leftPoint = CGPoint(x: marginLeft, y: marginTop + chartHeight)
        rightPoint = CGPoint(x: SW - marginRight - pointWidth / 2.0 , y: marginTop + chartHeight)
        centerPoint  = CGPoint(x:(SW - pointWidth)/2.0, y: marginTop + centerH)
        super.init(frame: frame)
        //set default points.
        selectedTopPoint = pointOfOPercent(side: .top, percent: 0.5)
        selectedLeftPoint =  pointOfOPercent(side: .left, percent: 0.5)
        selectedRightPoint =  pointOfOPercent(side: .right, percent: 0.5)
        self.backgroundColor = .black
        
        //draw
        drawBaseChart()
        drawCenterText0()
        
        //selected area
        self.layer.addSublayer(selectedAreaLayer)
        
        //init drags
        initDragButtons()
        
        //centerLinesLayer
        self.layer.addSublayer(centerLinesLayer)
    }
    
    func pointOfOPercent(side: RadarSide, percent: Double) -> CGPoint {
        switch side {
        case .top:
            return CGPoint(x: (SW - pointWidth)/2.0, y: marginTop + centerH - percent * centerH)
        case .left:
            let H = percent * (chartHeight - centerH)
            let Y = centerPoint.y + H
            let X = marginLeft + chartWidth * 0.5 - (percent * chartWidth * 0.5)
            return CGPoint(x: X, y: Y)
        case .right:
            let H = percent * (chartHeight - centerH)
            let Y = centerPoint.y + H
            let X = marginLeft + chartWidth * 0.5 + (percent * chartWidth * 0.5)
            return CGPoint(x: X, y: Y)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        print("======== radar chart draw ========")
        drawSelectedArea()
        drawDragButtons()
        drawCenterLines()
    }
    
    
    func drawBaseChart() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: rightPoint)
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = baseLineColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        
        let shapeLayer0 = CAShapeLayer()
        let path0 = UIBezierPath()
        path0.move(to: topPoint)
        path0.addLine(to: centerPoint)
        path0.addLine(to: leftPoint)
        path0.move(to: centerPoint)
        path0.addLine(to: rightPoint)
        shapeLayer0.path = path0.cgPath
        shapeLayer0.lineWidth = 2.0
        shapeLayer0.strokeColor = baseLineColor
        shapeLayer0.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer0)
    }
    
    func drawCenterText0() {
        //set the center text: 0
        let label0 = UILabel(frame: CGRect(x: (SW - 50.0)/2.0, y: centerPoint.y + 3, width: 50.0, height: 24.0))
        label0.text = "0"
        label0.textColor = textColor
        label0.textAlignment = .center
        self.addSubview(label0)
    }
    
    func drawSelectedArea() {
        let path = UIBezierPath()
        path.move(to: selectedTopPoint)
        path.addLine(to: selectedLeftPoint)
        path.addLine(to: selectedRightPoint)
        path.close()
        selectedAreaLayer.path = path.cgPath
        selectedAreaLayer.lineWidth = 0.0
        selectedAreaLayer.strokeColor = UIColor.clear.cgColor
        selectedAreaLayer.fillColor = UIColor(red: 70.0/255.0, green: 81.0/255.0, blue: 169.0/255.0, alpha: 0.5).cgColor
    }
    
    func initDragButtons() {
        let radius = 40.0
        self.dragTop = DragView(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        guard let dragTop = self.dragTop else {
            return
        }
        dragTop.center = selectedTopPoint
        dragTop.tag = RadarSide.top.rawValue
        self.addSubview(dragTop)
        let pan0 = UIPanGestureRecognizer(target: self, action: #selector(onDragControl))
        pan0.maximumNumberOfTouches=1
        dragTop.addGestureRecognizer(pan0)
        
        self.dragLeft = DragView(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        guard let left = self.dragLeft else {
            return
        }
        left.center = selectedLeftPoint
        left.tag = RadarSide.left.rawValue
        self.addSubview(left)
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(onDragControl))
        pan1.maximumNumberOfTouches=1
        left.addGestureRecognizer(pan1)
        
        self.dragRight =  DragView(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        guard let right = self.dragRight else {
            return
        }
        right.center = selectedRightPoint
        right.tag = RadarSide.right.rawValue
        self.addSubview(right)
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(onDragControl))
        pan2.maximumNumberOfTouches=1
        right.addGestureRecognizer(pan2)
    }
    
    func drawDragButtons() {
        self.dragTop?.center = selectedTopPoint
        self.dragLeft?.center = selectedLeftPoint
        self.dragRight?.center = selectedRightPoint
    }
    
    
    func drawCenterLines() {
        let path0 = UIBezierPath()
        path0.move(to: selectedTopPoint)
        path0.addLine(to: centerPoint)
        path0.addLine(to: selectedLeftPoint)
        path0.addLine(to: centerPoint)
        path0.addLine(to: selectedRightPoint)
        centerLinesLayer.path = path0.cgPath
        centerLinesLayer.lineWidth = 3.0
        centerLinesLayer.strokeColor = UIColor(red: 70.0/255.0, green: 81.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
        centerLinesLayer.fillColor = UIColor.clear.cgColor
    }
    
    @objc func onDragControl(_ pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else { return }
        let point = pan.location(in: view.superview)
        switch view.tag {
        case 0:
            var y = point.y
            if y < marginTop {
                y = marginTop
            }
            if y > marginTop + centerH {
                y = marginTop + centerH
            }
            selectedTopPoint = CGPoint(x: topPoint.x, y: y)
        case 1:
            var y = point.y
            if y < marginTop + centerH {
                y = marginTop + centerH
            }
            if y > marginTop + chartHeight {
                y = marginTop + chartHeight
            }
            let percent = (y - (marginTop + centerH)) / (chartHeight - centerH)
            selectedLeftPoint = pointOfOPercent(side: .left, percent: percent)
        default:
            var y = point.y
            if y < marginTop + centerH {
                y = marginTop + centerH
            }
            if y > marginTop + chartHeight {
                y = marginTop + chartHeight
            }
            let percent = (y - (marginTop + centerH)) / (chartHeight - centerH)
            selectedRightPoint = pointOfOPercent(side: .right, percent: percent)
        }
        setNeedsDisplay()
        print("=======x:  \(point.x) === y:  \(point.y)")
    }
    
    
}


class DragView: UIView {
    let showView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(showView)
        showView.backgroundColor = UIColor(red: 70.0/255.0, green: 81.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        showView.layer.cornerRadius = 10.0
        showView.clipsToBounds = true
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        showView.center = CGPoint(x: 20.0, y: 20.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
