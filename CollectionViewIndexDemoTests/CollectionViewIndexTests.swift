//
// Copyright (c) 2015 Hilton Campbell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
import CollectionViewIndex
@testable import CollectionViewIndexDemo

class CollectionViewIndexTests: XCTestCase {
    
    var indexTitles = [String]()
    
    func testCollectionViewIndex() {
        self.indexTitles = ["A", "B", "C", "D", "E", "F", "G"]
        
        let height = 480
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: height), style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        let image1 = tableView.tableViewIndex!.snapshotImage()
        
        let collectionViewIndex = CollectionViewIndex(frame: .zero)
        collectionViewIndex.contentScaleFactor = UIScreen.mainScreen().scale
        collectionViewIndex.indexTitles = indexTitles
        collectionViewIndex.bounds.size = collectionViewIndex.sizeThatFits(CGSize(width: .max, height: height))
        let image2 = collectionViewIndex.snapshotImage()
        
        if !image1.isEqualToImage(image2, threshold: 1) {
            XCTFail("Snapshots do not match with index title \(indexTitles) and height \(height)")
        }
    }
    
}

extension CollectionViewIndexTests: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
}

extension CollectionViewIndexTests: UITableViewDelegate {}

extension UIView {
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        layoutIfNeeded()
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    var tableViewIndex: UIView? {
        layoutIfNeeded()
        
        for subview in subviews {
            if NSStringFromClass(subview.dynamicType) == "UITableViewIndex" {
                return subview
            } else if let tableViewIndex = subview.tableViewIndex {
                return tableViewIndex
            }
        }
        
        return nil
    }
    
}

extension UIImage {
    
    func isEqualToImage(image: UIImage, threshold: Int) -> Bool {
        if size != image.size {
            return false
        }
        
        let data1 = CFDataGetBytePtr(CGDataProviderCopyData(CGImageGetDataProvider(CGImage!)!))
        let data2 = CFDataGetBytePtr(CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage!)!))
        
        for i in 0..<(Int(size.width * scale * size.height * scale)) {
            let (r1, g1, b1, a1) = (data1[i * 4], data1[i * 4 + 1], data1[i * 4 + 2], data1[i * 4 + 3])
            let (r2, g2, b2, a2) = (data2[i * 4], data2[i * 4 + 1], data2[i * 4 + 2], data2[i * 4 + 3])
            
            if abs(Int(r1) - Int(r2)) > threshold {
                return false
            }
            if abs(Int(g1) - Int(g2)) > threshold {
                return false
            }
            if abs(Int(b1) - Int(b2)) > threshold {
                return false
            }
            if abs(Int(a1) - Int(a2)) > threshold {
                return false
            }
        }
        
        return true
    }
    
}
