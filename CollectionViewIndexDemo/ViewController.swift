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

import UIKit
import CollectionViewIndex

class ViewController: UIViewController {
    
    lazy var collectionViewIndex: CollectionViewIndex = {
        let collectionViewIndex = CollectionViewIndex()
        collectionViewIndex.indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
        collectionViewIndex.addTarget(self, action: #selector(selectedIndexDidChange), forControlEvents: .ValueChanged)
        collectionViewIndex.translatesAutoresizingMaskIntoConstraints = false
        return collectionViewIndex
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        view.addSubview(collectionViewIndex)
        
        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "bottomLayoutGuide": bottomLayoutGuide,
            "collectionViewIndex": collectionViewIndex,
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[collectionViewIndex]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][collectionViewIndex][bottomLayoutGuide]", options: [], metrics: nil, views: views))
    }
    
    func selectedIndexDidChange(collectionViewIndex: CollectionViewIndex) {
        title = collectionViewIndex.indexTitles[collectionViewIndex.selectedIndex]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionViewIndex.preferredMaxLayoutHeight = view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length
    }

}

