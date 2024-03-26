
![seerbit](https://user-images.githubusercontent.com/74198009/230321289-beb6c9ec-6d29-4d79-84cb-abb0606a23ab.png)
                                                      


 # SeerBit Native Ios SDK
 
SeerBit Native ios sdk is used to seamlessly integrate SeerBit payment gateways into Native ios applications. It is very simple and easy to integrate. It is completely built with SwiftUI, and also integrates with UIKKit projects.

## Requirements:

- The merchant must have an account with SeerBit or create one on [SeerBit Merchant Dashboard](https://www.dashboard.seerbitapi.com/#/auth/login) to get started.
- Obtain the live public key of the merchant.

## Implementation:

- Add the package to your SwiftUI or UIKit project using Swift package manager using the following url: 

```
https://github.com/seerbit-developers/SeerBitCheckout
```

- If you prefer to add the project through cocoapods, go to your podfile and add like so:

```
pod 'SeerBitCheckout', '~> 1.2.9'
```
Note that you can always get the latest version from 
```
https://cocoapods.org/pods/SeerBitCheckout
```
- Then at the root of your project, run 

```
pod install
```
 - If you encounter an error that the description contains 
 ```
 Sandbox: deny(1) file-write-create 
 ```
 Then go to build settings, under Build Options and switch User Script Sandboxing to "No"
 

- After adding the package to your project (either through SPM or Cocoapods), import SeerBitCheckout into the file you want to use it.

### Configure deeplink in your project

- Add deeplink configuration to your project with the following custom uri scheme:

```
seerbitioscheckout
```
- The most straightforward way to add a deeplink is to click on the info tab when you select your project target. Click on the URL Types chevron and paste "seerbitioscheckout" on URL Schemes placeholder.
- This sdk works for iOS 16.0 and above. Make sure your project is targeting iOS 16.0 and above.
- Note that if you already have a url scheme for your project, you still have to create another one with the custom url scheme above.
 
 ## Usage: These parameters must be supplied to the starting struct, InitSeerbitCheckout();
 
  ### Required:
  
 - Merchant's live public key // SBTESTPUBK_t4G16GCA1O51AV0Va3PPretaisXubSw1 (This a test public key for test purpose)
 - Amount
 - Customer's full name
 - Customer's email
 - Customer's phone number
 
 ### Optional
 
 - productId // defaults to empty string
 - vendorId //defaults to empty string
 - currency //defaults to merchant's country currency
 - country //defaults to merchant's country
 - pocketReference // used when money is to be moved to pocket
 - transactionPaymentReference //we generate payment reference for each transaction, but if you supply yours, the sdk will use it.
 - tokenize // used only when card is to be tokenized -  defaults to false
 - productDescription //defaults to empty string


 ## Example
 
 ### SwiftUi project:
 
 ```
import SwiftUI
import SeerBitCheckout


struct ContentView: View {
    
    @State private var transactionStatusData: QueryTransactionDataModel? = nil
    
    @State var fullName: String = ""
    @State var publicKey: String = ""
    @State var email: String = ""
    @State var mobileNumber: String = ""
    @State var amount: String = ""
    
    @State var startCheckout = false
    
    
    var body: some View {
        VStack{
            if(startCheckout) {
                InitSeerbitCheckout(
                    amount: amount,
                    fullName:fullName,
                    mobileNumber:mobileNumber,
                    publicKey: publicKey,
                    email:email
                )
            }else{
                VStack{
                    Spacer().frame(height: 30)
                    Image(.checkoutLogo)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    Spacer().frame(height: 70)
                    CustomInput(value: $fullName, placeHolder: "Full name")
                    Spacer().frame(height: 30)
                    CustomInput(value: $publicKey, placeHolder: "publicKey")
                    Spacer().frame(height: 30)
                    CustomInput(value: $email, placeHolder: "email")
                    Spacer().frame(height: 30)
                    CustomInput(value: $mobileNumber, placeHolder: "mobileNumber")
                    Spacer().frame(height: 30)
                    CustomInput(value: $amount, placeHolder: "amount")
                    Spacer().frame(height: 100)
                    
                    Button("Start SeerBit checkout"){startCheckout = true}
                    Spacer()
                }
                .padding(20)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(NotificationListenerConstants.closeCheckout.rawValue))) { data in
            // This block will be executed when the specified notification is received
            
            if let jsonData = data.userInfo?[NotificationListenerConstants.jsonData.rawValue] as? Data,
               let decodedData = try? JSONDecoder().decode(QueryTransactionDataModel?.self, from: jsonData) {
                transactionStatusData = decodedData
                print(decodedData, "data on sdk close")
                startCheckout = false
            }else{ startCheckout = false}
        }
    }
}


struct CustomInput: View {
    @State var textForegroundColor:Color =  Color.black
    @State var backgroundColor: Color = Color.black
    @Binding  var value: String
    @State  var placeHolder: String
    @State var rightText: String = ""
    @State var borderWidth: Int = 2
    
    @State var keyboardType: UIKeyboardType = .default
    
    
    var body: some View {
        HStack{
            TextField(placeHolder, text: $value)
                .foregroundStyle(textForegroundColor)
                .fontWeight(.regular)
                .font(.system(size: 12))
                .keyboardType(keyboardType)
            Spacer()
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 12)
        .border(Color.gray, width: CGFloat(borderWidth))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
} 

 ```
 
 - The above code will live on any screen from which you wish to start the SeerBit checkout.
 - The transactionStatusData paramater holds successful transaction response data, incase the developer wants to use the data.
 - The .onReceive listens to the checkout for close command, and returns with transactionStatusData if any. It must be implemented as seen in the example.
 
 
 ### UIKit project:
 
 ```
 import UIKit
import SwiftUI
import SeerBitCheckout

class ViewController: UIViewController {
    
    let transactionStatusData: QueryTransactionDataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.setTitle("Load checkout", for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
        // Add observer for the custom notification
        NotificationCenter.default.addObserver(
            forName: Notification.Name(NotificationListenerConstants.closeCheckout.rawValue),
            object: nil,
            queue: nil
        ){ notification in
                
                if let jsonData = notification.userInfo?[NotificationListenerConstants.jsonData.rawValue] as? Data,
                   let decodedData = try? JSONDecoder().decode(QueryTransactionDataModel.self, from: jsonData) {
                    // Handle the decoded data
                    print(decodedData,"transaction response")
                    //close the checkout after
                    self.didCloseSdk()
                }else{
                    //you can perform any custom logic here, after which you close the sdk
                    self.didCloseSdk()
                }
            }
    }
    
    
    @objc func didTapButton() {
        let initSeerbitCheckout = InitSeerbitCheckout(
            amount: 200,
            fullName: "UIKit example",
            mobileNumber: "09098987676",
            publicKey: "business public key",
            email: "String@gmail.com"
        )
        
        let hostingController = UIHostingController(rootView: initSeerbitCheckout)
        present(hostingController, animated: true)
    }
    
    @objc func didCloseSdk() {
        // Dismiss the presented hosting controller
           dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

 
 ```
 
 - The above code represents a sample View Controller from where you wish to start the SeerBit checkout
 - Make sure to setup the Notification center observer to listen to command from the sdk to close, and also have access to successful transaction data if any.
 -  Make sure to call the deinit block to remove the Notification listener to avoid memory leaks.
 - The code inside the didTapButton block can exist anywhere from whose action you want to start the checkout

## Properties:

| Property                    | type     | required  | default | Desc                                                                        |
|-----------------------------|----------|-----------|---------|-----------------------------------------------------------------------------|
| currency                    | String   | Optional  | NGN     | The currency for the transaction e.g NGN                                    |
| email                       | String   | Required  | None    | The email of the user to be charged                                         |
| publicKey                   | String   | Required  | None    | Your Public key or see above step to get yours                              |
| amount                      | String   | Required  | None    | The transaction amount                                                      |
| fullName                    | String   | Required  | None    | The fullname of the user to be charged                                      |
| phoneNumber                 | String   | Required  | None    | User phone Number                                                           |
| pocketReference             | String   | Optional  | None    | This is your pocket reference for vendors with pocket                       |
| vendorId                    | String   | Optional  | None    | This is the vendorId of your business using pocket                          |
| tokenize                    | bool     | Optional  | False   | Tokenize card                                                               |
| country                     | String   | Optional  | NG      | Transaction country which can be optional                                   |
| transactionPaymentReference | String   | Optional  | None    | Set a unique transaction reference for every transaction                    |
| productId                   | String   | Optional  | None    | This is the productId which is optional                                     |
| productDescription          | String   | Optional  | None    | The transaction description which is optional                               |

 
 ## Support:
 
 If you encounter any problems, or you have questions or suggestions, create an issue on this repo or send your inquiry to developers@seerbit.com
 
