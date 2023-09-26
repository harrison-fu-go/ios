//
//  ModifyDeviceNameVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit
//swiftlint:disable attributes explicit_init force_unwrapping
class ModifyDeviceNameVC: UIViewController {

    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView!
    @IBOutlet var textInputTF: UITextField!
    var mineRootViewModel: MineRootViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.titleLable.text = "更改设备名称"
        
        //text input.
        textInputTF.delegate = self
        textInputTF.addTarget(self, action: #selector(changedTextField), for: .editingChanged)
        textInputTF.returnKeyType = .done
        textInputTF.keyboardType = .namePhonePad
        textInputTF.placeholder = UserDefaults.standard.string(forKey: "A001DeviceName") ?? USER_BASE.defaultName
        textInputTF.becomeFirstResponder()
        //add custom tap.
        let tap = UITapGestureRecognizer.init(target:self, action: #selector(tapEmptySpce))
        self.view.addGestureRecognizer(tap)
        //save.
        self.naviBar.addSaveBlock {
            
            guard let value = self.textInputTF.text else {
                return
            }
            
            if value.count > 18 {
                ZKToast.toast("设置失败：长度大于18", duration: 2)
                return
            }
            
            UserDefaults.standard.setValue(value, forKey: "A001DeviceName")
            self.mineRootViewModel?.refreshDeviceName()
            self.textInputTF.placeholder = value
            self.textInputTF.text = ""
            self.naviBar.changeSaveState(enable: false)
            self.textInputTF.endEditing(true)
            ZKToast.toast("设置完成", duration: 1)
        }
    }
    
    @objc func tapEmptySpce() {
        textInputTF.endEditing(true)
    }
}

extension ModifyDeviceNameVC: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let value = textField.text
//        if value != nil && !(value!.isEmpty) {
//            UserDefaults.standard.setValue(value, forKey: "A001DeviceName")
//            mineRootViewModel?.refreshDeviceName()
//        }
//    }
    
    @objc func changedTextField(textField: UITextField) {
        let value = textField.text
        naviBar.changeSaveState(enable: (value != nil && !(value!.isEmpty)))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
