import UIKit

public protocol FavOnboardingKitDelegate: AnyObject {
    func nextButtonDidTap(atIndex index: Int)
    func getStartedButtonDidTap()
}

public class FavOnboardingKit {
    
    private var slides: [Slide]
    private var tintColor: UIColor?
    private var rootVc: UIViewController?
    
    public weak var delegate: FavOnboardingKitDelegate?
    
    private lazy var onboardingViewController: OnboardingViewController = {
        let controller = OnboardingViewController(slides: slides, tintColor: tintColor)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            self?.delegate?.nextButtonDidTap(atIndex: index)
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.delegate?.getStartedButtonDidTap()
        }
        return controller
    }()
    
    public init(slides: [Slide], tintColor: UIColor?) {
        self.slides = slides
        self.tintColor = tintColor
    }
    
    public func launchOnboarding(rootVc: UIViewController) {
        self.rootVc = rootVc
        rootVc.present(onboardingViewController,
                       animated: true,
                       completion: nil)
    }
    
    public func dismissOnboarding() {
        onboardingViewController.stopAnimation()
        if rootVc?.presentedViewController == onboardingViewController {
            onboardingViewController.dismiss(animated: true )
        }
    }
}
