//
//  ImagePicker.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Photos
import UIKit

enum ImagePickerError: Error {
    case deniedPermission
}

@MainActor
final class ImagePicker: NSObject {

    private var completion: (UIImage?) -> Void = { _ in }

    // MARK: - Lifecycle

    deinit {
        print("Deinit", self)
    }

    // MARK: - Public methods

    func pickImage(on viewController: UIViewController) async -> UIImage? {
        let isPermitted = await askPermission(on: viewController)
        guard isPermitted else {
            return nil
        }

        showPicker(on: viewController)
        return await withCheckedContinuation { continuation in
            completion = { pickedImage in
                continuation.resume(with: .success(pickedImage))
            }
        }
    }

    // MARK: - Private methods

    private func askPermission(on viewController: UIViewController) async -> Bool {
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

    private func showPicker(on viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true)
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

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        completion(nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            completion(image)
        } else {
            completion(nil)
        }
    }
}
