//
//  Helper.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

//class CameraHandler: NSObject {
//
//    private let imagePicker = UIImagePickerController()
//    private let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
//    private let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
//    private let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
//    private let isRearCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear)
//    private let isFrontCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)
//    private let sourceTypeCamera = UIImagePickerControllerSourceType.camera
//    private let rearCamera = UIImagePickerControllerCameraDevice.rear
//    private let frontCamera = UIImagePickerControllerCameraDevice.front
//
//    weak var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
//    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
//        delegate = delegate_
//    }
//
//    func getPhotoLibraryOn(_ onVC: UIViewController, canEdit: Bool) {
//
//        if !isPhotoLibraryAvailable && !isSavedPhotoAlbumAvailable { return }
//        let type = kUTTypeImage as String
//
//        if isPhotoLibraryAvailable {
//            imagePicker.sourceType = .photoLibrary
//            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
//                if availableTypes.contains(type) {
//                    imagePicker.mediaTypes = [type]
//                    imagePicker.allowsEditing = canEdit
//                }
//            }
//        } else if isPhotoLibraryAvailable {
//            imagePicker.sourceType = .savedPhotosAlbum
//            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
//                if availableTypes.contains(type) {
//                    imagePicker.mediaTypes = [type]
//                }
//            }
//        } else {
//            return
//        }
//
//        imagePicker.allowsEditing = canEdit
//        imagePicker.delegate = delegate
//        onVC.present(imagePicker, animated: true, completion: nil)
//    }
//
//    func getCameraOn(_ onVC: UIViewController, canEdit: Bool) {
//
//        if !isCameraAvailable { return }
//        let type1 = kUTTypeImage as String
//
//        if isCameraAvailable {
//            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
//                if availableTypes.contains(type1) {
//                    imagePicker.mediaTypes = [type1]
//                    imagePicker.sourceType = sourceTypeCamera
//                }
//            }
//
//            if isRearCameraAvailable {
//                imagePicker.cameraDevice = rearCamera
//            } else if isFrontCameraAvailable {
//                imagePicker.cameraDevice = frontCamera
//            }
//        } else {
//            return
//        }
//
//        imagePicker.allowsEditing = canEdit
//        imagePicker.showsCameraControls = true
//        imagePicker.delegate = delegate
//        onVC.present(imagePicker, animated: true, completion: nil)
//    }
//}

open class BKLogPreferences {
    static var printEnabled = true
    static var debugEnabled = true
}

internal class BKLog {

    /// This function sends debug messages if "-D DEBUG" flag is added in 'Build Settings' > 'Swift Compiler - Custom Flags'
    ///
    /// - parameters:
    ///     - message: The debug message.
    ///     - filePath: Used to get filename of bug. Do not use this parameter. Defaults to #file.
    ///     - function: Used to get function name of bug. Do not use this parameter. Defaults to #function.
    ///     - line: Used to get the line of bug. Do not use this parameter. Defaults to #line.
    ///
    @objc public class func print(_ message: String, filePath: String = #file, function: String =  #function, line: Int = #line) {
        guard BKLogPreferences.printEnabled else { return }
        var functionSignature: String = function
        if let parameterNames = functionSignature.range(of: "\\((.*?)\\)", options: .regularExpression) {
            functionSignature.replaceSubrange(parameterNames, with: "()")
        }
        let fileName = NSString(string: filePath).lastPathComponent
        Swift.print("[\(fileName):\(line):\(functionSignature)] - \(message)")
    }

    /// This function sends debug messages if "-D DEBUG" flag is added in 'Build Settings' > 'Swift Compiler - Custom Flags'
    ///
    /// - parameters:
    ///     - message: The debug message.
    ///     - filePath: Used to get filename of bug. Do not use this parameter. Defaults to #file.
    ///     - function: Used to get function name of bug. Do not use this parameter. Defaults to #function.
    ///     - line: Used to get the line of bug. Do not use this parameter. Defaults to #line.
    ///
    @objc public class func debug(_ message: String, filePath: String = #file, function: String =  #function, line: Int = #line) {
        guard BKLogPreferences.printEnabled && BKLogPreferences.debugEnabled else { return }
        var functionSignature: String = function
        if let parameterNames = functionSignature.range(of: "\\((.*?)\\)", options: .regularExpression) {
            functionSignature.replaceSubrange(parameterNames, with: "()")
        }
        let fileName = NSString(string: filePath).lastPathComponent
        Swift.print("[\(fileName):\(line):\(functionSignature)] - \(message)")
    }

