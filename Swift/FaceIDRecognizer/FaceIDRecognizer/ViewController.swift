//
//  ViewController.swift
//  FaceIDRecognizer
//
//  Created by Victor Zhang on 2017/12/3.
//  Copyright © 2017年 Victor Studio. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var isSignedUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册按钮
        let signUpBtn = UIButton()
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.setTitle("Sign Up by Face ID", for: .normal)
        signUpBtn.setTitleColor(UIColor.white, for: .normal)
        signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        signUpBtn.backgroundColor = UIColor.green
        signUpBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        self.view.addSubview(signUpBtn)
        
        //登陆按钮
        let signInBtn = UIButton()
        signInBtn.translatesAutoresizingMaskIntoConstraints = false
        signInBtn.setTitle("Sign In by Face ID", for: .normal)
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        signInBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        signInBtn.backgroundColor = UIColor.green
        signInBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        self.view.addSubview(signInBtn)
        
        let views = [ "signUpBtn" : signUpBtn, "signInBtn" : signInBtn ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(90)-[signUpBtn(==45)]-[signInBtn(==45)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[signUpBtn]-(20)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[signInBtn]-(20)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: views))
    }
    
    @objc func signUp() {
        isSignedUp = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func signIn() {
        isSignedUp = false
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /// http://ai.baidu.com/docs#/FACE-API/top
    func signUpByFaceID(_ image: UIImage) {
        let url = "https://aip.baidubce.com/rest/2.0/face/v2/faceset/user/add?access_token=24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570"
        
        let base64Str = (UIImagePNGRepresentation(image)?.base64EncodedString())!
        let parameters: Parameters = [ "uid": "test_uid", "group_id": "group_id", "user_info": "user_info", "image": base64Str ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            print("\(response.result)")
        }
    }
    
    /// http://ai.baidu.com/docs#/FACE-API/top
    func signInByFaceID(_ image: UIImage) {
        let url = "https://aip.baidubce.com/rest/2.0/face/v2/identify?access_token=24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570"
        
        let base64Str = (UIImagePNGRepresentation(image)?.base64EncodedString())!
        let parameters: Parameters = [ "group_id": "group_id", "image": base64Str ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            print("\(response.result)")
            /*
             "log_id" = 3122163064120322;
             result =     (
                 {
                     "group_id" = "group_id";
                     scores =             (
                         0
                     );
                     uid = "test_uid";
                     "user_info" = "user_info";
                 }
             );
             "result_num" = 1;
             */
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if isSignedUp {
            signUpByFaceID(image)
        } else {
            signInByFaceID(image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     ▿ 6 elements
     ▿ 0 : 2 elements
     - key : refresh_token
     - value : 25.bd83541f90ddc7790d740455f92d0a6f.315360000.1827649126.282335-10233570
     ▿ 1 : 2 elements
     - key : scope
     - value : vis-faceverify_faceverify_v2 public vis-faceverify_faceverify vis-faceattribute_faceattribute vis-faceverify_faceverify_match_v2 brain_all_scope vis-faceverify_vis-faceverify-detect wise_adapt lebo_resource_base lightservice_public hetu_basic lightcms_map_poi kaidian_kaidian ApsMisTest_Test权限 vis-classify_flower bnstest_fasf lpq_开放
     ▿ 2 : 2 elements
     - key : session_secret
     - value : cfc0898e8e786231d878377384589acf
     ▿ 3 : 2 elements
     - key : expires_in
     - value : 2592000
     ▿ 4 : 2 elements
     - key : access_token
     - value : 24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570
     ▿ 5 : 2 elements
     - key : session_key
     - value : 9mzdDxw+cY7o4QlJPxMl+pIl0LxJa5IAEbiWSfutjjxjXYAoV4bSVX600ja/pClnb5BoOzd7rLQGZepe9aBH6WID44dw2g==
     */
    
    static let refresh_token = "25.bd83541f90ddc7790d740455f92d0a6f.315360000.1827649126.282335-10233570"
    static let session_secret = "cfc0898e8e786231d878377384589acf"
    static let expires_in = 2592000
    static let access_token = "24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570"
    static let session_key = "9mzdDxw+cY7o4QlJPxMl+pIl0LxJa5IAEbiWSfutjjxjXYAoV4bSVX600ja/pClnb5BoOzd7rLQGZepe9aBH6WID44dw2g=="
    
    /// MARK: 获取Access Token，有效期一般一个月
    /// http://ai.baidu.com/docs#/Auth/top
    func getAccessToken() {
        let url = URL(string: "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=GWDOxTf3mHRRPsFWYoHOA1nZ&client_secret=tvDTzvaSBBw4YAXRiGDVmcgebuACxDTf")
        if let _url = url {
            let request = URLRequest(url: _url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let _error = error {
                    print("\(_error.localizedDescription)")
                } else {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        print("\(dict)")
                    } catch {
                        
                    }
                }
            }
            task.resume()
        }
    }


}

