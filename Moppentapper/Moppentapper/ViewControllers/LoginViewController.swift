//
//  ViewController.swift
//  Moppentapper
//
//  Created by Stijn De Backer on 24/12/2017.
//  Copyright © 2017 Stijn De Backer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func login() {
        let username = usernameField.text!
        let password = passwordField.text!
        
        if(username == ""  || password == ""){
            return
        }
        
        customActivityIndicatory(self.view, startAnimate: true)
        KituraService.shared.login(username:username, password:password){ (user: User) in
            DispatchQueue.main.async(){
                if(user.name != ""){
                    print("goed")
                    let defaults = UserDefaults.standard
                    defaults.set(user.username, forKey: "username")
                    defaults.set(user.name, forKey: "name")
                    defaults.set(user.email, forKey: "email")
                    defaults.set(user.password, forKey: "password")
                    customActivityIndicatory(self.view, startAnimate: false)
                    self.performSegue(withIdentifier: "loginSucces", sender: self)
                }else{
                    customActivityIndicatory(self.view, startAnimate: false)
                    let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "loginSucces"?:
            print("yey")
            _ = segue.destination as! PostViewController
        default:
            break
        }
    }
    
    /*@IBAction func LoginButton(_ sender: Any) {
        
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
    }*/
    
}

@discardableResult
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
    mainContainer.alpha = 0.5
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = false
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
    viewBackgroundLoading.alpha = 0.5
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    if startAnimate!{
        viewBackgroundLoading.addSubview(activityIndicatorView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        activityIndicatorView.startAnimating()
    }else{
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
    }
    return activityIndicatorView
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


