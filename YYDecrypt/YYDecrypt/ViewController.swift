//
//  ViewController.swift
//  YYDecrypt
//
//  Created by HarrisonFu on 2022/11/16.
//

import UIKit
import SwiftyRSA
import Security

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let path = Bundle.main.url(forResource: "feedbackprivate", withExtension:"pem")
        var privateStr:String?
        var privateKey:PrivateKey?
        do {
            privateKey = try PrivateKey(pemNamed: "feedbackprivate")
            privateStr = try privateKey?.pemString()
        } catch { }
    
        if let str = privateStr {
            debugPrint("===== \(str)")
        }
        let string = "Z92k2WgWoCygbA63do0DnIcxZsVuU/uuo2jno2jzKtGCzi+fMcM6NUIjgu9+uEuMwhaCb9PVNdFPrlEZ1GyaUGJ8QUe4EkkpdZrwy1fPLJrLdIyNMeo3YfP62wPDU+eJxznRULms0tbx1M5NGeVvv0yNF+Zuk7Ly+I4GU4MUoQM="
        do {
            guard let privateKey = privateKey else { return }
            let need = try EncryptedMessage(base64Encoded: string)
            let clear = try need.decrypted(with: privateKey, padding: .PKCS1)
            let key = String(data: clear.data, encoding: .utf8)
            debugPrint("=====value: \(key ?? "nil")") //正确的: uisahAQuKlNACMOz
        } catch { }
    }

    //value    __NSCFString    "apxW+oRtE5yFVW3tubYJGfZFgV6LFaHHUFgaYjPNzZOl1YlNqOZOGVGpQH3V7OqaCXdEtHzVTBC7oTjRjXksyPTUVnQ0oV6sEwsGFNUREDqFYeXT3CRY8bci0jJwFdPPcMz10cueUZwJHCJMHa/w19tDIdO4nNjr8tbWYRLqjcw="    0x0000000280cb5380
    
//   private key. MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIhbAV0gd49UCzqwE+S02ZZRV0UFZ6xzL5fAAdZsF1JVnt4NB9NhNTM0CS7hKwfN6P0ykrbZ16tRRaJ/gmPaged5aSUHewXyb1NpPvV7ohYdu58MzayUk0LbRNLY6JqZMzoqeuCf2pDsllxgCKSj+Qba8kVPNl0BjM7x2wDD0S0vAgMBAAECgYAuaevY60hHPXBlFbJv0y+NfzqZf/F+PechXHZDqp91ozdklkLnrNsTBs9pabPgADMinKhcHWLQKeXuHkEgBCzbPc2Sf4GO3oeAt8V+qV22O4chGe10p9AayNIWjkzBi16N2epJjNOiQNAF4aXiCUhNe0RtvujQY3h036Oml8++QQJBAPbKaQE0of2Lu6wN0205cnKFl+G0r3NSf6MSm9IHdL/JnlH6n/6VUIM36ezp4/nBe0FDh1wZDWwjdtLUsFWJjNkCQQCNcZvJ0f/jMHFTos5vNqfgrBUz1fDnumAPDqW9cWBT+M/Bo8mRd2NWqQ3bgX5AzBnbqz3jbqihv+m5TEpU9eVHAkBN45w4cTAfIZbduo9cDaF9W4SQC8LEFumJwjnDk+7ZCP0ayorsgpuijmcaCseU7+fCtVlnS9DcrGS4LcBpfrwhAkAZU6l4pvCx5p+0QSfDxD6lPUsCoCFl7Pp8V7wXwvBjuN7CpqhWMtGH1/eSQYqw4ZsTuYL4cX0ikXGxa1a4BdvLAkANyNUV0e/f65wbSJh+0FhNt33r+avhnRFBFyyOZkpQXqAgBORWODx42g5ppwOfgajllIXVDVPEXYJ3es/v8xjC

}

