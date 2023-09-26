//
//  ExampleAViewController.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import UIKit

class ExampleAViewController: NibViewController {
    let viewModel: ExampleAViewModel

    init(viewModel: ExampleAViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: ExampleAViewModel, _ coder: NSCoder? = nil) {
        self.viewModel = viewModel
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }

    required convenience init(coder: NSCoder) {
        self.init(viewModel: ExampleAViewModel(), coder)
    }

//    required init?(coder: NSCoder) {
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
