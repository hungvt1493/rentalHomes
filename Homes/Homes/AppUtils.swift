import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let userid               = DefaultsKey<String?>("_userid")
    static let email                = DefaultsKey<String?>("_email")
    static let username             = DefaultsKey<String?>("_username")
    static let password             = DefaultsKey<String?>("_password")
}

public func me() -> UserModel? {
    guard let userid = Defaults[.userid] else {
        return nil
    }
    
    return UserModel(userId: userid, username: Defaults[.username]!, email: Defaults[.email]!, phoneNumber: "", company: "", address: "")
}

//MARK: - Localization Messages

public func LocStr(_ key:String) -> String {
    return NSLocalizedString(key, comment:"");
}

public func attributesWithFont(_ font: UIFont) -> [NSAttributedStringKey: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping
    paragraphStyle.alignment = .left;
    paragraphStyle.minimumLineHeight = font.lineHeight
    paragraphStyle.maximumLineHeight = font.lineHeight
    paragraphStyle.lineHeightMultiple = 1.0
    paragraphStyle.firstLineHeadIndent = 0.0
    
    let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle]
    return attributes
}

public func alert(m: String) {
    let alert = UIAlertController(title: "My Alert", message: m, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        NSLog("The \"OK\" alert occured.")
    }))
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        topController.present(alert, animated: true, completion: nil)
    }
}

public func jsonFileToArray(fileName: String) -> Any {
    do {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
//                print(object)
                return json
            } else if let object = json as? [Any] {
                // json is an array
//                print(object)
                return json
            } else {
                print("JSON is invalid")
            }
        } else {
            print("no file")
        }
    } catch {
        print(error.localizedDescription)
    }
    
    return []
}

public func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

public func timeStringFromTimeStamp(_ unixtimeInterval: Double) -> String {
    let date = Date(timeIntervalSince1970: unixtimeInterval)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9") //TimeZone.current //TimeZone(abbreviation: "GMT+9") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
    return dateFormatter.string(from: date)
}

public func checkIfStringIsEmpty(_ string: String?) -> String {
    if let string = string {
        return string
    }
    
    return ""
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
