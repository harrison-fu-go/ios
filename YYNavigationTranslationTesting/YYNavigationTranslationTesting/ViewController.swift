//
//  ViewController.swift
//  YYNavigationTranslationTesting
//
//  Created by HarrisonFu on 2022/7/6.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet var btn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func onClickBtn(_ sender: UIButton) {
//        let vc = ViewController1()
//        vc.modalPresentationStyle = .fullScreen
//        vc.transitioningDelegate = self
//        self.present(vc, animated: true, completion: nil)
        
        let rect = self.btn.frame
        let newRect = CGRect(x: rect.minX - 100, y: rect.minY - 300, width: rect.width, height: rect.height)
        UIView.animate(withDuration: 1) {
            self.btn.frame = newRect
        } completion: { _ in
            
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimateModel()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimateModel()
    }
}

