//
//  ViewController.swift
//  SeeFood
//
//  Created by Kamrujjaman on 11/19/18.
//  Copyright © 2018 Kamrujjaman. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePicker.sourceType = .camera
        }
        else {
            print("Sorry cant take picture")
        }

        imagePicker.allowsEditing = false
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if  let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = pickedImage
        guard let ciimage = CIImage(image: pickedImage) else {fatalError("Failed UIImage to CIImage Conversion")
            
        }
        detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage)  {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Loading CoreMlModel Image Failed")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("Model failed to Process Image")
                
            }
            
            self.navigationItem.title = results.first?.identifier
            
            
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }catch{
            print("Error With Handler \(error)")
        }
        
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

