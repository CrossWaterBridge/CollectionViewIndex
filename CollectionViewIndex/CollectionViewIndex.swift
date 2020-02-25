//
// Copyright (c) 2018 Hilton Campbell
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


func floor(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return floor(x * scale) / scale
}


func round(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return round(x * scale) / scale
}


func ceil(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return ceil(x * scale) / scale
}


func floorOdd(_ x: Int) -> Int {
    return x % 2 == 1 ? x : x - 1
}

public class CollectionViewIndex: UIControl {
    public var indexTitles = [String]() {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    var _selectedIndex: Int? {
        didSet {
            guard _selectedIndex != oldValue else {
                return
            }
            sendActions(for: .valueChanged)
            feedbackGenerator?.selectionChanged()
            feedbackGenerator?.prepare()
        }
    }
    public var selectedIndex: Int {
        return _selectedIndex ?? 0
    }
    
    let font = UIFont.boldSystemFont(ofSize: 11)

    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor(white: 1, alpha: 0.9)
        contentMode = .redraw
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
    enum IndexEntry {
        case text(String)
        case bullet
    }
    
    var titleHeight: CGFloat {
        return font.lineHeight
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.text(indexTitles[index]))
            }
        }
        
        let totalHeight = titleHeight * CGFloat(indexEntries.count)
        
        let context = UIGraphicsGetCurrentContext()!
        tintColor.setFill()
        
        var y = (bounds.height - totalHeight) / 2
        for indexEntry in indexEntries {
            switch indexEntry {
            case .text(let indexTitle):
                let attributedString = attributedStringForTitle(indexTitle)
                let width = attributedString.size().width
                let x = round((bounds.width - width) / 2, scale: contentScaleFactor)
                attributedString.draw(in: CGRect(x: x, y: round(y, scale: contentScaleFactor), width: width, height: titleHeight))
            case .bullet:
                let diameter: CGFloat = 6
                let x = round((bounds.width - diameter) / 2, scale: contentScaleFactor)
                let top = round(y + (titleHeight - diameter) / 2, scale: contentScaleFactor)
                context.fillEllipse(in: CGRect(x: x, y: top, width: diameter, height: diameter))
            }
            
            y += titleHeight
        }
    }
    
    func attributedStringForTitle(_ title: String) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: tintColor])
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)

        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        
        _selectedIndex = indexForTouch(touch)

        return true
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        _selectedIndex = indexForTouch(touch)

        return true
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        feedbackGenerator = nil
    }

    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)

        feedbackGenerator = nil
    }
    
    func indexForTouch(_ touch: UITouch) -> Int {
        let maxNumberOfIndexTitles = Int(floor(bounds.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        let numberOfIndexTitles: Int
        if indexTitles.count <= maxNumberOfIndexTitles {
            numberOfIndexTitles = indexTitles.count
        } else {
            numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
        }
        
        let totalHeight = titleHeight * CGFloat(numberOfIndexTitles)
        
        let location = touch.location(in: self)
        
        let index = Int((location.y - (bounds.height - totalHeight) / 2) / totalHeight * CGFloat(indexTitles.count))
        return max(0, min(indexTitles.count - 1, index))
    }
    
    public var preferredMaxLayoutHeight: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize : CGSize {
        return sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: preferredMaxLayoutHeight))
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxNumberOfIndexTitles = Int(floor(size.height / ceil(titleHeight, scale: contentScaleFactor)))
        
        var indexEntries = [IndexEntry]()
        if indexTitles.count <= maxNumberOfIndexTitles {
            indexEntries = indexTitles.map { .text($0) }
        } else {
            let numberOfIndexTitles = max(3, floorOdd(maxNumberOfIndexTitles))
            
            indexEntries.append(.text(indexTitles[0]))
            
            for i in 1...(numberOfIndexTitles / 2) {
                indexEntries.append(.bullet)
                
                let index = Int(round(Float(i) / (Float(numberOfIndexTitles / 2)) * Float(indexTitles.count - 1)))
                indexEntries.append(.text(indexTitles[index]))
            }
        }
        
        let width: CGFloat = indexEntries.reduce(0, { width, indexEntry in
            switch indexEntry {
            case .text(let indexTitle):
                return max(width, self.attributedStringForTitle(indexTitle).size().width)
            case .bullet:
                return width
            }
        })
        
        return CGSize(width: max(15, width + 4), height: size.height)
    }

}
