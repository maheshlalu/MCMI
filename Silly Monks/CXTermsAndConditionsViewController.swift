//
//  CXTermsAndConditionsViewController.swift
//  Silly Monks
//
//  Created by NUNC on 5/30/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXTermsAndConditionsViewController: UIViewController,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeHeaderView()
        self.customizeMainView()

        // Do any additional setup after loading the view.
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(CXTermsAndConditionsViewController.backAction), forControlEvents: .TouchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Terms and Conditions"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func customizeMainView() {
        let headerLabel = UILabel.init(frame: CGRectMake(5, 0, self.view.frame.size.width-10, 40))
        headerLabel.font = UIFont(name: "Roboto-Bold",size: 18)
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.text = "Terms and Conditions"
        self.view.addSubview(headerLabel)
        
        
        let cView = UIView.init(frame:CGRectMake(5, headerLabel.frame.origin.y+headerLabel.frame.size.height+5, self.view.frame.size.width-10, self.view.frame.size.height-(headerLabel.frame.origin.y+headerLabel.frame.size.height+80)))
        cView.backgroundColor = UIColor.whiteColor()
        cView.layer.cornerRadius = 8.0
        cView.layer.masksToBounds = true
        self.view.addSubview(cView)
        
        let contentView = UITextView.init(frame: CGRectMake(5, 5, cView.frame.size.width-10, cView.frame.size.height-10))
        contentView.delegate = self
        contentView.editable = true
        contentView.dataDetectorTypes = UIDataDetectorTypes.All
        contentView.showsVerticalScrollIndicator = false
        contentView.font = UIFont(name: "Roboto-Regular",size: 14)
        contentView.textColor = UIColor.grayColor()
        contentView.text = "Terms of Service\nPlease read the following terms and conditions very carefully.If you do not agree with the following terms and conditions, do not download, install or register to use the application.By downloading, installing or using this app or any portion thereof, you agree to the following terms and conditions.\n\n1. USE OF THE SILLY MONKS APPLICATION\nThis agreement (“Agreement”) is entered into between you (“You”) and Silly Monks Entertainment Media Pvt Ltd (“Silly Monks”). Subject to the terms and conditions of this Agreement, You are hereby granted the non-transferable right to use this software (“Silly Monks Application”) solely for personal, non-commercial purposes.\n\nYou may not use the Silly Monks Application in any manner that may impair, overburden, damage, disable or otherwise compromise (i) Silly Monks services; (ii) any other party’s use and enjoyment of Silly Monks services; or (iii) the services and products of any third parties (including, without limitation, the Authorized Device). You agree to comply with all local laws and regulations governing the downloading, installation and/or use of the Silly Monks Application, including, without limitation, any usage rules set forth in the online application store terms of service.\n\nFrom time to time, Silly Monks may automatically check the version of Silly Monks Application installed on the Authorized Device and, if applicable, provide updates for the Silly Monks Application (“Updates”). Updates may contain, without limitation, bug fixes, patches, enhanced functionality, plug-ins and new versions of the Silly Monks Application. By installing the Silly Monks Application, you authorize the automatic download and installation of Updates and agree to download and install Updates manually if necessary. Your use of the Silly Monks Application and Updates will be governed by this Agreement (as amended by any terms and conditions that may be provided with Updates).\n\nSilly Monks reserves the right to temporarily disable or permanently discontinue any and all functionality of the Silly Monks Application at any time without notice and with no liability to you.\n\nFor the avoidance of doubt, this Agreement is solely between Silly Monks and You. If you need to contact Silly Monks about the Silly Monks Application, you may do so by calling +91 8008 12 12 36 or email us @ info@sillymonks.com.\n\n2. CONTENT DATA AND INFORMATION\nSilly Monks aggregates the content information data feed from various content providers and/or content created in house.\n\nYou understand that Silly Monks is just facilitating for you to view the information of the news, videos, and view/download images, etc.. Sometimes you may face irruptions due to various reasons to access content and Silly Monks doesn’t take any responsibility for such instances.\n\n3. PRIVACY POLICY\nAs a condition of using the Silly Monks Application, you agree to the terms of Silly Monks Privacy Policy. You acknowledge and agree that Silly Monks Privacy Policy and Silly Monks Terms of Use may be updated from time to time, without prior notice. Any such change(s) will be effective as soon as Silly Monks posts a revised version of the applicable Policy. In the event of an otherwise irreconcilable conflict between this Agreement and Silly Monks Terms of Service or Silly Monks Privacy Policy, this Agreement will govern, solely with regard to the conflicting provisions and solely to the extent of such conflict.\n\nSilly Monks may track and archive information regarding your use of the Silly Monks Application (“Use Information”). Use Information does not reveal your personal identity. Use Information may be stored and processed in the India or any other country in which Silly Monks or its agents maintain facilities. By using the Silly Monks Application, you consent to the collection of your User Information and to any transfer of your User Information outside of your country.\n\n4. TERMINATION\nYou may terminate this Agreement at any time by permanently deleting the Silly Monks Application in its entirety from the Authorized Device, whereupon (and without notice from Silly Monks) any rights granted to you herein will automatically terminate. If you fail to comply with any provision of this Agreement, any rights granted to you herein will automatically terminate. In the event of such termination, you must immediately delete the Silly Monks Application from the Authorized Device.\n\n5. INDEMNITY\nYou agree to hold harmless and indemnify Silly Monks and its subsidiaries, affiliates, officers, agents, and employees (and their subsidiaries, affiliates, officers, agents, and employees) from and against any claim, suit or action arising from or in any way related to your use of the Silly Monks Application or your violation of this Agreement, including any liability or expense arising from all claims, losses, damages, suits, judgments, litigation costs and attorneys’ fees, of every kind and nature. In such a case, Silly Monks will provide you with written notice of such claim, suit or action.\n\n6. DISCLAIMER OF WARRANTIES\nTHE SILLY MONKS APPLICATION IS PROVIDED ON AN “AS IS” BASIS AND WITHOUT WARRANTY OF ANY KIND. TO THE MAXIMUM EXTENT PERMITTED BY LAW, SILLY MONKS EXPRESSLY DISCLAIMS ALL WARRANTIES AND CONDITIONS OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.\n\nYOUR USE OF THE SILLY MONKS APPLICATION IS AT YOUR SOLE RISK. SILLY MONKS SHALL NOT BE OBLIGATED TO PROVIDE YOU WITH ANY MAINTENANCE OR SUPPORT SERVICES IN CONNECTION WITH THE SILLY MONKS APPLICATION.\n\n SILLY MONKS MAKES NO WARRANTY (I) THAT THE SILLY MONKS APPLICATION WILL MEET YOUR REQUIREMENTS; (II) THAT THE SILLY MONKS APPLICATION WILL BE ERROR-FREE; (III) REGARDING THE SECURITY, RELIABILITY, TIMELINESS, OR PERFORMANCE OF THE SILLY MONKS APPLICATION; AND (IV) THAT ANY ERRORS IN THE SILLY MONKS APPLICATION WILL BE CORRECTED.\n\nANY CONTENT OR MATERIAL YOU DOWNLOAD OR OTHERWISE OBTAIN THROUGH THE SILLY MONKS APPLICATION IS OBTAINED AT YOUR OWN DISCRETION AND RISK. YOU WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR AUTHORIZED DEVICE (OR ANY OTHER DEVICE) OR ANY LOSS OF DATA THAT MAY RESULT FROM DOWNLOADING ANY SUCH CONTENT OR MATERIAL.\n\nNO INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM SILLY MONKS OR THROUGH THE SILLY MONKS APPLICATION SHALL CREATE ANY WARRANTY NOT EXPRESSLY STATED IN THESE TERMS AND CONDITIONS.\n\n 7. LIMITATION OF LIABILITY\nYOU EXPRESSLY UNDERSTAND AND AGREE THAT SILLY MONKS SHALL NOT BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR EXEMPLARY DAMAGES, INCLUDING BUT NOT LIMITED TO, DAMAGES FOR LOSS OF PROFITS, GOODWILL, USE, DATA OR OTHER INTANGIBLE LOSSES (EVEN IF SILLY MONKS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES) RESULTING FROM: (I) THE USE OR THE INABILITY TO USE THE SILLY MONKS APPLICATION; (II) THE INABILITY TO USE THE SILLY MONKS APPLICATION TO ACCESS CONTENT OR DATA; (III) THE COST OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; (IV) UNAUTHORIZED ACCESS TO OR ALTERATION OF YOUR TRANSMISSIONS OR DATA; OR (V) ANY OTHER MATTER RELATING TO THE SILLY MONKS APPLICATION. THE FOREGOING LIMITATIONS SHALL APPLY NOTWITHSTANDING A FAILURE OF ESSENTIAL PURPOSE OF ANY LIMITED REMEDY AND TO THE FULLEST EXTENT PERMITTED BY LAW.\n\n8. EXCLUSIONS AND LIMITATIONS\nNOTHING IN THIS AGREEMENT IS INTENDED TO EXCLUDE OR LIMIT ANY CONDITION, WARRANTY, RIGHT OR LIABILITY WHICH MAY NOT BE LAWFULLY EXCLUDED OR LIMITED. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF CERTAIN WARRANTIES OR CONDITIONS OR THE LIMITATION OR EXCLUSION OF LIABILITY FOR LOSS OR DAMAGE CAUSED BY NEGLIGENCE, BREACH OF CONTRACT OR BREACH OF IMPLIED TERMS, OR INCIDENTAL OR CONSEQUENTIAL DAMAGES. ACCORDINGLY, ONLY THE ABOVE LIMITATIONS IN SECTIONS 10 AND 11 WHICH ARE LAWFUL IN YOUR JURISDICTION WILL APPLY TO YOU AND SILLY MONKS LIABILITY WILL BE LIMITED TO THE MAXIMUM EXTENT PERMITTED BY LAW.\n\n9. ENTIRE AGREEMENT; REVISIONS TO AGREEMENT.\nSilly Monks may, from time to time, modify this Agreement. Such modifications shall be effective as soon as the modified version of the “Silly Monks Application Terms and Conditions” is posted in the online application store or any other authorized Silly Monks Application distribution location. You can determine when this Agreement was last revised by referring to the “LAST UPDATED” legend at the top of then-current version of the “Silly Monks Mobile Application Terms and Conditions” in the online application store or any other authorized Silly Monks Application distribution location. Your use of Silly Monks Application following such changes constitutes Your acceptance of the revised version of the “Silly Monks Mobile Application Terms and Conditions” in the online application store or any other authorized Silly Monks Application distribution location. \n\n10. MISCELLANEOUS PROVISIONS\nThis Agreement and the legal relations between the parties hereto shall be governed by and construed in accordance with the laws of Government of India, without reference to its conflict-of-laws principles. The parties hereto, their successors and assigns, consent to the jurisdiction of the courts of Hyderabad, India with respect to any legal proceedings related to this Agreement, and waive any objection to the propriety or convenience of venue in such courts.\n\n11.QUESTIONS\nPlease contact us at info@sillymonks.com if you have any questions about our terms of use. Effective: March 30th 2016\n\n@ 2016 Silly Monks Entertainment Pvt Ltd. All Rights Reserved"
        
        cView.addSubview(contentView)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
