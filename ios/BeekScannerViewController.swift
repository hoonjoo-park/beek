import UIKit

class BeekScannerViewController: UIViewController {
    let label = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }

    private func configureViewController() {
        self.view.addSubview(label)
        
        label.text = "Beek Scanner"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }

    private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
