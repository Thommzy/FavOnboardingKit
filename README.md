# FavOnboardingKit

FavOnboardingKit provides an onboarding flow that is simple and easy to implement.

<p align="center">
  <img src="https://raw.githubusercontent.com/Thommzy/FavOnboardingKit/main/video-preview.gif" alt="animated" />
</p>

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later


## Installation
There are two ways to use FavOnboardingKit in your project:
- using Swift Package Manager
- manual install (build frameworks or embed Xcode Project)

### Swift Package Manager

To integrate FavOnboardingKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Thommzy/FavOnboardingKit.git", .upToNextMajor(from: "1.0.0"))
]
```

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

### Manually

If you prefer not to use Swift Package Manager, you can integrate FavOnboardingKit into your project manually.

---

## Usage

### Quick Start

```swift
import UIKit
import FavOnboardingKit

class ViewController: UIViewController {
    private var onboardingKit: FavOnboardingKit?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.onboardingKit = FavOnboardingKit(slides:
                                                    [.init(image: UIImage(named: "imSlide1"), title: "Slide One"),
                                                     .init(image: UIImage(named: "imSlide2"), title: "Slide Two"),
                                                     .init(image: UIImage(named: "imSlide3"), title: "Slide Three"),
                                                     .init(image: UIImage(named: "imSlide4"), title: "Slide Four"),
                                                     .init(image: UIImage(named: "imSlide5"), title: "Slide Five")],
                                                  tintColor: UIColor(named: "maroonTint"),
                                                  themeFont: UIFont(name: "Copperplate Bold",
                                                                    size: 28)
                                                  ?? .systemFont(ofSize: 28,
                                                                 weight: .bold))
            self.onboardingKit?.delegate = self
            self.onboardingKit?.launchOnboarding(rootVc: self)
        }
    }
}

extension ViewController: FavOnboardingKitDelegate {
    func nextButtonDidTap(atIndex index: Int) {
        print("Next Button Tapped at \(index)")
    }
    func getStartedButtonDidTap() {
        debugPrint("Get Started Button Tapped")
        onboardingKit?.dismissOnboarding()
        
        onboardingKit = nil
        
        let foregroundScenes = UIApplication
            .shared
            .connectedScenes
            .filter { scene in
                scene.activationState == .foregroundActive
            }
        
        let window = foregroundScenes.map { scene in scene as? UIWindowScene }
            .map { windowScene in windowScene }
            .first??
            .windows
            .filter({ window in window.isKeyWindow })
            .first
        
        guard let uWindow = window else { return }
        uWindow.rootViewController = MainViewController()
        
        UIView.transition(with: uWindow,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

class MainViewController: UIViewController {
    let textLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension MainViewController {
    func setupViews() {
        view.backgroundColor = .white
        setupLabel()
    }
    
    func setupLabel() {
        view.addSubview(textLabel)
        textLabel.text = "Main ViewController"
        textLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}

```

## Credits

- Timothy Obeisun
