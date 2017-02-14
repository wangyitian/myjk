//
//  UserInfo.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/9/9.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit

private let passwordKey = "passwordKey"
private let phoneNumberKey = "phoneNumberKey"
private let userIdKey = "userIdKey"
private let photoPathKey = "photoPathKey"
private let nameKey = "nameKey"
private let sexKey = "sexKey"
private let cityKey = "cityKey"
private let groupidKey = "groupidKey"
private let regdateKey = "regdateKey"
private let addressKey = "addressKey"
private let areaidKey = "areaidKey"
private let birthdayKey = "birthdayKey"
private let maladyidKey = "maladyidKey"
private let myemailKey = "myemailKey"
private let postcodeKey = "postcodeKey"
private let mymobileKey = "mymobileKey"
private let sickNameKey = "sickNameKey"
private let realnameKey = "realnameKey"
enum Sex : Int {
    case Famale = 0
    case Male = 1
    case Unknow = 2
}

var SharedUserInfo : UserInfo {
get {
    return UserInfo.sharedUserInfo
}
}

class UserInfo: NSObject {
    
    static let sharedUserInfo = UserInfo()
    var phoneNumber = "" {
        didSet {
            if oldValue != phoneNumber {
                deleteSecurity(oldValue)
            }
        }
    }
    var password = ""
    var userId = ""
    var photoPath : String?
    var name  = "姓名"
    var realname = "姓名"
    var city = ""
    var sex  = ""
    var groupid = ""
    var regdate = ""
    var address = ""
    var areaid = 0
    var birthday = ""
    var maladyid = 0
    var sickName = ""
    var myemail = ""
    var postcode = ""
    var mymobile = ""
    var uuid : String {
        get {
            let keyChainDic = NSMutableDictionary()
            keyChainDic.setObject(String(kSecClassGenericPassword), forKey: String(kSecClass))
            keyChainDic.setObject("uuid", forKey: String(kSecAttrAccount))
            keyChainDic.setObject(kCFBooleanTrue, forKey: String(kSecReturnAttributes))
            keyChainDic.setObject(kCFBooleanTrue, forKey: String(kSecReturnData))
            
            var result : AnyObject?
            var uuidStr : String? = nil
            SecItemCopyMatching(keyChainDic, &result)
            if let resultDic = result as? NSDictionary {
                if let data = resultDic.objectForKey(kSecValueData) as? NSData {
                    uuidStr = NSString(data: data, encoding: NSASCIIStringEncoding) as? String
                }
            }
            if uuidStr == nil {
                uuidStr = NSUUID().UUIDString
                let data = uuidStr!.dataUsingEncoding(NSASCIIStringEncoding)
                keyChainDic.setObject(data!, forKey: String(kSecValueData))
                SecItemAdd(keyChainDic, nil)
            }
            return uuidStr!
        }
    }
    
    
    func deleteSecurity(oldPhone : String) {
        let queryDic : [String : AnyObject] = [String(kSecClass):kSecClassGenericPassword, String(kSecAttrAccount):CommonUtil.md5(oldPhone)]
        SecItemDelete(queryDic)
    }
    
    func saveScurity() {
        let md5Phone = CommonUtil.md5(phoneNumber)
        let keyChainDic = NSMutableDictionary()
        keyChainDic.setObject(String(kSecClassGenericPassword), forKey: String(kSecClass))
        keyChainDic.setObject(md5Phone, forKey: String(kSecAttrAccount))
        let update = NSMutableDictionary()
        var security = [String:String]()
        security[passwordKey] = password
        security[phoneNumberKey] = phoneNumber

        let data = try! NSJSONSerialization.dataWithJSONObject(security, options: [])
        update.setObject(data, forKey:String(kSecValueData))
        var status = SecItemUpdate(keyChainDic, update)
        if status == errSecItemNotFound {
            keyChainDic.addEntriesFromDictionary(update as [NSObject : AnyObject])
            status = SecItemAdd(keyChainDic, nil)
        }
    }
    
