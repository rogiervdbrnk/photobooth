import SwiftUI
import AVFoundation

/// Wikkelt AVCaptureVideoPreviewLayer in een SwiftUI View voor camerapreview.
struct CameraPreviewView: UIViewRepresentable {

    let captureSession: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.session = captureSession
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    // MARK: - UIView subclass

    final class PreviewUIView: UIView {

        var session: AVCaptureSession? {
            didSet { previewLayer.session = session }
        }

        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        var previewLayer: AVCaptureVideoPreviewLayer {
            // swiftlint:disable:next force_cast
            layer as! AVCaptureVideoPreviewLayer
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = .black
            previewLayer.frame = bounds
            previewLayer.videoGravity = .resizeAspect
            previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
            previewLayer.connection?.isVideoMirrored = true
        }
    }
}
