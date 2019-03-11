

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var telNumLabel: UILabel!
    
    private var ref: DatabaseReference!
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getUserInfo(){
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentUser.email = value?["email"] as? String ?? ""
            self.currentUser.firstName = value?["firstname"] as? String ?? ""
            self.currentUser.lastName = value?["lastname"] as? String ?? ""
            self.currentUser.city = value?["city"] as? String ?? ""
            self.currentUser.telNumber = Int(value?["telnumber"] as? String ?? "")
            //self.performSegue(withIdentifier: "goToProfile", sender: self)
            self.updateUIWithUserData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func updateUIWithUserData() {
        nameField.text = "\(currentUser.firstName!) \(currentUser.lastName!)"
        cityLabel.text = " \(currentUser.city!)"
        telNumLabel.text = "+\(currentUser.telNumber!)"
    }
    
    @IBAction func optionsButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive , handler:{ (UIAlertAction)in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController1")
            self.present(nextViewController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func LogOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController1")
            self.present(nextViewController, animated: true, completion: nil)        }
        catch {
            print(error)
            
        }
    }
}
