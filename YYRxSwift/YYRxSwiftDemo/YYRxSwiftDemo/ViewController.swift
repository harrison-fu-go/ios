//
//  ViewController.swift
//  YYRxSwiftDemo
//
//  Created by zk-fuhuayou on 2021/5/11.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var rxButton: UIButton?
    var rxTextField: UITextField?
    var rxLabel: UILabel?
    var rxModel:YYRXObserveModel?
    var rxDisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        //rxswift button.
        rxButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        rxButton?.backgroundColor = .blue
        self.view.addSubview(rxButton!)
        rxButton?.setTitle("RxButton", for: .normal)
        rxButton?.rx.tap.subscribe(onNext: {_ in
            print("================ Did click.===================")
            self.gotoReqeuestNetwork()
        }).disposed(by: rxDisposeBag)
        
        //rxswift textfield.
        rxTextField = UITextField(frame: CGRect(x: 100, y: 200, width: 100, height: 40))
        rxTextField?.borderStyle = .roundedRect
        self.view.addSubview(rxTextField!)
        rxTextField?.rx.text.orEmpty.changed.subscribe {(text) in
            print("=========== testing change:  - \(self.rxTextField!.text ?? "")")
        }.disposed(by: rxDisposeBag)
        
        rxTextField!.rx.controlEvent(.editingDidEnd).subscribe{ _ in
            self.rxTextField!.endEditing(true)
        }.disposed(by: rxDisposeBag)
        
        //rxswift label. 没啥意义
        rxLabel = UILabel(frame: CGRect(x: 100, y: 400, width: 200, height: 40));
        view.addSubview(rxLabel!)
        rxLabel?.text = "HELLLO.."
        
        //rxswift KVO
        rxModel = YYRXObserveModel()
        rxModel?.gotoChange()
        print("=========== current name:", rxModel!.name)
        rxModel!.rx.observe(String.self, "name").subscribe { val in
            print("=========== newStr: ", val ?? " ")
        } onError: { error in
            print("=========== newStr error:", error)
        } onCompleted: {
            print("=========== newStr onCompleted=======")
        } onDisposed: {
            print("=========== newStr onDisposed=========")
        }.disposed(by: rxDisposeBag)
        
        //rxswift subscribe a model's properity update.
        rxModel?.age.subscribe(onNext: { newAge in
            DispatchQueue.main.async {
                self.rxLabel?.text = String(format: "%d", newAge)
            }
            print("=========== next age:", newAge)
        }).disposed(by: rxDisposeBag)
        
        //notification
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe { _ in
            print("=========== keyboardWillHideNotification =========")
        }.disposed(by: rxDisposeBag)

    }
    
    //rxswift network.
    func gotoReqeuestNetwork() {
        let url = URL(string: "https://www.baidu.com")
        URLSession.shared.rx.response(request: URLRequest(url: url!))
            .subscribe(onNext: { (response, data) in
                print("response ==== \(response)")
                print("data ===== \(data)")
            }, onError: { (error) in
                print("error ===== \(error)")
            }).disposed(by: rxDisposeBag)
    }

    //rxswift timer.
    func rxSwiftTimerGo() {
        let  timer = Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance)
        timer.subscribe { val in
            print("=========== timer val:", val)
        } onError: { error in
            print("=========== timer error:", error)
        } onCompleted: {
            print("=========== timer onCompleted")
        } onDisposed: {
            print("=========== timer onDisposed")
        }.disposed(by: rxDisposeBag)
    }
}

