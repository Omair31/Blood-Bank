//
//  ViewController.swift
//  BloodBank2
//
//  Created by Omeir on 16/05/2017.
//  Copyright © 2017 Omeir. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

  
    let bloodGroups = ["A","B","AB","O"]
    let RHValues = ["+","-"]
    let userType = ["Donor","Recipient","Both"]
    var bloodPicker = UIPickerView()
    var RHPicker = UIPickerView()
    var userPicker = UIPickerView()
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpUserNameTextField: UITextField!
    
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpBloodGroupTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var LoginSignupSegmentControl: UISegmentedControl!
   
    @IBOutlet weak var signUpContactTextField: UITextField!
    
    @IBOutlet weak var signUpUserTypeTextField: UITextField!
    
    @IBOutlet weak var signUpRHValueTextField: UITextField!
    
    @IBOutlet weak var LoginView: UIView!
    
    @IBOutlet weak var SignUpView: UIView!
    
    @IBAction func LoginSignupSegment(_ sender: Any) {
        if LoginSignupSegmentControl.selectedSegmentIndex == 0 {
            setupLoginButton()
            SignUpView.isHidden = true
            LoginView.isHidden = false
        }
        if LoginSignupSegmentControl.selectedSegmentIndex == 1 {
            setupRegisterButton()
            SignUpView.isHidden = false
            LoginView.isHidden = true
        }
    }
    
    var jsonData:[[String:AnyObject]]?
    var donorData:[[String:AnyObject]]?
    var recipientData:[[String:AnyObject]]?
    var bothData:[[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 237, green: 12, blue: 25, alpha: 1)
        if LoginSignupSegmentControl.selectedSegmentIndex == 0{
            setupLoginButton()
            SignUpView.isHidden = true
            LoginView.isHidden = false
        }
        provideDelegatesAndDataSource()
        signUpRHValueTextField.inputView = RHPicker
        signUpBloodGroupTextField.inputView = bloodPicker
        signUpUserTypeTextField.inputView = userPicker
        self.hideKeyboardWhenTappedAround()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func provideDelegatesAndDataSource(){
        self.bloodPicker.delegate = self
        self.bloodPicker.dataSource = self
        self.RHPicker.delegate = self
        self.RHPicker.dataSource = self
        self.userPicker.delegate = self
        self.userPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case RHPicker:
            return RHValues.count
        case userPicker:
            return userType.count
        case bloodPicker:
            return bloodGroups.count
        default:
            return 0
        }
    
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == userPicker{
            signUpUserTypeTextField.text = userType[row]
        }
        if pickerView == RHPicker{
            signUpRHValueTextField.text = RHValues[row]
        }
        if pickerView == bloodPicker{
            signUpBloodGroupTextField.text = bloodGroups[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == userPicker{
            return userType[row]
        }
        if pickerView == RHPicker{
        return RHValues[row]
    }
        return bloodGroups[row]
    }
    func setupRegisterButton(){
       signUpButton.layer.cornerRadius = 5
        signUpButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signUpPasswordTextField.isSecureTextEntry = true
        signUpConfirmPasswordTextField.isSecureTextEntry = true
        
    }
    
    func setupLoginButton(){
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
    }
    
    func parseJSON(){
        let url = Bundle.main.url(forResource: "bloodBankData", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
    }
    
    func userIsValid()->Bool{
        
        if jsonData != nil{
            for item in jsonData!{
                if let name = item["UserName"] as? String, let password = item["Password"] as? String {
                    if name == nameTextField.text && password == passwordTextField.text{
                        let verifiedUserContact = item["Contact"]!
                        let verifiedUserBloodGroup = item["BloodGroup"]!
                        let verifiedUserRHValue = item["RHValue"]!
                        let verifiedUserType = item["UserType"]!
                        
                        
                        switch verifiedUserType as! String {
                        case "Donor":
                            let verifiedUser = User(userName: name, userContact: verifiedUserContact as! String,bloodGroup: verifiedUserBloodGroup as! String ,RHValue: verifiedUserRHValue as! String, userType: .Donor)
                            User.sharedInstance = verifiedUser
                            case "Recipient":
                            let verifiedUser = User(userName: name, userContact: verifiedUserContact as! String,bloodGroup: verifiedUserBloodGroup as! String, RHValue: verifiedUserRHValue as! String, userType: .Recipient)
                            User.sharedInstance = verifiedUser
                            case "Both":
                            let verifiedUser = User(userName: name, userContact: verifiedUserContact as! String,bloodGroup: verifiedUserBloodGroup as! String, RHValue: verifiedUserRHValue as! String, userType: .Both)
                            User.sharedInstance = verifiedUser
                            
                        default:
                            print("Error")
                        }
                        
                        return true
                    }
                }
            }
        }
        return false
    }

    func fetchRelevantDonors(user:User) -> [[String:AnyObject]]? {
        
        var myData = [[String:AnyObject]]()
        
        switch (user.bloodGroup,user.RHValue) {
        case ("A","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") })!
        case("A","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor")})!
        case("B","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") })!
        case("B","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") })!
        case("AB","+"):
            myData = (jsonData?.filter{ $0["UserType"]! as! String == "Donor"})!
        case("AB","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") })!
        case("O","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Donor") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor") })!
        case("O","-"):
            myData = (jsonData?.filter{($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Donor")})!
        default:
            print("No data")
        }
        return myData
    }
    
    func fetchRelevantRecipients(user:User) -> [[String:AnyObject]]? {
        
        var myData = [[String:AnyObject]]()
        switch (user.bloodGroup,user.RHValue) {
        case ("A","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") })!
        case("A","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "-"  && $0["UserType"]! as! String == "Recipient") })!
        case("B","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") })!
        case("B","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "-"  && $0["UserType"]! as! String == "Recipient") })!
        case("AB","+"):
            myData = (jsonData?.filter{ $0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient" })!
        case("AB","-"):
            myData = (jsonData?.filter{ $0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient" || $0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Recipient" })!
        case("O","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") || ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "+"  && $0["UserType"]! as! String == "Recipient") })!
        case("O","-"):
            myData =  (jsonData?.filter{ $0["UserType"]! as! String == "Recipient"})!
        default:
            print("No data")
        }
        return myData
    }
    
    func fetchboth(user:User) -> [[String:AnyObject]]? {
        
        var myData = [[String:AnyObject]]()
        
        switch (user.bloodGroup,user.RHValue) {
        case ("A","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") })!
        case("A","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both")})!
        case("B","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") })!
        case("B","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") })!
        case("AB","+"):
            myData = (jsonData?.filter{ $0["UserType"]! as! String == "Both"})!
        case("AB","-"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "AB" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "A" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "B" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") })!
        case("O","+"):
            myData =  (jsonData?.filter{ ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "+" && $0["UserType"]! as! String == "Both") || ($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both") })!
        case("O","-"):
            myData = (jsonData?.filter{($0["BloodGroup"]! as! String == "O" && $0["RHValue"]! as! String == "-" && $0["UserType"]! as! String == "Both")})!
        default:
            print("No data")
        }
        return myData
    }

    
    func fetchRelevantData(){
       print(User.sharedInstance.RHValue)
        
        donorData = fetchRelevantDonors(user: User.sharedInstance)
        
        recipientData = fetchRelevantRecipients(user: User.sharedInstance)
       
        bothData = fetchboth(user: User.sharedInstance)
        
        
    }
    
    func moveToNextViewController(){
        let tbc = self.storyboard!.instantiateViewController(withIdentifier: "nextView") as! UITabBarController
        
        
        let donorViewControllerOBJ = tbc.viewControllers?[0] as! DonorViewController
        let recipientViewControllerOBJ = tbc.viewControllers?[1] as! RecipientViewController
        let bothViewControllerOBJ = tbc.viewControllers?[2] as! BothViewController
        
        bothViewControllerOBJ.array = bothData!
        donorViewControllerOBJ.array = donorData!
        recipientViewControllerOBJ.array = recipientData!
        
        self.present(tbc, animated: true, completion: nil)
    }

    @IBAction func buttonTapped(_ sender: Any) {
        
        parseJSON()
        if self.userIsValid() {
            
            fetchRelevantData() // from donorData and recipientData and bothData
            moveToNextViewController()
        }
        
        let message = "Invalid Email or Password"
        displayError(message: message)
    }
    
    func displayError(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return
    }
    
    @IBAction func SignUpbuttonPressed(_ sender: Any) {
       
        if signUpPasswordTextField.text != signUpConfirmPasswordTextField.text {
         let passwordMessage = "Passwords do not match"
         displayError(message: passwordMessage)
         }
         
         if signUpUserNameTextField.text != "" && signUpPasswordTextField.text != "" && signUpConfirmPasswordTextField.text != "" && signUpBloodGroupTextField.text != "" && signUpContactTextField.text != "" && signUpUserTypeTextField.text != "" && signUpRHValueTextField.text != "" {
            
            switch signUpUserTypeTextField.text! {
            case "Donor":
                let user = User(userName: signUpUserNameTextField.text!, userContact: signUpContactTextField.text!, bloodGroup: signUpBloodGroupTextField.text!, RHValue: signUpRHValueTextField.text!, userType: .Donor)
                User.sharedInstance = user
                case "Recipient":
                    let user = User(userName: signUpUserNameTextField.text!, userContact: signUpContactTextField.text!, bloodGroup: signUpBloodGroupTextField.text!, RHValue: signUpRHValueTextField.text!, userType: .Recipient)
                    User.sharedInstance = user
                case "Both":
                    let user = User(userName: signUpUserNameTextField.text!, userContact: signUpContactTextField.text!, bloodGroup: signUpBloodGroupTextField.text!, RHValue: signUpRHValueTextField.text!, userType: .Both)
                    User.sharedInstance = user
            default:
                print("Error")
            }
        
            parseJSON()
            fetchRelevantData()
            moveToNextViewController()
         
         }
        
         else{
            let incompleteFieldMessage = "All fields are required !"
            displayError(message: incompleteFieldMessage)
        }
    }
 
   
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



