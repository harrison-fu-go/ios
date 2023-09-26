//
//  NTEQ.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/4/19.
//

import UIKit

typealias NTEQCoeff = (a0:Double, a1:Double, a2:Double, b0:Double, b1:Double, b2:Double)

class NTEQ: NSObject {
    
    public static func getFreqw(coeff:NTEQCoeff, w:Double) -> NTComplex {
        let complex = NTComplex(real: cos(w),image: -sin(w))  //欧拉公式e^(-jw)=cos(w)-jsin(w)
        let b2 = (complex.mul(complex)).mul(coeff.b2)  //b(2)*e^(-j2w)
        let b1 = complex.mul(coeff.b1)          //b(1)*e^(-jw)
        let hup = b2.add(b1).add(coeff.b0)       //b(0)+b(1)*e^(-jw)+b(2)*e^(-j2w)
        let a2 = (complex.mul(complex)).mul(coeff.a2)
        let a1 = complex.mul(coeff.a1)
        let hdown = a2.add(a1).add(coeff.a0)
        let res = hup.div(hdown)
      // Log.d("tzw", "getFreqw: "+res.getReal()+"+"+res.getImage()+"i");
       return res
   }

    public static func getFreqzn(coeff:NTEQCoeff, fs:Int, f:[Double]) -> [Double] {
        let n = f.count;
        var h =  [Double]();
        for i in 0 ..< n {
            let w = 2.0 * Double.pi * f[i] / Double(fs)
            let complex = self.getFreqw(coeff: coeff, w: w)
            let val = 20.0 * log10(abs(complex.getAmplitude())); //分贝（dB）
            h.append(val)
        }
        return h
    }
    
    public static func getEqCoefficients(gain:Double, Fc: Double, Fs: Double, Q:Double) -> NTEQCoeff {
        let A = pow(10.0, gain/40.0)
        let w0 = 2*Double.pi*Fc/Fs
        let alpha = sin(w0)/(2*Q);
        let b0 =   1 + alpha*A
        let b1 =  -2*cos(w0)
        let b2 =   1 - alpha*A
        let a0 =   1 + alpha/A
        let a1 =  -2*cos(w0)
        let a2 =   1 - alpha/A
        print("======== coefficients: \(a0),\(a1),\(a2),\(b0),\(b1),\(b2)")
        return (a0,a1,a2,b0,b1,b2)
    }
    
    public static func getFh(gain:Double, Fc: Double, Fs: Double, Q:Double) -> Double {
        let coeff = self.getEqCoefficients(gain: gain, Fc: Fc, Fs: Fs, Q: Q)
        let val = self.getFreqzn(coeff: coeff, fs: Int(Fs), f: [Fc]).first
        return val ?? 0
    }

}

public struct NTComplex {
    
    var real:Double;  // 实部
    var image:Double; // 虚部
    
    public func getReal() -> Double {
        return real
    }
    
    public mutating func setReal(real:Double) {
        self.real = real
    }

    public func getImage() -> Double {
        return image
    }

    public mutating func setImage(image:Double) {
        self.image = image
    }

    public func add(_ a:NTComplex) -> NTComplex {
        let real2 = a.getReal()
        let image2 = a.getImage()
        let newReal = real + real2
        let newImage = image + image2
        let result =  NTComplex(real: newReal,image: newImage)
        return result
    }

    public func sub(_ a:NTComplex) -> NTComplex {
        let real2 = a.getReal()
        let image2 = a.getImage()
        let newReal = real - real2
        let newImage = image - image2
        let result = NTComplex(real: newReal,image: newImage)
        return result
    }

    public func mul(_ a:NTComplex) -> NTComplex {
        let real2 = a.getReal()
        let image2 = a.getImage()
        let newReal = real*real2 - image*image2
        let newImage = image*real2 + real*image2
        let result = NTComplex(real: newReal,image: newImage)
        return result
    }

    public func div(_ a:NTComplex) -> NTComplex {
        let real2 = a.getReal()
        let image2 = a.getImage()
        let newReal = (real*real2 + image*image2)/(real2*real2 + image2*image2)
        let newImage = (image*real2 - real*image2)/(real2*real2 + image2*image2)
        let result = NTComplex(real: newReal,image: newImage)
        return result
    }
    
    public func mul(_ a:Double) -> NTComplex {
        let newReal = real*a
        let newImage = image*a
        let res  = NTComplex(real: newReal,image: newImage)
        return res
    }

    public func add(_ a:Double) -> NTComplex {
        let newReal = real+a
        let res = NTComplex(real: newReal, image: image)
        return res
    }
    
    public func getAmplitude() -> Double {
        return sqrt(pow(self.real, 2.0) + pow(self.image, 2.0))
    }
    
    public func print() { // 输出
        if(image > 0){
            debugPrint("\(real) + \(image)i")
        }else if(image < 0){
            debugPrint("\(real)\(image)i")
        }else{
            debugPrint("\(real)")
        }
    }
}

//       b0 + b1*z^-1 + b2*z^-2
//H(z) = ------------------------                                  (Eq 1)
//       a0 + a1*z^-1 + a2*z^-2
   //direct form I： y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2] - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]
//    func func_hz(gain:Double, Fc: Double, Q:Double) -> Double {
//        let Fs:Double = 48000.0 // 44100.0
//        let coe = self.getEqCoefficients(gain: gain, Fc: Fc, Fs: Fs, Q: Q)
//        var y:Double = (coe.b0 + coe.b1 * pow(Fc, -1.0) + coe.b2 * pow(Fc, -2.0)) / (coe.a0 + coe.a1 * pow(Fc, -1.0) + coe.a2 * pow(Fc, -2.0))
//        y = 20.0 * log10(abs(y))
//        print("======== func_hz0: \(y)")
//        return y
//    }
    
//    func process(samples: [Double], coe:(a0:Double, a1:Double, a2:Double, b0:Double, b1:Double, b2:Double)) -> [Double] {
//        var y = [Double](repeating: 0.0, count: samples.count)
//        for i in 0..<samples.count {
//            let x = samples[i]
//            let x_1 = samples[max(0, i - 1)]
//            let x_2 = samples[max(0, i - 2)]
//            let b0 = coe.b0/coe.a0, b1 = coe.b1/coe.a0, b2 = coe.b2/coe.a0
//            let a1 = coe.a1/coe.a0, a2 = coe.a2/coe.a0
//            y[i] = (b0 * x) + (b1 * x_1) + (b2 * x_2) - (a1 * y[max(0, i - 1)]) - (a2 * y[max(0, i - 2)])
//        }
//        return y
//    }
    

    //H(s) = (s^2 + s*(A/Q) + 1) / (s^2 + s/(A*Q) + 1)
//    func getFh(gain:Double, Fc: Double, Fs: Double, Q:Double) -> Double {
//        let A = pow(10.0, gain/40.0)
//        let hs = (Fc * Fc + Fc*(A/Q) + 1) / (Fc * Fc + Fc/(A*Q) + 1)
//        return hs
//    }
    
