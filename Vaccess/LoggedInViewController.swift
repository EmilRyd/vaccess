//
//  LoggedInViewController.swift
//  Vaccess
//
//  Created by Emil Ryd on 2020-06-20.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

//
//  LoggedInViewController.swift
//  QuickStartExampleApp
//
//  Created by emil on 2019-10-21.
//  Copyright © 2019 Back4App. All rights reserved.
//

import UIKit
import Parse

class LoggedInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate /*UITableViewDelegate, UITableViewDataSource*/ {
   /* func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Vaccine.allValues.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifierare = "ProtectionTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? ProtectionTableViewCell else {
            fatalError("The dequeued cell is not an instance of VaccineTableViewCell.")
        }
        let vaccine = Vaccine.allValues[indexPath.row]

        cell.namnEtikett.text = vaccine.simpleDescription()
        let vaccinationtabBarController = tabBarController as! VaccinationTabBarController
        if vaccinationtabBarController.coverageForThisVaccine(vaccine: Vaccine.allValues[indexPath.row]) == 2 {
            cell.timeView.backgroundColor = .green

        }
        else if vaccinationtabBarController.coverageForThisVaccine(vaccine: Vaccine.allValues[indexPath.row]) == 0{
            cell.timeView.backgroundColor = .red

        }
        
        if vaccine.isRecommended()
        {
            cell.contentView.backgroundColor = UIColor(displayP3Red: 0.35, green: 0.78, blue: 0.98, alpha: 0.2)
        }
        else {
            cell.contentView.backgroundColor = .white
        }
        
        return cell
    }*/
    
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statisticsWheel1: CircularLoaderView!
    
    @IBOutlet weak var barChartStackViewProgressLabel1: UILabel!
    @IBOutlet weak var barChartStackView1: BarChartStackView!
    @IBOutlet weak var statisticsWheel3: CircularLoaderView!
    @IBOutlet weak var statisticsWheel1Label: UILabel!
    @IBOutlet weak var statisticsWheel3Label: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    let shapeLayer = CAShapeLayer()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    /*var statisticsWheel1: CircularLoaderView? = nil
    var statisticsWheel2: CircularLoaderView? = nil
    var statisticsWheel3: CircularLoaderView? = nil*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load data
        self.loadUserDefaults()

        
        //Checking if first time viewer has logged in to app
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController

        if let VC = (self.presentingViewController as? VaccinationProgramViewController) {
            self.changeVaccinationProgramStatus(previousVaccinationProgramIndicator: nil)
        }
        
        
        self.view.insetsLayoutMarginsFromSafeArea = false
        self.modalPresentationStyle = .fullScreen
        loadUserInformation()
        /*view.preservesSuperviewLayoutMargins = false

        viewWillLayoutSubviews()
        print("Profile Image Frame + \(profileImage.frame)")*/
        
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Profil"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()

        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Tillbaka", style: .plain, target: nil, action: nil)

        
        
        
       
        statisticsWheel1!.handleTap(numerator: Double(vaccinationTabBarController.vaccinationsTakenInTime.count), denominator: Double(vaccinationTabBarController.allVaccinations.count))
        
        self.view.bringSubviewToFront(barChartStackViewProgressLabel1)
        
        barChartStackView1!.handleTap(increase: true)
        barChartStackViewProgressLabel1.text = String(vaccinationTabBarController.allVaccinations.count)
        
        let allVPVs = Double(vaccinationTabBarController.getAllVaccinationProgramVaccinations().count)
        let takenVPVs = vaccinationTabBarController.getPercentageOfVaccinationProgramTaken() * allVPVs
        statisticsWheel3!.handleTap(numerator: takenVPVs, denominator: allVPVs)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //appDelegate?.startPushNotifications()
        
        
        if let image = UserDefaults.standard.object(forKey: "ProfileImage") as? UIImage {
            profileImage.image = image
        }
       // loadStatisticsWheels()
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        statisticsWheel1!.handleTap(numerator: Double(vaccinationTabBarController.vaccinationsTakenInTime.count), denominator: Double(vaccinationTabBarController.allVaccinations.count))
        
        barChartStackView1!.handleTap(increase: true)
barChartStackViewProgressLabel1.text = String(vaccinationTabBarController.allVaccinations.count)
        
