import UIKit

class PostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var posts: [Post] = []
    @IBOutlet weak var LogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        KituraService.shared.getPosts {
            if let posts = $0 {
                self.posts = posts
                self.collectionView.reloadData()
            }
        }
        
        collectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        collectionView.dataSource = self
        
        if(isKeyPresentInUserDefaults(key: "username")){
            rightButton.setTitle(UserDefaults.standard.string(forKey: "username"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "showPost"?:
            let postDetailViewController = segue.destination as! PostDetailViewController
            let selection = collectionView.indexPathsForSelectedItems!.first!
            postDetailViewController.post = posts[selection.item]
        case "Login"?:
            _ = segue.destination as! LoginViewController
            
        case "profile"?:
            _ = segue.destination as! ProfileViewController
            
        default:
            fatalError("Unknown segue")
        }
    }
    

    
    @IBAction func checkButton(_ sender: Any) {
        
        if(rightButton.currentTitle == "Log in"){
            self.performSegue(withIdentifier: "Login", sender: self)
        }else if(isKeyPresentInUserDefaults(key: "username")){
            if(rightButton.currentTitle == UserDefaults.standard.string(forKey: "username")){
                self.performSegue(withIdentifier: "profile", sender: self)
            }
        }else {
            self.performSegue(withIdentifier: "Login", sender: self)
        }
        
    }
    
    
    @IBAction func unwindFromLogin(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "loginSucces"?:
            print("hier")
            if(isKeyPresentInUserDefaults(key: "username")){
                rightButton.setTitle(UserDefaults.standard.string(forKey: "username"), for: .normal)
            }
        case "logOut"?:
            rightButton.setTitle("Log in", for: .normal)
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "username")
            defaults.removeObject(forKey: "email")
            defaults.removeObject(forKey: "name")
            defaults.removeObject(forKey: "password")
            
            
        default:
            fatalError("Unknown segue")
        }
        
    }
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let postDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        postDetailViewController.post = posts[indexPath.item]
        
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
        
    }
    
}
