

import UIKit

class PostDetailViewController: UIViewController{

    
    @IBOutlet weak var inhoudLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("okey")
        inhoudLabel.text = post.inhoud
        titleLabel.text = post.title
        
        //haal comments etc op
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("haha")
        inhoudLabel.text = post.inhoud
        titleLabel.text = post.title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
