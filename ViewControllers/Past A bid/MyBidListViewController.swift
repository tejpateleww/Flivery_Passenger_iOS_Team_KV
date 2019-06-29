//
//  MyBidListViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MyBidListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        return 3//arrTicketList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "MyBidListViewCell") as! MyBidListViewCell
        
        customCell.selectionStyle = .none
//        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
//
//        //
//        //
//        customCell.lblTicketID.text = "Ticket ID: \(dictData["TicketId"] as! String)"
//        customCell.lblTitle.text = dictData["TicketTitle"] as! String
//        let StrStatus = dictData["Status"] as! String
//
//        if StrStatus == "0"
//        {
//            customCell.lblStatus.text = "Pending"
//        }
//        if StrStatus == "1"
//        {
//            customCell.lblStatus.text = "Processing"
//        }
//        if StrStatus == "2"
//        {
//            customCell.lblStatus.text = "Complete"
//        }
//
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
//
//        //
//        //
//
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        viewController.strTicketID = dictData["TicketId"] as! String
//        viewController.strTicketTile = dictData["TicketTitle"] as! String
//
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
         let dictData = arrReviewData[indexPath.row]
         if let cell = tblView.cellForRow(at: indexPath) as? HelpListViewCell
         {
         cell.lblDescription.isHidden = !cell.lblDescription.isHidden
         if cell.lblDescription.isHidden
         {
         expandedCellPaths.remove(indexPath)
         cell.lblDescription.text = ""
         cell.iconArrow.image = UIImage.init(named: "arrow-down-leftBlue")
         cell.viewCell.layer.borderColor = UIColor.clear.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         else
         {
         expandedCellPaths.insert(indexPath)
         cell.lblDescription.text = dictData["Answers"] as? String
         cell.iconArrow.image = UIImage.init(named: "arrow-down-Blue")
         cell.viewCell.layer.borderColor = UIColor.black.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         
         DispatchQueue.main.async {
         self.tblView.beginUpdates()
         self.tblView.endUpdates()
         }
         
         //            DispatchQueue.main.async {
         //                self.tableView.reloadRows(at: [indexPath], with: .automatic)
         //            }
         
         }
         */
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 210
        // UITableViewAutomaticDimension
    }

}
