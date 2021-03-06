

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private var ref: DatabaseReference! // референс к БД
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var telNumField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference() // инициализация БД
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAlert(title: "Внимание!", message: "После успешной регистрации, доступ к приложению будет открыт только после подтверждения администратором. Спасибо")
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            print("Registration succesfull")
            
            guard let uid = user?.uid else { //доступ к ID пользователя
                return
            }
            
            self.ref = Database.database().reference() // инициализация БД
            let usersReference = self.ref.child("users").child(uid)
            let values = ["firstname": self.firstNameField.text, "lastname": self.lastNameField.text, "email": self.emailField.text, "city": self.cityField.text, "telnumber": self.telNumField.text]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                    self.createAlert(title: "Произошла ошибка", message: "Проверьте введенные данные")
                    return
                }
                print("Saved user successfully into Firebase db")
            })
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
    
    
    // outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createAlert (title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
