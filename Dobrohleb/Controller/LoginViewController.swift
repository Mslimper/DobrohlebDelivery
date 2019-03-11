

import UIKit

import Firebase
import FirebaseAuth
import MessageUI



class LoginViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var gifView: UIImageView!
    
    private var ref: DatabaseReference!
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            performSegue(withIdentifier: "goToProfile", sender: self)
        } else {
            // No user is signed in.
            // ...
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    
    @IBAction func mailButton(_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
        
    }
    

    @IBAction func vkcom(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://vk.com/svmir_zhizn")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func web(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://xn--80aasee0afd0ak2fxb6ac.xn--p1ai/")! as URL, options: [:], completionHandler: nil)
        
        
    }
    
    
    @IBAction func phoneCall(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "+78127111111") else { return }
        UIApplication.shared.open(number)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.showAlert(title: "Ошибка!", msg: "Попробуйте снова. Почта или пароль неверны.", actions: nil)
            } else {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
        }

    }
    
    private func showAlert(title: String, msg: String, actions:[UIAlertAction]?) {
        var actions = actions
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if actions == nil {
            actions = [UIAlertAction(title: "OK", style: .default, handler: nil)]
        }
        
        for action in actions! {
            alertVC.addAction(action)
        }
        
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            rootVC.present(alertVC, animated: true, completion: nil)
        } else {
            print("Root view controller is not set.")
        }
    }
    
    
    // убирается клавиатура при нажатии в любой точке экрана
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["andrew@seemuapps.com"])
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("How are you doing?", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
