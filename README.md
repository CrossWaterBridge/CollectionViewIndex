# CollectionViewIndex

[![Pod Version](https://img.shields.io/cocoapods/v/CollectionViewIndex.svg)](CollectionViewIndex.podspec)
[![Pod License](https://img.shields.io/cocoapods/l/CollectionViewIndex.svg)](LICENSE)
[![Pod Platform](https://img.shields.io/cocoapods/p/CollectionViewIndex.svg)](CollectionViewIndex.podspec)

View that replicates the built in `UITableView` section index, but for use in `UICollectionView`.

`UITableView` uses a private class called `UITableViewIndex` to provide this behavior. `CollectionViewIndex`
follows the same naming convention.

### Installation

Install with Cocoapods by adding the following to your Podfile:

```ruby
use_frameworks!

pod 'CollectionViewIndex'
```

Then run:

```bash
pod install
```

### Usage

Create an instance of `CollectionViewIndex` and add it to the superview of, and in front of, your
`UICollectionView` instance:

```swift
override func viewDidLoad() {
	super.viewDidLoad()
	
	view.addSubview(collectionView)
	view.addSubview(collectionViewIndex)
	
	let views: [String: AnyObject] = [
		"topLayoutGuide": topLayoutGuide,
		"bottomLayoutGuide": bottomLayoutGuide,
		"collectionView": collectionView,
		"collectionViewIndex": collectionViewIndex,
	]
	
	view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: [], metrics: nil, views: views))
	view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
	view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[collectionViewIndex]|", options: [], metrics: nil, views: views))
	view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][collectionViewIndex][bottomLayoutGuide]", options: [], metrics: nil, views: views))
}
```

Like `UILabel`, `CollectionViewIndex` needs to know its height before it can know how wide it must be. When
using Auto Layout, you can set the object’s `preferredMaxLayoutHeight` like so:

```swift
override func viewWillLayoutSubviews() {
	super.viewWillLayoutSubviews()
	
	collectionViewIndex.preferredMaxLayoutHeight = view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length
}
```

Your collection view layout may need to know the width of the `CollectionViewIndex` object. If so, you can inform it when layout completes:

```swift
override func viewDidLayoutSubviews() {
	super.viewDidLayoutSubviews()
	
	collectionViewLayout.indexWidth = collectionViewIndex.bounds.width
}
```

`CollectionViewIndex` sends a `UIControlEvent.ValueChanged` event when the user interacts with it. You
register the target-action method in this way:

```swift
collectionViewIndex.addTarget(self, action: "selectedIndexDidChange:", forControlEvents: .ValueChanged)

func selectedIndexDidChange(collectionViewIndex: CollectionViewIndex) {
	print("User selected index \(collectionViewIndex.selectedIndex)")
}
```

You’ll probably want to jump to a section of the collection view in response to that event. If your section headers
pin to visible bounds, be sure to take them into account when scrolling.

### License

CollectionViewIndex is released under the MIT license. See LICENSE for details.