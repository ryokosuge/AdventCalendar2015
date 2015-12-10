//
//  ViewController.swift
//  SampleInfinityCollectionView
//
//  Created by kosuge on 2015/12/10.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: InfinityCollectionView!
    
    private let EnlargementFactor: Int = 5
    private let ContentMargin: CGFloat = 16.0
    private let CellIdentifier = "CollectionViewCell"
    private let items = [1, 2, 3, 4, 5]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: ContentMargin, left: ContentMargin, bottom: ContentMargin, right: ContentMargin)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ContentMargin
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ContentMargin
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewHeight = collectionView.frame.height
        let height = viewHeight - (ContentMargin * 2)
        let width = height / 2
        return CGSize(width: width, height: height)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count * EnlargementFactor
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row % items.count
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.setIndex(index)
        return cell
    }
    
}

extension ViewController {
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.factor = EnlargementFactor
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: CellIdentifier)
    }
    
}