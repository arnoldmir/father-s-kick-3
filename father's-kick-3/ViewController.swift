import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var animatedView: UIView!
    @IBOutlet private weak var slider: UISlider!
    
    private var animator: UIViewPropertyAnimator?
    private var isFirstAnimate = true
    private var animatedViewInitialWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        animatedViewInitialWidth = animatedView.frame.width
        animatedView.layer.cornerRadius = 4
    }
    
    private func setupAnimation() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            let updatedCenterX = self.view.frame.width - self.view.directionalLayoutMargins.trailing.native - (self.animatedViewInitialWidth * 1.5 / 2.0)
            self.animatedView.center.x = updatedCenterX
            self.animatedView.transform = .init(rotationAngle: .pi / 2).scaledBy(x: 1.5, y: 1.5)
        }
        animator?.addCompletion({ [weak self] _ in
            guard let self else { return }
            
            self.animator = nil
            self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                self.animatedView.center.x = self.view.directionalLayoutMargins.leading.native + self.animatedViewInitialWidth / 2.0
                self.animatedView.transform = .identity
            }
            self.animator?.isReversed = true
        })
    }
    
    @IBAction private func valueChanged(_ sender: UISlider) {
        animator?.fractionComplete = CGFloat(sender.value)
    }
    
    @IBAction private func sliderPressed(_ sender: UISlider) {
        if !isFirstAnimate {
            animator?.stopAnimation(true)
            setupAnimation()
            animator?.startAnimation()
        } else {
            animator?.startAnimation()
        }
        isFirstAnimate = false
        slider.setValue(1, animated: true)
    }
}
