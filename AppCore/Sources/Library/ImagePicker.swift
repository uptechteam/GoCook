//
//  ImagePicker.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import DomainModels
import Helpers
import PhotosUI
import UIKit

@MainActor
public final class ImagePicker: NSObject {

    // MARK: - Properties

    private var completion: (UIImage?) -> Void = { _ in }

    // MARK: - Lifecycle

    deinit {
        print("Deinit", self)
    }

    // MARK: - Public methods

    public func pickImage(source: ImagePickerSource, on viewController: UIViewController) async -> UIImage? {
        switch source {
        case .camera:
            guard await checkCameraPermission(on: viewController) else {
                return nil
            }

            return await showCameraPicker(on: viewController)

        case .photoAlbum:
            return await showPhotoPicker(on: viewController)
        }
    }

    // MARK: - Private methods

    private func checkCameraPermission(on viewController: UIViewController) async -> Bool {
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

    private func showCameraPicker(on viewController: UIViewController) async -> UIImage? {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true)
        return await withCheckedContinuation { continuation in
            completion = { continuation.resume(with: .success($0)) }
        }
    }

    private func showPhotoPicker(on viewController: UIViewController) async -> UIImage? {
        let picker = PHPickerViewController(configuration: makePickerConfiguration())
        picker.delegate = self
        viewController.present(picker, animated: true)
        return await withCheckedContinuation { continuation in
            completion = { image in
                DispatchQueue.main.async {
                    continuation.resume(with: .success(image))
                }
            }
        }
    }

    private func makePickerConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        return configuration
    }

    private func handle(results: [PHPickerResult]) {
        guard
            let result = results.first,
            result.itemProvider.hasItemConformingToTypeIdentifier(Constants.imageID)
        else {
            completion(nil)
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            let resizedImage = (image as? UIImage)?.resizeImage(sizeLimit: Constants.limitedImageSize)
            Task { @MainActor [weak self] in
                self?.completion(resizedImage)
            }
        }
    }

    private func showSettings(on viewController: UIViewController) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            let alertController = UIAlertController(
                title: .imagePickerAlertSettingsTitle,
                message: .imagePickerAlertSettingsMessage,
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(
                    title: .imagePickerAlertSettingsCancel,
                    style: .cancel,
                    handler: { _ in continuation.resume(with: .success(())) }
                )
            )
            alertController.addAction(
                UIAlertAction(
                    title: .imagePickerAlertSettingsOpenCamera,
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
        picker.dismiss(animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.handle(results: results)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        completion(nil)
    }

    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        guard
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let resizedImage = image.resizeImage(sizeLimit: Constants.limitedImageSize)
        else {
            completion(nil)
            return
        }

        completion(resizedImage)
    }
}

// MARK: - Constants

extension ImagePicker {
    private enum Constants {
        static let limitedImageSize = Int(4 * 1024 * 1024)
        static let imageID = UTType.image.identifier
        static let videoID = UTType.movie.identifier
    }
}