    /// This function sends debug messages if "-D DEBUG" flag is added in 'Build Settings' > 'Swift Compiler - Custom Flags'
    ///
    /// - parameters:
    ///     - message: The confirmation message.
    ///     - filePath: Used to get filename. Do not use this parameter. Defaults to #file.
    ///     - function: Used to get function name. Do not use this parameter. Defaults to #function.
    ///     - line: Used to get the line. Do not use this parameter. Defaults to #line.
    ///
    @objc public class func debug(confirmed message: String, filePath: String = #file, function: String =  #function, line: Int = #line) {
        guard BKLogPreferences.printEnabled && BKLogPreferences.debugEnabled else { return }
        var functionSignature: String = function
        if let parameterNames = functionSignature.range(of: "\\((.*?)\\)", options: .regularExpression) {
            functionSignature.replaceSubrange(parameterNames, with: "()")
        }
        let fileName = NSString(string: filePath).lastPathComponent
        Swift.print("[\(fileName):\(line):\(functionSignature)] - ✅ \(message)")
    }

    /// This function sends debug messages if "-D DEBUG" flag is added in 'Build Settings' > 'Swift Compiler - Custom Flags'
    ///
    /// - parameters:
    ///     - message: The debug message.
    ///     - filePath: Used to get filename of bug. Do not use this parameter. Defaults to #file.
    ///     - function: Used to get function name of bug. Do not use this parameter. Defaults to #function.
    ///     - line: Used to get the line of bug. Do not use this parameter. Defaults to #line.
    ///
    @objc public class func debug(error message: String, visual: Bool = false, filePath: String = #file, function: String =  #function, line: Int = #line) {
        guard BKLogPreferences.printEnabled && BKLogPreferences.debugEnabled else { return }
        var functionSignature: String = function
        if let parameterNames = functionSignature.range(of: "\\((.*?)\\)", options: .regularExpression) {
            functionSignature.replaceSubrange(parameterNames, with: "()")
        }
        let fileName = NSString(string: filePath).lastPathComponent
        Swift.print("[\(fileName):\(line):\(functionSignature)] - ❌ \(message)")

        if BKLogPreferences.debugEnabled && visual {
            alert(message: "🚫 \(message)", title: "☠️")
        }
    }

    private static func alert(message: String, title: String) {
        guard BKLogPreferences.printEnabled else { return }
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            UIWindow.presentTopLevelAlert(alertController: alertController)
        }
    }
}

extension UIWindow {
    class var topWindow: UIWindow? {
        if let window = UIApplication.shared.keyWindow {
            return window
        }
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindowLevelNormal && !window.isHidden && window.frame != CGRect.zero { return window }
        }
        return nil
    }

    static func presentTopLevelAlert(alertController: UIAlertController, completion:(() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertController, animated: true, completion: completion)
        }
    }
}

extension String {
    static func generateName(withRoot root: String, appendCount count: Int = 3, randomlyAppending randomChars: [String] = ["😄", "🔥", "👍", "🤑", "🏆", "⛳️", "❤️", "⁉️", "⭐️", "✨", "⛄️", "🍀", "🍬"]) -> String {
        var name = [root]
        for _ in 1...count {
            if let char = randomChars.randomElement {
                name.append(char)
            }
        }
        return name.joined()
    }
}

extension UIImageView {
    func adjustHeight() {
        let oldCenter = self.center
        guard let image = image else {
            self.frame = CGRect(origin: oldCenter, size: .zero)
            return
        }

        let imageSize = image.size
        let viewSize = frame.size
        let ratio = viewSize.width/imageSize.width

        self.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: imageSize.height * ratio)
        self.center = oldCenter
    }
}

extension URL {
    var isMovie: Bool {
        return ["mov", "mp4"].contains(pathExtension.lowercased())
    }

    var isImage: Bool {
        print("Path:\(path)")
        print("Path extension:\(pathExtension.lowercased())")
        print("Return value:\(["jpg", "jpeg", "png", "gif"].contains(pathExtension.lowercased()))")
        return ["jpg", "jpeg", "png", "gif"].contains(pathExtension.lowercased())
    }
}

extension AVPlayerLayer {
    var isPlaying: Bool {
        guard let player = player else { return false }
        return player.rate != 0 && player.error == nil
    }
}

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIImage {
    var base64String: String? {
        return UIImagePNGRepresentation(self)?.base64EncodedString()
    }

    static func from(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
            let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}

extension UIImagePickerControllerDelegate {
    func confirmPhotosPermission(completion: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                guard status == .authorized else {
                    return
                }
                completion()
            })
        } else {
            completion()
        }
    }
}
