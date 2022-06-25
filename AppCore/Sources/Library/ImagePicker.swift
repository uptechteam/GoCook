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

    public func pickImage(on viewController: UIViewController) async -> UIImage? {
        guard
            let source = await chooseSource(on: viewController),
            await askPermission(on: viewController, source: source)
        else {
            return nil
        }

        return await showPicker(on: viewController, source: source)
    }

    // MARK: - Private methods

    private func chooseSource(on viewController: UIViewController) async -> UIImagePickerController.SourceType? {
        return await withCheckedContinuation { (continuation: CheckedContinuation<UIImagePickerController.SourceType?, Never>) in
            let alertController = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )

            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default,
                handler: { _ in continuation.resume(with: .success(.camera)) }
            )
            alertController.addAction(cameraAction)
            let galleryAction = UIAlertAction(
                title: "Gallery",
                style: .default,
                handler: { _ in continuation.resume(with: .success(.photoLibrary)) }
            )
            alertController.addAction(galleryAction)
            let okAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { _ in continuation.resume(with: .success(nil)) }
            )
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true)
        }
    }

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
        await withCheckedContinuation { continuation in
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
                    self?.completion(image as? UIImage)
                }
            }
        }
    }
}
