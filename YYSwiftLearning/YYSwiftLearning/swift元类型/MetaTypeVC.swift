//
//  MetaTypeVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/11/30.
//

import UIKit

class MetaTypeVC: UIViewController {
    /**
        总结：
     1. .Type 是一种类型的元类型， 比如Int.Type 就是Int的元类型， Int.Type的值对于只有一个: Int.self
     
     2. 元类型的值可以使用： .self来拿到，静态的时候的比如： Int.self, String.self
        
     2. 根据实际的对象或者值，可以通过 type(of: XXXX), 动态拿到， 来推出元类型的值， 比如 type(of: 10)， type(of: "okok")
     
     3. AnyClass 其实是 AnyObject.Type 所以 let anyClass:[AnyClass] = [type(of: vc)] 是可以，但是不能把 type(of: 10)放进去，因为10不是object， 10 是值类型
     
     4. Any 其实是所有的元类
     
     //简洁的概要
     1 类型.Type = 值.self ---demo: let type1:Int.Type = type(of: 10)
     2 协议.Type = 实现类.self ---demo: //let pType: ContentCell.Type = IntCell.self
     3 协议.Protocol = 协议.self --- demo: //let pPro: ContentCell.Protocol = ContentCell.self
     4 type(of:) 运行时类型，self 编译器识别的类型
     
     */
    /*感想: 把元类型的值，当成是一个实例对象值。 为： 类型.self, 或者type(of:value), 元类型 类型.Type 为一个类去看待， 会好理解。 */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let vc = MetaTypeVC()
        let metatype: MetaTypeVC.Type = type(of: vc)
        let values:[Any] = [Int.self, String.self, MetaTypeVC.self, metatype, type(of: 0.2)]
        
        let i = 10
        if type(of: i) == Int.self {
            print("==== is same Int.Type")
        }
        
        //let type1:Int.Type = type(of: 10)
        //print("====type1: \(type1)") //---> Int
        
        print("==== \(values)")
       
//        let anyClass:[AnyClass] = [type(of: vc)]
//        let anyClass:[Any] = [AnyClass.self]
        
        //看一个demo
        //1. 工厂模式
        let intCell = createCell(type: IntCell.self)
        print("==== what is you? -> \(String(describing: intCell))")
        
        //2. 范型的使用
        let stringCell: StringCell? = createCell()
        print("==== what is you? String -> \(String(describing: stringCell))")
        let intCell1: IntCell? = createCell()
        print("==== what is you? Int -> \(String(describing: intCell1))")
    }
    
    
    func createCell(type: ContentCell.Type) -> ContentCell? {
        if let intCell = type as? IntCell.Type {
            return intCell.init(value: 5)
        } else if let stringCell = type as? StringCell.Type {
            return stringCell.init(value: "xx")
        }
        return nil
    }
    
    func createCell<T: ContentCell>() -> T? {
        if let intCell = T.self as? IntCell.Type {
            return intCell.init(value: 5) as? T
        } else if let stringCell = T.self as? StringCell.Type {
            return stringCell.init(value: "xx") as? T
        }
        return nil
    }
    
}

protocol ContentCell { }

class IntCell: UIView, ContentCell {
    required init(value: Int) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StringCell: UIView, ContentCell {
    required init(value: String) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

