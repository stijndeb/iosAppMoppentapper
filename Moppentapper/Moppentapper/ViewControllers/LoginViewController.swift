//
//  ViewController.swift
//  Moppentapper
//
//  Created by Stijn De Backer on 24/12/2017.
//  Copyright © 2017 Stijn De Backer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
    
    override func viewDidLoad() {
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil){
            LoginDone()
        }else{
            LoginToDo()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButton(_ sender: Any) {
        
        if(_login_button.titleLabel?.text == "Logout"){
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
            return
        }
        
        let username = _username.text
        let password = _password.text
    
        if(username == "" || password == ""){
            return
        }
        
        DoLogin(username!, password!)
    }
    
    func DoLogin(_ user: String, _ psw:String){
        let url = URL(string: "blabla")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username=" + user + "&password="+psw
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else{
                return
            }
            
            let json:Any?
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }catch{
                return
            }
            
            guard let server_response = json as? NSDictionary else{
                return
            }
            
            if let data_block = server_response["data"] as? NSDictionary{
                if let session_data = data_block["session"] as? String{
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.LoginDone()
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func LoginToDo(){
        _username.isEnabled = true
        _password.isEnabled = true
        
        _login_button.setTitle("Login", for: .normal)
    }
    
    func LoginDone(){
        _username.isEnabled = false
        _password.isEnabled = false
        
        _login_button.setTitle("Logout", for: .normal)
    }
    
}

