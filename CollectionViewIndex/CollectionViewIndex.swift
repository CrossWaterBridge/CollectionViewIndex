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

@warn_unused_result
func floor(x: CGFloat, scale: CGFloat) -> CGFloat {
    return floor(x * scale) / scale
}

@warn_unused_result
func round(x: CGFloat, scale: CGFloat) -> CGFloat {
    return round(x * scale) / scale
}

@warn_unused_result
func ceil(x: CGFloat, scale: CGFloat) -> CGFloat {
    return ceil(x * scale) / scale
}

@warn_unused_result
func floorOdd(x: Int) -> Int {
    return x % 2 == 1 ? x : x - 1
}

public class CollectionViewIndex: UIControl {
    
    public var indexTitles = [String]() {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    var _selectedIndex: Int?
    public var selectedIndex: Int {
        return _selectedIndex ?? 0
    }
    
    let font = UIFont.boldSystemFontOfSize(11)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.9)
        contentMode = .Redraw
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
    enum IndexEntry {
        case Text(String)
        case Bullet
    }
    
    var titleHeight: CGFloat {
        return font.lineHeight
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .Text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.Text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.Bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.Text(indexTitles[index]))
            }
        }
        
        let totalHeight = titleHeight * CGFloat(indexEntries.count)
        
        let context = UIGraphicsGetCurrentContext()!
        tintColor.setFill()
        
        var y = (bounds.height - totalHeight) / 2
        for indexEntry in indexEntries {
            switch indexEntry {
            case .Text(let indexTitle):
                let attributedString = attributedStringForTitle(indexTitle)
                let width = attributedString.size().width
                let x = round((bounds.width - width) / 2, scale: contentScaleFactor)
                attributedString.drawInRect(CGRect(x: x, y: round(y, scale: contentScaleFactor), width: width, height: titleHeight))
            case .Bullet:
                let diameter: CGFloat = 6
                let x = round((bounds.width - diameter) / 2, scale: contentScaleFactor)
                let top = round(y + (titleHeight - diameter) / 2, scale: contentScaleFactor)
                CGContextFillEllipseInRect(context, CGRect(x: x, y: top, width: diameter, height: diameter))
            }
            
            y += titleHeight
        }
    }
    
    func attributedStringForTitle(title: String) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: tintColor])
    }
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        let selectedIndex = indexForTouch(touch)
        if _selectedIndex != selectedIndex {
            _selectedIndex = selectedIndex
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        let selectedIndex = indexForTouch(touch)
        if _selectedIndex != selectedIndex {
            _selectedIndex = selectedIndex
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return true
    }
    
    func indexForTouch(touch: UITouch) -> Int {
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        let numberOfIndexTitles: Int
        if indexTitles.count <= maxNumberOfIndexTitles {
            numberOfIndexTitles = indexTitles.count
        } else {
            numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
        }
        
        let totalHeight = titleHeight * CGFloat(numberOfIndexTitles)
        
        let location = touch.locationInView(self)
        
        let index = Int((location.y - (bounds.height - totalHeight) / 2) / totalHeight * CGFloat(indexTitles.count))
        return max(0, min(indexTitles.count - 1, index))
    }
    
    public var preferredMaxLayoutHeight: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return sizeThatFits(CGSize(width: .max, height: preferredMaxLayoutHeight))
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        let maxNumberOfIndexTitles = Int(floor(size.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .Text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.Text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.Bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.Text(indexTitles[index]))
            }
        }
        
        let width: CGFloat = indexEntries.reduce(0, combine: { width, indexEntry in
            switch indexEntry {
            case .Text(let indexTitle):
                return max(width, self.attributedStringForTitle(indexTitle).size().width)
            case .Bullet:
                return width
            }
        })
        
        return CGSize(width: max(15, width + 4), height: size.height)
    }

}
