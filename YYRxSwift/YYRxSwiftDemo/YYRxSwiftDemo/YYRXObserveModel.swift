//
//  YYRXObserveModel.swift
//  YYRxSwiftDemo
//
//  Created by zk-fuhuayou on 2021/5/11.
//

import Foundation
import RxSwift
class YYRXObserveModel: NSObject {
    
    @objc dynamic var name: String = "Fu..."
    
    private let agePublic = PublishSubject<Int>()
    var age: Observable<Int> {
        return agePublic.asObserver()
    }
    

    func gotoChange() {
        DispatchQueue.global().asyncAfter(deadline:.now() + 3) {
            self.name = "Hellllllllo... world. "
        }
        
        DispatchQueue.global().asyncAfter(deadline:.now() + 5) {
            self.agePublic.onNext(10)
        }
        
        
            
        
    }
    
    
}
