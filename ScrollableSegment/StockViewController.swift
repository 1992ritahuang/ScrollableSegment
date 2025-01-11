//
//  StockViewController.swift
//  ScrollableSegment
//
//  Created by Rita Huang on 2025/1/11.
//

import UIKit

class StockViewController: UIPageViewController {
    var currentIndex:Int = 0 {
        willSet {
            //bofore currentIndex change
            if let cell:SegmentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? SegmentCell {
                cell.titleLabel.textColor = UIColor.lightGray
            }
        }
        didSet {
            //after currentIndex changed
            if let cell:SegmentCell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? SegmentCell {
                cell.titleLabel.textColor = UIColor.darkGray
            }
            navigationItem.title = segmentItems[currentIndex]
        }
    }
    
    var collectionView: UICollectionView!
    let segmentItems = ["seg1", "seg2", "seg3", "seg4", "seg5", "seg6", "seg7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tab1"
        navigationItem.title = segmentItems[currentIndex]
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        setupCollectionView()
        
        //setup page content
        dataSource = self
        if let initialViewController = viewControllerAtIndex(0) {
            setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

//MARK: CollectionView
extension StockViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 54.0), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        collectionView.register(SegmentCell.self, forCellWithReuseIdentifier: "SegmentCell")
        
        view.addSubview(collectionView)
        setupCollectionViewConstraints()
    }
    
    func setupCollectionViewConstraints() {
        let topConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leadingConstraint = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 54.0)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
    }
    
    // Collection View Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
        cell.titleLabel.text = segmentItems[indexPath.item]
        cell.titleLabel.textColor = (indexPath.item == currentIndex) ? UIColor.darkGray : UIColor.lightGray
        
        return cell
    }
    
    // Collection View Delegate Flow Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth(for: segmentItems[indexPath.item])
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    private func calculateWidth(for text: String) -> CGFloat {
        let padding = 10.0
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: collectionView.bounds.height)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)],
                                            context: nil)
        return boundingBox.width + (padding * 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let initialViewController = viewControllerAtIndex(indexPath.item) {
            //set page content to the StockViewController
            setViewControllers([initialViewController], direction: (indexPath.item < currentIndex) ? .reverse : .forward, animated: true) { complete in
                if (complete) {
                    self.currentIndex = indexPath.item
                }
            }
        }
    }
}

//MARK: PageController
extension StockViewController: UIPageViewControllerDataSource, PageSettingDelegate {
    //PageSettingDelegate function
    func updateCurrentIndex(index: Int) {
        //get current index from pageContentVC
        self.currentIndex = index
    }

    //init PageContentViewController function
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if index < 0 || index >= segmentItems.count {
            return nil
        }
        
        let contentViewController = PageContentViewController()
        contentViewController.pageIndex = index
        contentViewController.pageDelegate = self
        return contentViewController
    }
    
    // UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let contentViewController = viewController as? PageContentViewController {
            let pageIndex = contentViewController.pageIndex
            if pageIndex > 0 {
                return viewControllerAtIndex(pageIndex - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let contentViewController = viewController as? PageContentViewController {
            let pageIndex = contentViewController.pageIndex
            if pageIndex < segmentItems.count - 1 {
                return viewControllerAtIndex(pageIndex + 1)
            }
        }
        return nil
    }
}
