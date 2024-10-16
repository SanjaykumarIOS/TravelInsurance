//
//  FileUpload.swift
//  TravelInsurance
//
//  Created by SANJAY  on 03/06/24.
//

import UIKit
import SwiftUI
import MobileCoreServices

struct UIKitDocumentPickerViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController

    let completion: ([URL]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentTypes = ["public.png", "public.jpeg"]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: UIKitDocumentPickerViewController

        init(_ parent: UIKitDocumentPickerViewController) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.completion(urls)
        }
    }
}




struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    var onImagePicked: (URL) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                if let url = saveImageToTemporaryDirectory(uiImage) {
                    parent.onImagePicked(url)
                }
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }

        private func saveImageToTemporaryDirectory(_ image: UIImage) -> URL? {
            guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = temporaryDirectory.appendingPathComponent(fileName)

            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving image to temporary directory: \(error)")
                return nil
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera // Use .photoLibrary to pick from library
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update UI
    }
}

