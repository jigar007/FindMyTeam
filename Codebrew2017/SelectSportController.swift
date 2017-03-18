//
//  Profile.swift
//  Codebrew2017
//
//  Created by Changchang on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import Firebase
import UIKit


class SelectSportController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellId = "cellId"
    
    var currentUid = String()
    var currentUsername = String()

    var sports = ["Football", "Basketball", "Tennies"]
    var sendingSports = [String]()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Send To...", style: .plain, target: self, action: #selector(handleCancle))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(r: 55, g: 179, b: 229)
        navigationController?.navigationBar.isTranslucent = false
        setupTableView()
        
    }
    
    let bottomSelectView: UIView = {
        let bs = UIView()
        bs.backgroundColor = UIColor(colorLiteralRed: 55/255, green: 179/255, blue: 229/255, alpha: 1)
        bs.translatesAutoresizingMaskIntoConstraints = false
        return bs
    }()
    
    lazy var sendButtonView: UIImageView = {
        let sb = UIImageView()
        sb.image = UIImage(named: "send-button")?.withRenderingMode(.alwaysTemplate)
        sb.tintColor = UIColor.white
        sb.isUserInteractionEnabled = true
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))
        return sb
    }()
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.register(SendToCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setSendBar() {
        // Set bottom select view
        view.addSubview(bottomSelectView)
        bottomSelectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomSelectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomSelectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomSelectView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Set send button
        bottomSelectView.addSubview(sendButtonView)
        sendButtonView.centerYAnchor.constraint(equalTo: bottomSelectView.centerYAnchor).isActive = true
        sendButtonView.centerXAnchor.constraint(equalTo: bottomSelectView.rightAnchor, constant: -30).isActive = true
        sendButtonView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        sendButtonView.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    func handleSend() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.currentUid = uid

            
            let ref = FIRDatabase.database().reference().child("users").child(uid).child("sport")
            for i in 0..<sendingSports.count {
                let sportRef = ref.child(String(i))
                sportRef.updateChildValues(["name": sendingSports[i]], withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    } else {
//                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                })
            }
     
            
        }
        
        
    }
    
    
    func handleCancle() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = sports[indexPath.item]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if sendingSports.count == 0 {
            setSendBar()
        }
        
        sendingSports.append((cell?.textLabel?.text)!)
        
        print(sendingSports)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        sendingSports = sendingSports.filter({ $0 != (cell?.textLabel?.text)!})
        
        if sendingSports.count == 0 {
            sendButtonView.removeFromSuperview()
            bottomSelectView.removeFromSuperview()
        }
        print(sendingSports)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Tell us your favuorite sports" : ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.init(r: 23, g: 141, b: 254)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        header.backgroundView = UIView()
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class SendToCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .blue
        tintColor = UIColor(r: 55, g: 179, b: 229)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    var isStoryCell = false
//    var user = User()
}