        let allVPVs = Double(vaccinationTabBarController.getAllVaccinationProgramVaccinations().count)
        let takenVPVs = vaccinationTabBarController.getPercentageOfVaccinationProgramTaken() * allVPVs
        statisticsWheel3!.handleTap(numerator: takenVPVs, denominator: allVPVs)

        
        //Fixing based on settings changes

        
        
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statisticsWheel1!.handleTap(numerator: 0, denominator: 0)
        barChartStackView1!.handleTap(increase: false)
        

        statisticsWheel3!.handleTap(numerator: 0, denominator: 0)
    }
    
    
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func loadLoginScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "VaccineLogInViewController") as! VaccineLogInViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func logoutOfApp(_ sender: UIBarButtonItem) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.saveUserDefaults()
        
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }else{
                    self.displayErrorMessage(message: "error logging out")
                }
                
            }
        }
    }    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    //MARK: ImagePickerControllerDelegate methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       // guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
        //    fatalError("Expected a dictionairy with an image, but got this: \(info)")
       // }
        profileImage.restorationIdentifier = "Yes"
        profileImage.contentMode = .scaleToFill
        
        
        profileImage.image = nil
        let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
        vaccinationTabBarController.profileImage = profileImage.image!
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Codable Protocol Functions
    func saveUserDefaults() {
        let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
        vaccinationTabBarController.save()
        
    }
    
    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        
        
        
        let vaccinationtabBarController = self.tabBarController as! VaccinationTabBarController
        
        vaccinationtabBarController.loadFrom(defaults: defaults)
    }
    
    /*private func loadCircles() {
        //Circle
        var i: CGFloat = 1
        var shapeLayer1 = CAShapeLayer()
        var shapeLayer2 = CAShapeLayer()
        var shapeLayer3 = CAShapeLayer()
        while i < 4 {
            let width = view.frame.width
            var position = width/4 * i
            if i == 1 || i == 3{
                let x = 2 - i
                position = position - 20 * x
            }
            // Create my track
            let trackLayer = CAShapeLayer()
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: position, y: 480), radius: 45, startAngle: -0.5 * CGFloat.pi, endAngle: 2 * CGFloat.pi, clockwise: true)
            trackLayer.path = circularPath.cgPath
            
            trackLayer.strokeColor = UIColor.lightGray.cgColor
            trackLayer.lineWidth = 10
            trackLayer.fillColor = UIColor.clear.cgColor
            
            
            trackLayer.lineCap = kCALineCapRound
            
            
            view.layer.addSublayer(trackLayer)
            
            
            //Circle
            
            shapeLayer.path = circularPath.cgPath
            
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 5
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            
            shapeLayer.lineCap = kCALineCapRound
            
            shapeLayer.strokeEnd = 0
            
            
            view.layer.addSublayer(shapeLayer)
            

            switch i {
            case 1:
                shapeLayer1 = shapeLayer
            case 2:
                shapeLayer2 = shapeLayer
            case 3:
                shapeLayer3 = shapeLayer
            default:
                print("Something went wrong with your loop in loadCircles()")
                
            }
            
            i += 1
        }
        
        handleTap(localShapeLayer: shapeLayer1)
        handleTap(localShapeLayer: shapeLayer2)
        handleTap(localShapeLayer: shapeLayer3)

        
        
        
    }
    
    func handleTap(localShapeLayer: CAShapeLayer) {
        print("Lägg den")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        localShapeLayer.add(basicAnimation, forKey: "urSoBASIC")
        
    }*/
    
    
    func loadStatisticsWheels() {
        let array = [statisticsWheel1Label,  statisticsWheel3Label]
        let titlesArray = ["Taget i tid", "Av vaccinationsprogrammet taget"]
        var i = 0
        while i < 2 {
            array[Int(i)]!.text = titlesArray[Int(i)]
            i += 1
            
        }
        statisticsWheel1Label = array[0]
        statisticsWheel3Label = array[1]

        /*while i < 4 {
            /*var position = width/4 * i
            if i == 1 || i == 3{
                let x = 2 - i
                position = position - 20 * x
            }
            
            array[Int(i - 1)] = CircularLoaderView(frame: CGRect(x: position, y: 510, width: 50, height: 50))
            array[Int(i - 1)] = CircularLoaderView(frame: CGRect(x: position + (array[Int(i - 1)]?.circleFrame().origin.x)!, y: 800, width: 50, height: 50))
            */

            let descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2 * array[Int(i-1)]!.frame.width, height: 40))
            descriptionLabel.adjustsFontSizeToFitWidth = true
            descriptionLabel.numberOfLines = 2
            descriptionLabel.font = UIFont(name: "Futura-CondensedMedium", size: 17.0)
            descriptionLabel.textAlignment = .center
            descriptionLabel.frame.origin.x = (array[Int(i-1)]?.frame.origin.x)! + (array[Int(i - 1)]?.circleFrame().origin.x)! - (descriptionLabel.frame.width - array[Int(i-1)]!.frame.width)/2
            descriptionLabel.frame.origin.y = (array[Int(i-1)]?.frame.origin.y)! + (array[Int(i - 1)]?.circleFrame().origin.y)! + array[Int(i-1)]!.frame.height
            print(array[Int(i - 1)]!.frame.origin.x)
            
            
            descriptionLabel.text = titlesArray[Int(i-1)]
            contentView.addSubview(descriptionLabel)
            print(descriptionLabel.frame)

            i += 1

        }*/
        
        
        /*contentView.addSubview(statisticsWheel1!)
        contentView.addSubview(statisticsWheel2!)
        contentView.addSubview(statisticsWheel3!)*/
        
        
        
