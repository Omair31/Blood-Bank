//
//  DonorViewController.swift
//  BloodBank2
//
//  Created by Omeir on 16/05/2017.
//  Copyright © 2017 Omeir. All rights reserved.
//

import UIKit

class DonorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var donorTableView: UITableView!
    var array = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = "Logged in as \(User.sharedInstance.userName)"
       
       
        self.donorTableView.delegate = self
        self.donorTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "donorCell") as! DonorTableViewCell!
        cell?.userNameLabel.text = array[indexPath.row]["UserName"]! as? String
        cell?.userContactLabel.text = array[indexPath.row]["Contact"]! as? String
        cell?.userBloodGroupLabel.text = array[indexPath.row]["BloodGroup"]! as? String
        cell?.userRHValueLabel.text = array[indexPath.row]["RHValue"]! as? String
        cell?.userTypeLabel.text = array[indexPath.row]["UserType"]! as? String
        
    return cell!
        
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
