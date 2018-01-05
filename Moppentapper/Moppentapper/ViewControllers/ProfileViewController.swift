import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var UsernameField: UILabel!
    @IBOutlet weak var EmailField: UILabel!
    @IBOutlet weak var aantalCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        user = User(name: defaults.string(forKey: "name")!, email: defaults.string(forKey: "email")!, username: defaults.string(forKey: "username")!, password: defaults.string(forKey: "password")!)
        
        UsernameField.text = "Username: " + (user?.username)!
        EmailField.text = "Email: " + (user?.email)!
        aantalCount.text = "Aantal posts: \(posts.count)"
        
        KituraService.shared.getMyPosts(withName: (user?.username)! ) {
            if let posts = $0 {
                self.posts = posts
                self.collectionView.reloadData()
                self.aantalCount.text = "Aantal posts: \(posts.count)"
            }
        }
        
        collectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        collectionView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "poep"?:
            print("poep")
        case "showPost"?:
            let postDetailViewController = segue.destination as! PostDetailViewController
            let selection = collectionView.indexPathsForSelectedItems!.first!
            postDetailViewController.post = posts[selection.item]
        default:
            break
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
        //let postDetailViewController = segue.destination as! PostDetailViewController
        //let selection = collectionView.indexPathsForSelectedItems!.first!
        //postDetailViewController.post = posts[selection.item]
        let postDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        postDetailViewController.post = posts[indexPath.item]
        
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
        
    }
    
    
}
