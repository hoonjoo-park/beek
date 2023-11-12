import UIKit
import AVFoundation

class BeekScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let navBar = UIView()
    let closeButton = UIButton()
    let closeIcon = UIImageView(image: UIImage(named: "close"))
    let scanningBox = UIView()
    let backgroundView = UIView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAVCaptureSession()
        configureViewController()
        configureNavigationBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMask()
    }
    
    
    private func configureAVCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    
    private func configureNavigationBar() {
        let window = UIApplication.shared.windows.first
        let insetTop = window?.safeAreaInsets.top ?? 0
        
        view.addSubview(navBar)
        
        navBar.addSubview(closeButton)
        navBar.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        
        closeButton.addSubview(closeIcon)
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44 + view.safeAreaInsets.top + insetTop),
            
            closeButton.topAnchor.constraint(equalTo: navBar.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 15),
            
            closeIcon.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            closeIcon.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: insetTop / 2)
        ])
    }
    
    
    private func configureViewController() {
        view.addSubview(backgroundView)
        view.addSubview(scanningBox)
        
        view.backgroundColor = .black
        backgroundView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        
        scanningBox.translatesAutoresizingMaskIntoConstraints = false
        scanningBox.backgroundColor = .clear
        scanningBox.layer.cornerRadius = 12
        scanningBox.layer.borderWidth = 5
        scanningBox.layer.borderColor = UIColor(r: 255, g: 85, b: 0, a: 1).cgColor
        
        NSLayoutConstraint.activate([
            scanningBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanningBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanningBox.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            scanningBox.heightAnchor.constraint(equalTo: scanningBox.widthAnchor, multiplier: 0.5),
        ])
    }
    
    
    private func updateMask() {
        backgroundView.frame = view.layer.bounds
        
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        let maskRect = scanningBox.frame

        path.addRect(view.bounds)
        path.addRoundedRect(in: maskRect, cornerWidth: scanningBox.layer.cornerRadius, cornerHeight: scanningBox.layer.cornerRadius)

        maskLayer.path = path
        maskLayer.fillRule = .evenOdd

        backgroundView.layer.mask = maskLayer
    }
    
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func failed() {
        let alert = UIAlertController(title: "Scanning Failed", message: "Please Try Again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
        captureSession = nil
    }
}

