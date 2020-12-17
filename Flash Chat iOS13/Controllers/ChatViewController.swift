

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessagesFromDb()
    }
    
    func loadMessagesFromDb() {
        
        messages = []
        
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents {
                    
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMEssage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMEssage)
                            self.updateUI()
                        }
                    }
                }
            }
        }
    }
    
    func updateUI() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let sender = Auth.auth().currentUser?.email,
           let messageBody = messageTextfield.text {
            db.collection(K.FStore.collectionName).addDocument(data:
                                                                [K.FStore.senderField : sender,
                                                                 K.FStore.bodyField: messageBody]) { (error) in
                
                if let e = error {
                    print(e)
                } else {
                    print("Success")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true )
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row].body
        cell.messageBubbleText.text = message 
        return cell
    }
}

