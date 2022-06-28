//
//  ImagePicker.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Helpers
import PhotosUI
import UIKit

@MainActor
public final class ImagePicker: NSObject {

    private var completion: (UIImage?) -> Void = { _ in }

    // MARK: - Lifecycle

    deinit {
        print("Deinit", self)
    }

    // MARK: - Public methods

    public func pickImage(
        source: UIImagePickerController.SourceType,
        on viewController: UIViewController
    ) async -> UIImage? {
        guard await askPermission(on: viewController, source: source) else {
            return nil
        }

        return await showPicker(on: viewController, source: source)
    }

    // MARK: - Private methods

    private func askPermission(
        on viewController: UIViewController,
        source: UIImagePickerController.SourceType
    ) async -> Bool {
        guard source == .camera else {
            return true
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)

        case .authorized:
            return true

        default:
            await showSettings(on: viewController)
            return false
        }
    }

    private func showPicker(on viewController: UIViewController, source: UIImagePickerController.SourceType) async -> UIImage? {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)
        return await withCheckedContinuation { continuation in
            completion = { continuation.resume(with: .success($0)) }
        }
    }

    private func showSettings(on viewController: UIViewController) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            let alertController = UIAlertController(
                title: "Allow camera access",
                message: "Enable access so you can upload photos.",
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: { _ in continuation.resume(with: .success(())) }
                )
            )
            alertController.addAction(
                UIAlertAction(
                    title: "Open camera",
                    style: .default,
                    handler: { _ in
                        let settingURL = URL(string: UIApplication.openSettingsURLString)!
                        UIApplication.shared.open(settingURL, options: [:])
                        continuation.resume(with: .success(()))
                    }
                )
            )

            viewController.present(alertController, animated: true)
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ImagePicker: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard
            let result = results.first,
            result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
        else {
            completion(nil)
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    let resizedImage = (image as? UIImage)?.resizeImage(targetSize: CGSize(width: 400, height: 400))
                    self?.completion(resizedImage)
                }
            }
        }
    }
}