    func synchronize() {
        saveScurity()
        let md5Phone = CommonUtil.md5(phoneNumber)
        NSUserDefaults.standardUserDefaults().setObject(md5Phone, forKey: CommonUtil.md5(phoneNumberKey))
        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: userIdKey)
        NSUserDefaults.standardUserDefaults().setObject(photoPath, forKey: photoPathKey)
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: nameKey)
        NSUserDefaults.standardUserDefaults().setObject(realname, forKey: realnameKey)
        NSUserDefaults.standardUserDefaults().setObject(city, forKey: cityKey)
        NSUserDefaults.standardUserDefaults().setObject(sex, forKey: sexKey)
        NSUserDefaults.standardUserDefaults().setObject(groupid, forKey: groupidKey)
        NSUserDefaults.standardUserDefaults().setObject(regdate, forKey: regdateKey)
        NSUserDefaults.standardUserDefaults().setObject(address, forKey: addressKey)
        NSUserDefaults.standardUserDefaults().setObject(areaid, forKey: areaidKey)
        NSUserDefaults.standardUserDefaults().setObject(birthday, forKey: birthdayKey)
        NSUserDefaults.standardUserDefaults().setObject(maladyid, forKey: maladyidKey)
        NSUserDefaults.standardUserDefaults().setObject(sickName, forKey: sickNameKey)
        NSUserDefaults.standardUserDefaults().setObject(myemail, forKey: myemailKey)
        NSUserDefaults.standardUserDefaults().setObject(postcode, forKey: postcodeKey)
        NSUserDefaults.standardUserDefaults().setObject(mymobile, forKey: mymobileKey)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private override init() {
        super.init()
        loadFromLocal()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfo.willResignActive), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func clearUserInfo(){
        deleteSecurity(self.phoneNumber)
        self.phoneNumber = ""
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CommonUtil.md5(phoneNumberKey))
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userIdKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(photoPathKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(nameKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(realnameKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(cityKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(sexKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(groupidKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(regdateKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(addressKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(areaidKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(birthdayKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(maladyidKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(sickNameKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(myemailKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(postcodeKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(mymobileKey)
        SharedUserInfo.loadFromLocal()
        
    }
    
    private func loadFromLocal() {
        userId = NSUserDefaults.standardUserDefaults().objectForKey(userIdKey) as? String ?? ""
        photoPath = NSUserDefaults.standardUserDefaults().objectForKey(photoPathKey) as? String
        name = NSUserDefaults.standardUserDefaults().objectForKey(nameKey) as? String ?? "姓名"
        realname = NSUserDefaults.standardUserDefaults().objectForKey(realnameKey) as? String ?? "姓名"
        city = NSUserDefaults.standardUserDefaults().objectForKey(cityKey) as? String ?? ""
        sex = NSUserDefaults.standardUserDefaults().objectForKey(sexKey) as? String ?? ""
        groupid = NSUserDefaults.standardUserDefaults().objectForKey(groupidKey) as? String ?? ""
        regdate = NSUserDefaults.standardUserDefaults().objectForKey(regdateKey) as? String ?? ""
        address = NSUserDefaults.standardUserDefaults().objectForKey(addressKey) as? String ?? ""
        areaid = NSUserDefaults.standardUserDefaults().objectForKey(areaidKey) as? Int ?? 0
        birthday = NSUserDefaults.standardUserDefaults().objectForKey(birthdayKey) as? String ?? ""
        maladyid = NSUserDefaults.standardUserDefaults().objectForKey(maladyidKey) as? Int ?? 0
        sickName = NSUserDefaults.standardUserDefaults().objectForKey(sickNameKey) as? String ?? ""
        myemail = NSUserDefaults.standardUserDefaults().objectForKey(myemailKey) as? String ?? ""
        postcode = NSUserDefaults.standardUserDefaults().objectForKey(postcodeKey) as? String ?? ""
        mymobile = NSUserDefaults.standardUserDefaults().objectForKey(mymobileKey) as? String ?? ""
        
        guard let md5Phone = NSUserDefaults.standardUserDefaults().objectForKey(CommonUtil.md5(phoneNumberKey)) else {
            return
        }
        
        let keyChainDic = NSMutableDictionary()
        keyChainDic.setObject(String(kSecClassGenericPassword), forKey: String(kSecClass))
        keyChainDic.setObject(md5Phone, forKey: String(kSecAttrAccount))
        keyChainDic.setObject(kCFBooleanTrue, forKey: String(kSecReturnAttributes))
        keyChainDic.setObject(kCFBooleanTrue, forKey: String(kSecReturnData))
        
        var result : AnyObject?
        SecItemCopyMatching(keyChainDic, &result)
        if let resultDic = result as? NSDictionary {
            if let data = resultDic.objectForKey(kSecValueData) as? NSData {
                do {
                    let securityDic = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
                    guard let securityInfo = securityDic as? [String:String], password = securityInfo[passwordKey], phoneNumber = securityInfo[phoneNumberKey] else {
                        return
                    }
                    self.password = password
                    self.phoneNumber = phoneNumber
                } catch {
                    print("读取用户账号信息有误:\n\(error)")
                    SecItemDelete(keyChainDic)
                }
            }
        }
        
    }
    
    func willResignActive() {
        synchronize()
    }
       func showLoginView(parentCtl : UIViewController = AppRootController) {
        let logInCtl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("HXQRegisterNavigationController")
        parentCtl.presentViewController(logInCtl, animated : true, completion : nil)
    }
   
}
