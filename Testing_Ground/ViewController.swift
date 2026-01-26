import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentedContainer: UIView!
    @IBOutlet weak var authSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Force user to choose (so valueChanged fires)
        authSegment.selectedSegmentIndex = UISegmentedControl.noSegment

        // Apply styling
        styleAuthSegment()

        // Hook up the action (you can also connect in storyboard)
        authSegment.addTarget(self, action: #selector(authSegmentChanged(_:)), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        authSegment.layer.cornerRadius = authSegment.bounds.height / 2
        authSegment.clipsToBounds = true
    }

    @objc private func authSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "toLogin", sender: self)
        case 1:
            performSegue(withIdentifier: "toSignUp", sender: self)
        default:
            break
        }
    }

    private func styleAuthSegment() {
        let purple = UIColor(red: 138.0/255.0, green: 96.0/255.0, blue: 176.0/255.0, alpha: 1.0) // #8A60B0

        authSegment.layer.borderWidth = 2
        authSegment.layer.borderColor = UIColor.white.cgColor
        authSegment.backgroundColor = .clear

        if #available(iOS 13.0, *) {
            authSegment.selectedSegmentTintColor = .white
        } else {
            authSegment.tintColor = .white
        }

        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]

        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: purple,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]

        authSegment.setTitleTextAttributes(normalAttrs, for: .normal)
        authSegment.setTitleTextAttributes(selectedAttrs, for: .selected)

        authSegment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        authSegment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        authSegment.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        authSegment.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
    }
}

