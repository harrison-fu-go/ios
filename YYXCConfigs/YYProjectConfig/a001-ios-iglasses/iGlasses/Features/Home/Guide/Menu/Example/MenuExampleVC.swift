//
//  MenuExampleVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit

class MenuExampleVC: UIViewController {
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView!
    var iTitle: String?
    init(title:String) {
        super.init(nibName: nil, bundle: nil)
        self.iTitle = title
    }
    
    //swiftlint:disable unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.titleLable.text = self.iTitle
        self.naviBar.enableSearch(isEnable: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
