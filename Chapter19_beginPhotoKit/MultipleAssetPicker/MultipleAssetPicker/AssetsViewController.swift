/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Photos

class AssetsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  let AssetCollectionViewCellReuseIdentifier = "AssetCell"
  
  var assetsFetchResults: PHFetchResult?
  var selectedAssets: SelectedAssets!
  
  private var assetThumbnailSize = CGSizeZero
  
  // MARK: UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView!.allowsMultipleSelection = true
  }

  override func viewWillAppear(animated: Bool)  {
    super.viewWillAppear(animated)
    
    // Calculate Thumbnail Size
    let scale = UIScreen.mainScreen().scale
    let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    assetThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    
    collectionView!.reloadData()
    updateSelectedItems()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    collectionView!.reloadData()
    updateSelectedItems()
  }
  
  // MARK: Private
  func currentAssetAtIndex(index:NSInteger) -> PHAsset {
    if let fetchResult = assetsFetchResults {
      return fetchResult[index] as! PHAsset
    } else {
      return selectedAssets.assets[index]
    }
  }
  
  func updateSelectedItems() {
    // Select the selected items
    if let fetchResult = assetsFetchResults {
      // 1
      // if you're an album, will find the selected assets by iterating through every one and check if they exist in the displayed fetch result
      for asset in selectedAssets.assets {
        let index = fetchResult.indexOfObject(asset)
        if index != NSNotFound {
          let indexPath = NSIndexPath(forItem: index, inSection: 0)
          collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        }
      }
    } else {
      // 2
      for i in 0..<selectedAssets.assets.count {
        let indexPath = NSIndexPath(forItem: i, inSection: 0)
        collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
      }
    }
  }
  
  // MARK: UICollectionViewDelegate
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)  {
    // Update selected Assets
    let asset = currentAssetAtIndex(indexPath.item)
    selectedAssets.assets.append(asset)
  }
  
  override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)  {
    // Update selected Assets
    // 1
    // Remove the asset from the array.
    let assetToDelete = currentAssetAtIndex(indexPath.item)
    selectedAssets.assets = selectedAssets.assets.filter({ (asset) -> Bool in
      !(asset == assetToDelete)
    })
    // 2
    // remove the asset from the collection view if you're displaying selected assets
    if assetsFetchResults == nil {
      collectionView.deleteItemsAtIndexPaths([indexPath])
    }
  }
  
  
  // MARK: UICollectionViewDataSource
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let fetchResult = assetsFetchResults {
      return fetchResult.count
    } else if selectedAssets != nil {
      return selectedAssets.assets.count
    }
    return 0
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AssetCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! AssetCell
    
    // Populate Cell
    // 1
    // Due to the asynchronous API for loading content, you need to make sure a cell has not been reused before updating the image.
    let reuseCount = ++cell.reuseCount
    let asset = currentAssetAtIndex(indexPath.item)
    // 2
    let options = PHImageRequestOptions()
    options.networkAccessAllowed = true
    // 3
    // The Photos Framework provides a low quality version of the asset if it’s immediately available
    PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: assetThumbnailSize, contentMode: .AspectFill, options: options) { (result, info) -> Void in
      if reuseCount == cell.reuseCount {
        cell.imageView.image = result
      }
    }
    return cell
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    var thumbsPerRow: Int
    switch collectionView.bounds.size.width {
    case 0..<400:
      thumbsPerRow = 4
    case 400..<600:
      thumbsPerRow = 5
    case 600..<800:
      thumbsPerRow = 6
    case 800..<1200:
      thumbsPerRow = 7
    default:
      thumbsPerRow = 4
    }
    let width = collectionView.bounds.size.width / CGFloat(thumbsPerRow)
    return CGSize(width: width,height: width)
  }
}
