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
import QuartzCore


let reuseIdentifier = "ColorSwatchCell"

class ColorSwatchCollectionViewController: UICollectionViewController, ColorSwatchSelector {
  
  var swatchList: ColorSwatchList?
  var swatchSelectionDelegate: ColorSwatchSelectionDelegate?
  
  var currentCellContentTransform = CGAffineTransformIdentity
    
  // Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    if swatchList == nil {
      swatchList = ColorSwatchList()
      collectionView(collectionView!, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
    }
  }
  
  // #pragma mark UICollectionViewDataSource
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return swatchList?.colorSwatches.count ?? 0
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
  let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    // Configure the cell
    if let swatchCell = cell as? ColorSwatchCollectionViewCell,
      let swatch = swatchList?.colorSwatches[indexPath.item] {
        swatchCell.resetCell(swatch)
    }
    return cell
  }
  
  // #pragma mark <UICollectionViewDelegate>
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let swatch = swatchList?.colorSwatches[indexPath.item] {
      swatchSelectionDelegate?.didSelect(swatch, sender: self)
    }
  }
  
    // for iphones
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    }
//    
//    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
//        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
//            if newCollection.verticalSizeClass == .Compact {
//                flowLayout.scrollDirection = .Vertical
//            } else {
//                flowLayout.scrollDirection = .Horizontal
//            }
//        }
        // 1
        // calculate the inverse transform. targetTransform() is a new property of UIViewControllerTransitionCoordinator; it returns a CGAffineTransform that represents the destination transform associated with the current transition
        let targetTForm = coordinator.targetTransform()
        let inverseTForm = CGAffineTransformInvert(targetTForm)
        println("the target transform is \(targetTForm) , the inverse TForm is \(inverseTForm)")
        // 2
        // animateAlongsideTransition:completion: lets you specify an animation block to perform alongside the existing transition. You're not using the animation block here since you need to wait for AutoLayout to calculate the correct size of the new layout. Instead, you'll use the completion block that is called once the transition has finished.
        coordinator.animateAlongsideTransition({ (_) -> Void in
            // Empty
            
        }, completion: { (_) -> Void in
            // 3
            // Apply the inverse transform to the collection views layer. Since you're using AutoLayout, it's not possible to simply use the transform property of the view. Luckily, applying a transform to the underlying layer works just fine
            self.view.layer.transform = CATransform3DConcat(self.view.layer.transform, CATransform3DMakeAffineTransform(inverseTForm))
            // 4
            // Update the bounds of the view. If the device rotation is 90 degrees, that is, portrait to landscape or vice versa, then you need to switch the width and the height
            if abs(atan2(Double(targetTForm.b), Double(targetTForm.a)) / M_PI) < 0.9 {
                self.view.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.size.height, height: self.view.bounds.size.width)
            }
            // 5
            // The collection view is now in the correct location, is of the correct size and scrolls in the correct direction. However, the orientation of the cells is still incorrect. Iterate through the visible cells and animate each of them to the correct orientation.
            self.currentCellContentTransform = CGAffineTransformConcat(self.currentCellContentTransform, targetTForm)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                for cell in self.collectionView?.visibleCells() as! [UICollectionViewCell] {
                    cell.contentView.transform = self.currentCellContentTransform
                }
            }, completion: nil)
        })
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.transform = currentCellContentTransform
    }
    
    //MARK: for iPad
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            // Find the restrictive dimension
            let minDimension = min(CGRectGetHeight(view.bounds), CGRectGetWidth(view.bounds))
            println("the view bounds is \(view.bounds)")
            let newItemSize = CGSize(width: minDimension, height: minDimension)
            if flowLayout.itemSize != newItemSize {
                flowLayout.itemSize = newItemSize
                flowLayout.invalidateLayout()
            }
        }
    }
    
    
}

