import UIKit
import AVFoundation

class BeekScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let customNavBar = UIView()
    let closeButton = UIButton()
    let closeImage = UIImageView(image: UIImage(systemName: "xmark"))
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        captureSession.startRunning()
        
        configureViewController()
    }
    
    private func configureViewController() {
        [customNavBar].forEach { self.view.addSubview($0)}
        customNavBar.addSubview(closeButton)
        closeButton.addSubview(closeImage)
        
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        closeImage.tintColor = .white
        
        view.backgroundColor = .black
        
        customNavBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: customNavBar.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            
            closeImage.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            closeImage.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
        ])
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

