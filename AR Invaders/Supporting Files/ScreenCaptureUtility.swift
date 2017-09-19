//
//  ScreenCaptureController.swift
//  AR Invaders
//
//  Created by Aivant Goyal on 8/13/17.
//  Copyright © 2017 aivantgoyal. All rights reserved.
//

import ReplayKit

class ScreenCaptureUtility : NSObject {
    
    static var shared : ScreenCaptureUtility = {
        return ScreenCaptureUtility()
    }()
    
    var available : Bool {
        get {
            return RPScreenRecorder.shared().isAvailable
        }
    }
    
    var isRecording = false
    
    func toggleRecording(){
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording(){
        guard RPScreenRecorder.shared().isAvailable else {
            presentAlert(title: "Screen Recording Unavailable", message: "Check your permissions and try again later", completion: nil)
            return
        }
        
        presentAlert(title: "Screen Recording Began", message: "The app will now record your screen. Turn it off to share your video.") {
            RPScreenRecorder.shared().startRecording(handler: { (error) in
                if error == nil { // Recording has started
                    print("Recording Successfully Started")
                    self.isRecording = true
                } else {
                    print("Error in Starting to Record: \(error!.localizedDescription)")
                    // Handle error
                }
            })
        }
    }
    
    private func stopRecording(){
        RPScreenRecorder.shared().stopRecording(handler: { (previewController, error) in
            guard error == nil else { print("Error in stopping recording: \(error!.localizedDescription)"); return}
            guard let previewController = previewController else { print("Preview Controller is nil"); return}
            print("Successfully Stopped Recording")
            self.isRecording = false
            previewController.previewControllerDelegate = self
            self.topViewController?.present(previewController, animated: true, completion: nil)
        })
    }
    
    func presentAlert(title: String, message: String, completion: (() -> Void)? ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            completion?()
        }))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    var topViewController : UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        print("Couldn't find Top View Controller")
        return nil
    }
}

extension ScreenCaptureUtility : RPPreviewViewControllerDelegate{
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        topViewController?.dismiss(animated: true, completion: nil)
    }
}
