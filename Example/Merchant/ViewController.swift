//
//  ViewController.swift
//  Merchant
//
//  Created by dubeboy on 05/21/2020.
//  Copyright (c) 2020 dubeboy. All rights reserved.
//

import UIKit
import Merchant

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @Autowired
    var client: HTTPService

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.backgroundColor = .brown
//        client.$get { response in
//            switch response {
//                case .success(let success):
//                    let data = success.body
//                    print(data)
//                    let uiImage = UIImage(data: data)
//                    self.imageView.image = uiImage
//                    
//                case .failure(let e):
//                    print(e)
//            }
//        }
        
        
    }
    
    @IBAction func viewGallery(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
//        self.navigationController?.pushView(pickerController, animated: true, completion: {
//        })
//        pushViewController(pickerController, animated: true)
        present(pickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData = image?.pngData()
        //Or you can get the image url from AssetsLibrary
        client.$postImageData(body: imageData!) { response in
            switch response {
                case .success(let success):
                    print("success")
                    let data = success.body
//                    print(data)
                    let uiImage = UIImage(data: data)
                    self.imageView.image = uiImage
                case .failure(let e):
                     print("fail")
                     print(e)
            }
        }
//        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
