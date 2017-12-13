//
//  SettingEditViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/28.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SettingEditViewController: UIViewController {
  
  
  @IBOutlet weak var account_TextField: UITextField!
  
  @IBOutlet weak var nickName_TextField: UITextField!
  
  @IBOutlet weak var birthday_TextField: UITextField!
  
  @IBOutlet weak var gender_TextField: UITextField!
  
  @IBOutlet weak var overview_ImageView: UIImageView!
  
  @IBOutlet weak var name_Label: UILabel!
  
  @IBAction func cameraOrImage(_ sender: UIButton) {
  }
  
  let gender = ["男", "女", "其他"]
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let pickerView = UIPickerView()
    pickerView.delegate = self
    
    userID = Auth.auth().currentUser!.uid

    self.hideKeyboardWhenTappedAround()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var databaseRef: DatabaseReference!
  var userID = ""

  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("Users/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject]{
        print("dictionary is \(dictionary)")
        let user = User()
        user.name = dictionary["name"] as? String ?? ""
        user.account = dictionary["account"] as? String ?? ""
        
        self.name_Label.text = user.name
        
        
        
      }
      
    }
  }
  
  let datePickerView = UIDatePicker()

  @IBAction func date_TextField_Tapped(_ sender: UITextField) {
    
    self.datePickerView.datePickerMode = UIDatePickerMode.date
    
    sender.inputView = datePickerView
    
    self.datePickerView.addTarget(self, action: #selector(SettingEditViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
    toolBar.sizeToFit()
    
    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SettingEditViewController.doneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SettingEditViewController.cancelClick))
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
    toolBar.isUserInteractionEnabled = true
    
    self.view.addSubview(toolBar)
    self.toolBar.isHidden = false
    
    
    
  }
  
  @objc func datePickerValueChanged(sender:UIDatePicker) {
    
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    birthday_TextField.text = dateFormatter.string(from: sender.date)
    
  }
  let toolBar = UIToolbar()

  @objc func doneClick() {
    
    datePickerView.isHidden = true
    self.toolBar.isHidden = true
    
    
  }
  
  @objc func cancelClick() {
    datePickerView.isHidden = true
    self.toolBar.isHidden = true
    
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
extension SettingEditViewController {
  
  func hideKeyboardWhenTappedAround(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
}

extension SettingEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return gender.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return gender[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    gender_TextField.text = gender[row]
  }
}

