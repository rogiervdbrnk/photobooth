import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

/// Past gekozen fotofilters toe op originele vastgelegde foto's.
final class PhotoFilterService {
    private let context = CIContext()

    func applyFilter(_ option: PhotoFilterOption, to image: UIImage) -> UIImage {
        guard option != .original, let inputImage = CIImage(image: image) else {
            return image
        }

        let outputImage: CIImage?

        switch option {
        case .original:
            outputImage = inputImage
        case .mono:
            let filter = CIFilter.photoEffectMono()
            filter.inputImage = inputImage
            outputImage = filter.outputImage
        case .noir:
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = inputImage
            outputImage = filter.outputImage
        case .sepia:
            let filter = CIFilter.sepiaTone()
            filter.inputImage = inputImage
            filter.intensity = 0.9
            outputImage = filter.outputImage
        case .chrome:
            let filter = CIFilter.photoEffectChrome()
            filter.inputImage = inputImage
            outputImage = filter.outputImage
        case .fade:
            let filter = CIFilter.photoEffectFade()
            filter.inputImage = inputImage
            outputImage = filter.outputImage
        }

        guard
            let outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            return image
        }

        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}