//
//  CollectionCardVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/6/26.
//

import UIKit
import SnapKit
class CollectionCardVC: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout {
    let pageControl = UIPageControl()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dataSource = ["app1", "app2", "app3"]
    var scrollIndex = 0
    let pageTotalCount = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
            make.height.equalTo(561.scaleX414)
        }
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionCardCell.self, forCellWithReuseIdentifier: "collectionCardCell");
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        //page control
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-88)
            make.height.equalTo(50)
            make.width.equalTo(collectionView)
        }
        pageControl.numberOfPages = pageTotalCount
        pageControl.currentPage = self.scrollIndex
        pageControl.currentPageIndicatorTintColor = UIColor(hex: 0x06080A)
        pageControl.pageIndicatorTintColor = UIColor(hex: 0x06080A, alpha: 0.3)
        
        
        //next
        let nextButton = UIButton(type: .custom)
        self.view.addSubview(nextButton)
        nextButton.backgroundColor = .clear
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(gotoNext(_:)), for: .touchUpInside)
        nextButton.layer.cornerRadius = 8.0
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(collectionView.snp.right).offset(-48)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-24)
            make.height.equalTo(50)
            make.width.equalTo(65)
        }
        
        //previous
        let previousButton = UIButton(type: .custom)
        self.view.addSubview(previousButton)
        previousButton.backgroundColor = .clear
        previousButton.setTitle("Previous", for: .normal)
        previousButton.addTarget(self, action: #selector(gotoPrevious(_:)), for: .touchUpInside)
        previousButton.layer.cornerRadius = 8.0
        previousButton.snp.makeConstraints { make in
            make.right.equalTo(nextButton.snp.left).offset(-8)
            make.centerY.equalTo(nextButton.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    @objc func gotoNext(_ sender: Any) {
        if scrollIndex == self.pageTotalCount - 1 {
            return
        }
        scrollIndex = scrollIndex + 1
        self.pageControl.currentPage = scrollIndex
        collectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        
    }
    
    @objc func gotoPrevious(_ sender: Any) {
        if scrollIndex == 0 {
            return
        }
        scrollIndex = scrollIndex - 1
        self.pageControl.currentPage = scrollIndex
        collectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageTotalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCardCell", for: indexPath)
        if let cell = cell as? CollectionCardCell {
            cell.imgView.image = UIImage(named: dataSource[indexPath.row % 3])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

class CollectionCardCell: UICollectionViewCell {
    
    let imgView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawUI() {
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(366.scaleX414)
            make.height.equalTo(561.scaleX414)
        }
        imgView.layer.cornerRadius = 20.scaleX414
        imgView.clipsToBounds = true
        imgView.backgroundColor = .clear
        imgView.contentMode = .scaleAspectFill
    }
}
