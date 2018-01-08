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
    camera()
  }
  var user = User()
  
  let gender = ["男", "女", "其他"]
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let pickerView = UIPickerView()
    pickerView.delegate = self
    
    
    overview_ImageView.layer.cornerRadius = overview_ImageView.bounds.height / 2
    overview_ImageView.layer.borderWidth = 2.0
    overview_ImageView.layer.borderColor = UIColor.white.cgColor
    overview_ImageView.clipsToBounds = true
    
    let userDefaults = UserDefaults.standard
    userID = userDefaults.string(forKey: "uid") ?? ""
    username = userDefaults.string(forKey: "name") ?? ""
    
    if username != ""{
      name_Label.text = user.name
    } else {
      name_Label.text = "嗨你好:)"
    }
//    if user.name != ""{
//      name_Label.text = user.name
//    } else {
//      name_Label.text = "嗨你好:)"
//    }
    if user.account == nil{
      account_TextField.placeholder = "請填寫帳號"
    } else {
      if user.account == ""{
        account_TextField.placeholder = "請填寫帳號"
      } else {
        account_TextField.text = user.account
      }
    }
    
    if user.name == nil {
      nickName_TextField.placeholder = "請填寫暱稱"
    } else {
      if user.name == ""{
        nickName_TextField.placeholder = "請填寫暱稱"
      } else {
        nickName_TextField.text = user.name
      }
    }
    
    if user.birthday == nil {
      birthday_TextField.placeholder = "請填寫生日"
    } else {
      if user.birthday == ""{
        birthday_TextField.placeholder = "請填寫生日"
      } else {
        birthday_TextField.text = user.birthday
      }
    }
    
    if user.gender == nil {
      gender_TextField.placeholder = "請填寫性別"
    } else {
      if user.gender == ""{
        gender_TextField.placeholder = "請填寫性別"
      } else {
        gender_TextField.text = user.gender
      }
    }
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  var databaseRef: DatabaseReference!
  var userID = ""
  var username = ""
  
  @IBAction func comfirm_Button_Tapped(_ sender: UIBarButtonItem) {
    let parameter = ["name": nickName_TextField.text ?? "", "account": account_TextField.text ?? "", "birthday": birthday_TextField.text ?? "", "gender": gender_TextField.text ?? ""]
    databaseRef.child("User/\(self.userID)").setValue(parameter) { (error, databaseRef) in
      if error != nil {
        print(error?.localizedDescription ?? "Failed to update value")
      } else {
        print("Success update newValue to database")
        self.alertSuccess()
      }
    }
  }
  func alertSuccess(){
    let alert = UIAlertController(title: "上傳成功", message: "", preferredStyle: .alert)
    
    let confirm = UIAlertAction(title: "確認", style: .default) { (action) in
      self.performSegue(withIdentifier: "identifierBack", sender: self)
    }
    alert.addAction(confirm)
    
    
    self.present(alert, animated: true)
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
  
  
  
  func camera(){
    // 建立一個 UIImagePickerController 的實體
    let imagePickerController = UIImagePickerController()
    
    // 委任代理
    imagePickerController.delegate = self
    
    // 建立一個 UIAlertController 的實體
    // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
    let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
    
    // 建立三個 UIAlertAction 的實體
    // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
    let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
      
      // 判斷是否可以從照片圖庫取得照片來源
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        
        // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
      }
    }
    let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
      
      // 判斷是否可以從相機取得照片來源
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
        // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
      }
    }
    
    // 新增一個取消動作，讓使用者可以跳出 UIAlertController
    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
      
      imagePickerAlertController.dismiss(animated: true, completion: nil)
    }
    
    // 將上面三個 UIAlertAction 動作加入 UIAlertController
    imagePickerAlertController.addAction(imageFromLibAction)
    imagePickerAlertController.addAction(imageFromCameraAction)
    imagePickerAlertController.addAction(cancelAction)
    
    // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
    present(imagePickerAlertController, animated: true, completion: nil)
    
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



extension SettingEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    
    
    var selectedImageFromPicker: UIImage?
    
    // 取得從 UIImagePickerController 選擇的檔案
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      
      selectedImageFromPicker = pickedImage
    }
    
    // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
    let uniqueString = NSUUID().uuidString
    
    
    if let user = Auth.auth().currentUser {
      userID = user.uid
      
      
      // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
      if let selectedImage = selectedImageFromPicker {
        
        
        let storageRef = Storage.storage().reference().child("\(uniqueString).png")
        
        if let uploadData = UIImagePNGRepresentation(selectedImage) {
          // 這行就是 FirebaseStorage 關鍵的存取方法。
          storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
            
            if error != nil {
              
              // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
              print("Error: \(error!.localizedDescription)")
              return
            }
            
            // 連結取得方式就是：data?.downloadURL()?.absoluteString。
            if let uploadImageUrl = data?.downloadURL()?.absoluteString {
              
              // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
              print("Photo Url: \(uploadImageUrl)")
              
              
              // 存放在database
              let databaseRef = Database.database().reference(withPath: "Users/\(self.userID)/profileImageUrl")
              
              databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                
                if error != nil {
                  
                  print("Database Error: \(error!.localizedDescription)")
                }
                else {
                  
                  print("圖片已儲存")
                }
                
              })
              
              
            }
          })
        }
      }
      dismiss(animated: true, completion: nil)
      
      
    }//uid
    
    
  }
  
  
}

