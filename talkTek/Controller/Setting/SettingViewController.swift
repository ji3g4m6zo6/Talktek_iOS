//
//  SettingViewController.swift
//  talkTek
//
//  Created by Mac on 2017/11/26.
//  Copyright © 2017年 Talktek Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit


class SettingViewController: UIViewController {
  
  @IBOutlet weak var profile_ImageView: UIImageView!
  
  @IBOutlet weak var name_Label: UILabel!
  
  var databaseRef: DatabaseReference!
  var username = ""
  var userID = ""
  var list = ["點數中心", "成為講師","意見反饋", "優惠碼", "關於"]
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBOutlet weak var LogIn_LogOut: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    userID = uid
    let userDefaults = UserDefaults.standard
    self.username = userDefaults.string(forKey: "name") ?? "未登入"
    name_Label.text = self.username
    //fetchData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func fetchData(){
    self.databaseRef = Database.database().reference()
    self.databaseRef.child("Users/\(self.userID)").observe(.childAdded) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject]{
        print("dictionary is \(dictionary)")
        let user = User()
        user.name = dictionary["name"] as? String ?? ""
        user.account = dictionary["account"] as? String ?? ""
        
        self.name_Label.text = user.name
        if let imageUrl = user.profileImageUrl{
          let url = URL(string: imageUrl)
          self.profile_ImageView.kf.setImage(with: url)
        }
        
      }
      
    }

  }

  @IBAction func LogIn_LogOut(_ sender: UIButton) {
    FBSDKLoginManager().logOut()
    do{
      try Auth.auth().signOut()
      self.databaseRef = Database.database().reference()
      self.databaseRef.child("Users").child(self.userID).child("Online-Status").setValue("Off")
      
      let LogInVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainLogInViewController") as! MainLogInViewController
      self.present(LogInVC, animated: true, completion: nil)
    }catch let logOutError {
      
      print(logOutError)
      
    }
    
    

  }
  
  @IBAction func cameraOrImage(_ sender: UIButton) {
    camera()
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
  
  
  
}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource
{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingMainTableViewCell
    cell.settingTitle_Label.text = list[indexPath.row]
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0{
      performSegue(withIdentifier: "points", sender: self)
    } else if indexPath.row == 1{
      performSegue(withIdentifier: "lecturer", sender: self)
    } else if indexPath.row == 2{
      performSegue(withIdentifier: "suggestion", sender: self)
    } //else if indexPath.row == 3{
      //performSegue(withIdentifier: "personal", sender: self)
    //}
       else if indexPath.row == 3{
      performSegue(withIdentifier: "coupon", sender: self)
    } else if indexPath.row == 4{
      performSegue(withIdentifier: "about", sender: self)
    } else{
      print("WTF happened!!!")
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
              let databaseRef = Database.database().reference(withPath: "ID/\(self.userID)/Profile/Photo")
              
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