/*progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
progressLabel.adjustsFontSizeToFitWidth = true
progressLabel.font = UIFont(name: "Futura-CondensedMedium", size: 17.0)
progressLabel.textAlignment = .center
progressLabel.frame.origin.x = circleTrackLayer.frame.midX - progressLabel.frame.width/2
progressLabel.frame.origin.y = circleTrackLayer.frame.midY - progressLabel.frame.height/2*/
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layoutMargins = .zero
        view.layoutMarginsDidChange()
    }
    
    
    @IBAction func unwindToLoggedInViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsViewController, let vaccinationProgramIndicatorWasChangedBool = sourceViewController.vaccinationProgramIndicatorWasInSettingsChangedThisSession, let previousVaccinationProgramIndicator = sourceViewController.previousVaccinationProgramIndicator {
            if vaccinationProgramIndicatorWasChangedBool {
                changeVaccinationProgramStatus(previousVaccinationProgramIndicator: previousVaccinationProgramIndicator)
                
                
            }
            sourceViewController.vaccinationProgramIndicatorWasInSettingsChangedThisSession = false
            
        }
        /*if let sourceViewController = sender.source as? SettingsViewController {
            if sourceViewController.personalInformationWasChanged {
                loadUserInformation()
                
            }
            
        }*/
        
        
        
        
        
    }
    
    private func loadUserInformation() {
        let user = PFUser.current()
        nameLabel.text = user?.object(forKey: "Name") as? String
        emailLabel.text = user?.email
        nameLabel.text = user?.object(forKey: "Name") as? String
    }
    
    
    private func changeVaccinationProgramStatus(previousVaccinationProgramIndicator: Int?) {
        let user = PFUser.current()
        let vaccinationProgramIndicator = user?.object(forKey: "VaccinationProgramIndicator") as! Int
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        switch vaccinationProgramIndicator {
        case 0:
            vaccinationTabBarController.setVaccinationProgramVaccinations()
        case 1:
            vaccinationTabBarController.setVaccinationProgramComingVaccinations()
        case 2:
            print("Yeeet")
        default:
            return
            
        }
        
        if previousVaccinationProgramIndicator != nil {
            switch previousVaccinationProgramIndicator {
            case 0:
                vaccinationTabBarController.deleteAllVaccinationProgramVaccinations()
            case 1:
                vaccinationTabBarController.deleteAllVaccinationProgramComingVaccinations()
            case 2:
                return
            default:
                return
            }
        }
        
        
    }
    
    

   /* @IBAction func sendPushToYourself(_ sender: UIBarButtonItem) {
        let cloudParams : [AnyHashable:String] = [:]
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFCloud.callFunction(inBackground: "sendPushToYourself", withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            UIViewController.removeSpinner(spinner: sv)
            if error != nil {
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }else{
                    self.displayErrorMessage(message: "error sending pushes to everyone")
                }
            }else{
                print(result as! String)
            }
        })
    }*/
}
