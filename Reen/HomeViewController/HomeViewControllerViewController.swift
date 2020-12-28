//
//  HomeViewControllerViewController.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 26/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import UIKit
import CropViewController
//import TesseractOCR
//import TesseractOCR
import Vision

class HomeViewControllerViewController: GenericViewController,
UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {

    @IBOutlet weak var rechargeLbl: UILabel?
    @IBOutlet weak var pinImage: UIImageView?
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationBar(state: .withEmpty)
        self.pinImage?.layer.borderWidth = 1
        self.pinImage?.layer.borderColor = UIColor.black.cgColor
        //let gg = Tess
        //if let tessaract = GBTess
        
        
    }
    
    func setUpVisionTextRecognizer(image: UIImage?) {
        var text = ""
        if #available(iOS 13.0, *) {
            var request = VNRecognizeTextRequest(completionHandler: nil)
            request = VNRecognizeTextRequest(completionHandler: { (request, error) in
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {fatalError("Received invalid observation")}
                
                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else {
                        print("No candidate")
                        continue
                    }

                    print("Found this candidate: \(bestCandidate.string)")
                    text = bestCandidate.string
                    
                    DispatchQueue.main.async {
                        //self.stopA
                        print("the test is \(text)")
                        let pin = ["pin": text]
                        NotificationCenter.default.post(name: Notification.Name.DidGetTextFromCropping, object: self, userInfo:pin)
                    }
                    
                }
            })
            
            //add some properties
            request.customWords = ["customW"]
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en_US"]
            request.usesLanguageCorrection = true
            
            //creating request handler
            let requests = [request]

            DispatchQueue.global(qos: .userInitiated).async {
                guard let img = image?.cgImage else {
                    fatalError("Missing image to scan")
                }

                let handler = VNImageRequestHandler(cgImage: img, options: [:])
                try? handler.perform(requests)
            }
        } else {
            // Fallback on earlier versions
            print("please update to iOS 13 or higher")
            self.displayDropDownAlertWithTitle(title: "iOS ver not supported",
                                               message: "Please update to iOS 13 or higher",
                                               error: true)
        }
        
        
    }

    @IBAction func scanAction(_ sender: UIButton) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate  = self
        //imagePickerViewController.allowsEditing = true
        //imagePickerViewController.showsCameraControls = true
        let actionSheet = UIAlertController(title: "Photo Source" , message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            imagePickerViewController.sourceType = .camera
            self.present(imagePickerViewController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePickerViewController.sourceType = .photoLibrary
            self.present(imagePickerViewController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
        
//        let vc = LoadPinViewController(nibName: "LoadPinViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//        DispatchQueue.main.async {
//            //self.stopA
//            //print("the test is \(text)")
//            let pin = ["pin": "0809 6022 4404 46692"]
//            NotificationCenter.default.post(name: Notification.Name.DidGetTextFromCropping, object: self, userInfo:pin)
//        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.pinImage?.image = image
        self.rechargeLbl?.text = ""
        
        picker.dismiss(animated: true, completion: nil)
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController,
         didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.rechargeLbl?.text = ""
        self.pinImage?.image = image
        //self.extractTextFromImageWithTesseract(image: image)
        self.setUpVisionTextRecognizer(image: image)
        let vc = LoadPinViewController(nibName: "LoadPinViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        cropViewController.dismiss(animated: true, completion: nil)
        print("the text is \(text)")
    }
    
//    func extractTextFromImageWithTesseract(image: UIImage) {
//        if let tesseract = G8Tesseract(language: "eng") {
//            tesseract.delegate = self
//            tesseract.image = image
//            tesseract.recognize()
//            text = tesseract.recognizedText ?? ""
//        }
//    }
//
//    func progressImageRecognition(for tesseract: G8Tesseract) {
//        print("reg progrss is \(tesseract.progress)")
//    }
//
//    func shouldCancelImageRecognition(for tesseract: G8Tesseract) -> Bool {
//        return false
//    }
}
