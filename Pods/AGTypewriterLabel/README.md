# AGTypewriterLabel ![Language](https://img.shields.io/badge/iOS-Swift4-orange.svg)

AGTypewriterLabel is a UI Label that can animate the display of it's text character by character. How fast it goes and when it pauses is completely up to you! It's perfect for use in games, instructional manuals, and anywhere else you can see fit!

## Installation

### Manual

0. Copy and paste `AGTypewriterLabel.swift` to your xcode project.

### [CocoaPods](https://cocoapods.org/pods/AGTypewriterLabel)

1. Install the latest release of CocoaPods: `gem install cocoapods`
2. Add this line to your Podfile: `pod 'AGTypewriterLabel'`
3. Install the pod: `pod install`


## Usage

1. Change the class of a label from UILabel to AGTypewriterLabel;

2. Use the `AGTypewriterLabel.addAnimation()` function to add animations to the label

3. Call `AGTypewriterLabel.startAnimation()` to start the animation!

4. **Optional**: Implement `AGTypewriterLabelDelegate` and set your label's delegate to know when the label is done animating


## Sample Code

```swift

class StoryViewController: UIViewController, AGTypewriterLabelDelegate {

    @IBOutlet weak var typingLabel: AGTypewriterLabel!


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        typingLabel.delegate = self

        typingLabel.addAnimation(.text(string: "Hello...", interval: 0.2))
        typingLabel.addAnimation(.pause(length: 1.0))
        typingLabel.addAnimation(.text(string: "World", interval: 0.1))
        typingLabel.addAnimation(.pause(length: 1.0))
        typingLabel.addAnimation(.text(string: "?", interval: 0))
        
        typingLabel.startAnimation()
    }

    func didFinishAnimating(label: AGTypewriterLabel) {
        // Do Something
    }
}
```


