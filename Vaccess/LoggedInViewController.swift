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
import AnalogClock
import Lottie
class LoggedInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK: UITableViewDataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell") as! SettingsHeaderTableViewCell
        
        cell.setUp(title: sectionTitles[section])
        return cell.contentView
        
   
        
        /*let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 0.0))
        
        
        let icon = UIImageView(image: UIImage(named: "MinaVaccinationerImage"))
        icon.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(icon)
        
        let label = UILabel()
        
        label.text = sectionTitles[section]
        label.font = UIFont(name: "Futura-Medium", size: 12)
        label.sizeToFit()
        label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        
        
        return view*/
        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cellIdentifierare = "SettingsTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
            cell.subjectLabel.text = titles[indexPath.row]
            
            cell.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)
            /*switch user?.value(forKey: "VacciantionProgramIndicator") as! Int {
            case 1:
                switch indexPath.row {
                case 0:
                    cell.yesNoSegmentControl
                }
                cell.yesNoSegmentControl
            }*/
            
            let value = user1?.value(forKey: "VaccinationProgramIndicator") as? Int
            if value == indexPath.row {
                cell.yesNoSwitch.setOn(true, animated: true)
            }
            else {
                cell.yesNoSwitch.setOn(false, animated: true)
            }
            if cell.yesNoSwitch.isOn {
                cell.yesNoSwitch.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)
                
            }
            else {
                
                cell.yesNoSwitch.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)
                

            }
            
            
            
            return cell
        case 1:
            if indexPath.row == 0 {
                let cellIdentifierare = "SettingsPersonalInformationTableViewCell"

                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsPersonalInformationTableViewCell else {
                    fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
                }

                cell.titleLabel.text = "Min information"

                cell.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)

                cell.selectionStyle = .none
                return cell
            }
            else {
                let cellIdentifierare = "DataHandlingInformationTableViewCell"

                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? DataHandlingInformationTableViewCell else {
                    fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
                }

                cell.titleLabel.text = "Integritetspolicy"

                cell.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)

                cell.selectionStyle = .none
                return cell
            }
            
            
            

            
        case 2:
           let cellIdentifierare = "SettingsPersonalInformationTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsPersonalInformationTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
           cell.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)

           cell.titleLabel.text = "circlevaccess@gmail.com"
           cell.arrowView.isHidden = true
           cell.isUserInteractionEnabled = false
           

           
           
           
           return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)

            
            
            
            return cell
        }
        
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
          let cell = tableView.cellForRow(at: indexPath)
        if (tableView.cellForRow(at: indexPath) as? SettingsTableViewCell) != nil {
            return
        }
        
        cell?.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)

        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (tableView.cellForRow(at: indexPath) as? SettingsTableViewCell) != nil {
            return
        }
        
        cell?.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (tableView.cellForRow(at: indexPath) as? SettingsTableViewCell) != nil {
            return
        }
        
        cell?.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)   }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (tableView.cellForRow(at: indexPath) as? SettingsTableViewCell) != nil {
            return
        }
        
        cell?.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)
    }
    
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  //  @IBOutlet weak var moreButton: UIButton!
   // @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var clockView: AnalogClockView!
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var clockViewLabel: UILabel!
    @IBOutlet weak var barChartStackViewProgressLabel1: UILabel!
    @IBOutlet weak var barChartStackView1: BarChartStackView!
    @IBOutlet weak var statisticsWheel3: CircularLoaderView!
    @IBOutlet weak var statisticsWheel1Label: UILabel!
    @IBOutlet weak var statisticsWheel3Label: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
   // var settingsButtonCenter: CGPoint!
    var logoutButtonCenter: CGPoint!
    var shouldRenderAnimation = true
    let shapeLayer = CAShapeLayer()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    /*var statisticsWheel1: CircularLoaderView? = nil
    var statisticsWheel2: CircularLoaderView? = nil
    var statisticsWheel3: CircularLoaderView? = nil*/
    
    //MARK: Settings and Table View variables
    let sectionTitles = ["Vaccinationsprogrammet", "Mina uppgifter", "Kontakt"]
    let titles = ["Har genomgått hela vaccinationsprgrammet för barn", "Vill genomgå vaccinationsprogrammet för barn", "Har inte genomgått vaccinationsprogrammet och vill inte göra det"]
    var previousVaccinationProgramIndicator: Int!
    
    var vaccinationProgramIndicatorWasInSettingsChangedThisSession: Bool?
    var personalInformationWasChanged = false
    
    var changeWasSelected = false
    
    var sectionHeaderHeight: CGFloat = 0.0

    
    let alertService = AlertService()
    
    var user1 = PFUser.current()



    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table view and Settings stuff
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        
        settingsTableView.backgroundColor = .clear
        
        vaccinationProgramIndicatorWasInSettingsChangedThisSession = false
        
        sectionHeaderHeight = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell")?.contentView.bounds.height ?? 0
        
        //Set up animation
        //animationView = .init(name: "hourglass")
        //animationView?.frame = clockView.bounds
        
        //animationView?.loopMode = .playOnce
        //animationView.animationSpeed = 0.5
        //animationView.sizeToFit()
        //animationView.contentMode = .scaleToFill
        //contentView.addSubview(animationView!)
       // animationView.backgroundColor = .blue
       // animationView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //contentView.bringSubviewToFront(animationView!)
       // animationView?.play()
        //Load data
        
        
        //self.loadUserDefaults()
        
        
        
        //Fix moreButton
        /*let height: CGFloat = 56.0
        moreButton.backgroundColor = Theme.accent
        moreButton.layer.cornerRadius = moreButton.frame.height / 2
        moreButton.layer.shadowOpacity = 0.25
        moreButton.layer.shadowRadius = 5
        moreButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        moreButton.frame = CGRect(x: UIScreen.main.bounds.width - 24 - height, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
        moreButton.imageView?.tintColor = .black
        
        //Fix settingsButton
       
        settingsButton.backgroundColor = .lightGray
        settingsButton.layer.cornerRadius = height / 2
        settingsButton.layer.shadowOpacity = 0.25
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        settingsButton.frame = CGRect(x: UIScreen.main.bounds.width - 24 - height, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49) - height - 24, width: height, height: height)
        settingsButton.imageView?.tintColor = .darkGray
        
        
        settingsButtonCenter = settingsButton.center
        
        settingsButton.center = moreButton.center*/
        
        //Fix logoutButton
        let height: CGFloat = 56
        logoutButton.backgroundColor = Theme.secondary
        logoutButton.imageView?.frame = logoutButton.frame
        
        logoutButton.layer.cornerRadius = height / 2
        logoutButton.layer.shadowOpacity = 0.25
        logoutButton.layer.shadowRadius = 5
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 10)
                logoutButton.imageView?.tintColor = .white
        
        //logoutButtonCenter = logoutButton.center
        
        //logoutButton.center = moreButton.center
        
        //Fix navBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.backgroundColor = Theme.primary
        //self.navigationController?.navigationBar.barTintColor = Theme.primary

        


        
        
        
        //Checking if first time viewer has logged in to app
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController

        if let VC = (self.presentingViewController as? VaccinationProgramViewController) {
            vaccinationTabBarController.changeVaccinationProgramStatus(previousVaccinationProgramIndicator: nil)
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

        
        
        
       
       // statisticsWheel1!.handleTap(numerator: Double(vaccinationTabBarController.vaccinationsTakenInTime.count), denominator: Double(vaccinationTabBarController.allVaccinations.count))
        
        //clockView.bringSubviewToFront(clockViewLabel)
        //clockViewLabel.adjustsFontSizeToFitWidth = true
    
        fixClockLabels()
         
        
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
        if shouldRenderAnimation {
            let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
                 //   statisticsWheel1!.handleTap(numerator: Double(vaccinationTabBarController.vaccinationsTakenInTime.count), denominator: Double(vaccinationTabBarController.allVaccinations.count))
                    
                    barChartStackView1!.handleTap(increase: true)
            barChartStackViewProgressLabel1.text = String(vaccinationTabBarController.allVaccinations.count)
                    
                    let allVPVs = Double(vaccinationTabBarController.getAllVaccinationProgramVaccinations().count)
                    let takenVPVs = vaccinationTabBarController.getPercentageOfVaccinationProgramTaken() * allVPVs
                    statisticsWheel3!.handleTap(numerator: takenVPVs, denominator: allVPVs)
        }
        animationView?.play()

        shouldRenderAnimation = true
        
          fixClockLabels()

        //Fixing based on settings changes

        
        
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // statisticsWheel1!.handleTap(numerator: 0, denominator: 0)
        barChartStackView1!.handleTap(increase: false)
        
        
        statisticsWheel3!.handleTap(numerator: 0, denominator: 0)
        shouldRenderAnimation = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // returnButtonsToOrigin()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingsTableView.reloadData()

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
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
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
    }
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         /*if segue.identifier == "presentPersonalInformationViewController" {
             let changePersonalInformationViewControllerNavigationController = segue.destination as! UINavigationController
             let changePersonalInformationViewController = changePersonalInformationViewControllerNavigationController.viewControllers[0] as! ChangePersonalInformationViewController
             changePersonalInformationViewControllerNavigationController.modalPresentationStyle = .fullScreen
             changePersonalInformationViewController.modalPresentationStyle = .fullScreen
         }*/
         
         

         //let loggedInViewController = segue.destination as! LoggedInViewController
        // loggedInViewController.vaccinationProgramIndicatorWasChangedInSettingsThisSession = self.vaccinationProgramIndicatorWasInSettingsChangedThisSession!
         
     }
    
    @IBAction func unwindToSettingsViewController(for segue: UIStoryboardSegue, sender: Any?) {
        //Don´t really know what to do here yet
        var i = 0
        while i < settingsTableView.numberOfSections {
           var x = 0
            while x < settingsTableView.numberOfRows(inSection: i) {
                settingsTableView.cellForRow(at: IndexPath(row: x, section: i))?.isSelected = false
                x += 1
            }
            i += 1
        }
        
        
        guard let changePersonalInformationViewController = segue.source as? ChangePersonalInformationViewController else {
            settingsTableView.reloadData()

            return
        }
        if changePersonalInformationViewController.informationWasChanged {
            loadUserInformation()
        }
        
        settingsTableView.reloadData()


        
    }
     
    
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
            trackLayer.fillColor = Theme.secondaryLight.withAlphaComponent(0.2).cgColor
            
            
            trackLayer.lineCap = kCALineCapRound
            
            
            view.layer.addSublayer(trackLayer)
            
            
            //Circle
            
            shapeLayer.path = circularPath.cgPath
            
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 5
            shapeLayer.fillColor = Theme.secondaryLight.withAlphaComponent(0.2).cgColor
            
            
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
        if let sourceViewController = sender.source as? ChangePersonalInformationViewController {
            let personalInfoWasChanged = sourceViewController.informationWasChanged
            if personalInfoWasChanged {
                
                loadUserInformation()
            }
            
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
   /* @IBAction func moreButtonPressed(_ sender: UIButton) {
        print("Svina")
        if settingsButton.center == moreButton.center {
            UIView.animate(withDuration: 0.3) {
                self.settingsButton.alpha = 1
                self.logoutButton.alpha = 1
                
                self.settingsButton.center = self.settingsButtonCenter
                self.logoutButton.center = self.logoutButtonCenter
                //self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                self.moreButton.imageView?.tintColor = .white
                self.moreButton.backgroundColor = .black
            }
            

        }
        else {
            returnButtonsToOrigin()
        }
    }
    func returnButtonsToOrigin() {
        UIView.animate(withDuration: 0.3) {
            //self.settingsButton.alpha = 0
            self.logoutButton.alpha = 0
            //self.settingsButton.center = self.moreButton.center
            self.logoutButton.center = self.moreButton.center
            //self.moreButton.transform = CGAffineTransform(rotationAngle: 0)
            
            self.moreButton.imageView?.tintColor = .black
            self.moreButton.backgroundColor =  Theme.accent

        }
    }*/
    func fixClockLabels() {
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        let timeTillNextVaccination = vaccinationTabBarController.timeTillNextComingVaccination()
        if timeTillNextVaccination == nil {
            clockViewLabel.text = "0"
            statisticsWheel1Label.text = "Kommande vaccinationer"
        }
        else {
            switch timeTillNextVaccination!.days {
            
            case 0...31:
                clockViewLabel.text = "\(timeTillNextVaccination!.days)"
                if timeTillNextVaccination!.days == 1 {
                    statisticsWheel1Label.text = "Dag till nästa vaccin kan tas"

                }
                else {
                    statisticsWheel1Label.text = "Dagar till nästa vaccin kan tas"

                }

            case (-31)...(-1):
                clockViewLabel.text = "0"
                statisticsWheel1Label.text = "Dagar till nästa vaccin kan tas"

            default:
                switch timeTillNextVaccination!.months {
                case let x where x >= 12:
                    
                    clockViewLabel.text = "\(timeTillNextVaccination!.years)"
                    statisticsWheel1Label.text = "År till nästa vaccin kan tas"
                    if timeTillNextVaccination!.years > 99 {
                        clockViewLabel.adjustsFontSizeToFitWidth = true
                    }
                case let x where x <= -12:
                    clockViewLabel.text = "0"
                    statisticsWheel1Label.text = "Dagar till nästa vaccin kan tas"
                case 1...12:
                    clockViewLabel.text = "\(timeTillNextVaccination!.months)"
                    if timeTillNextVaccination!.months == 1 {
                        statisticsWheel1Label.text = "Månad till nästa vaccin kan tas"

                    }
                    else {
                        statisticsWheel1Label.text = "Månader till nästa vaccin kan tas"

                    }
                case (-11)...0:
                    clockViewLabel.text = "0"
                    statisticsWheel1Label.text = "Dagar till nästa vaccin kan tas"
                default:
                    fatalError("Inconsistent time left")
                }
                
            }
        }
    }
    
    //MARK: Actions
    @IBAction func valueForCellChanged(_ sender: UISwitch) {
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController

        if sender.isOn {
            sender.backgroundColor = Theme.secondaryDark
        }
        else {
            
            sender.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)
            

        }
       
        
        let alertViewController = alertService.alert(title: "Vill du göra denna ändring?", message: "Denna åtgärd kan orsaka att vaccin du lagt till tidigare tas bort, och att du sedan måste lägga till dem igen om du byter tillbaka.", button1Title: "Ja", button2Title: "Avbryt", alertType: .warning, completionWithAction: { ()  in
         
        
             
             self.previousVaccinationProgramIndicator = (self.user1?.object(forKey: "VaccinationProgramIndicator") as? Int) ?? 2
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController") as! VaccinationTabBarController
             
                         let cell1 = self.settingsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsTableViewCell
                         let cell2 = self.settingsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingsTableViewCell
                         

                         if sender.isOn {
                             if cell1.yesNoSwitch == sender {
                                cell2.yesNoSwitch.setOn(false, animated: true)
                                 self.user1?.setObject(0, forKey: "VaccinationProgramIndicator")
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true
                                
                                
                                cell2.yesNoSwitch.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)
                                    
                                    

                                
                             }
                              else if cell2.yesNoSwitch == sender {
                                cell1.yesNoSwitch.setOn(false, animated: true)
                                 self.user1?.setObject(1, forKey: "VaccinationProgramIndicator")
                                 
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true
                                cell1.yesNoSwitch.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)

                             }
                             
                         }
                         else {
                             self.user1?.setObject(2, forKey: "VaccinationProgramIndicator")
                             self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true
                            sender.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)

                             
                         }
             
            vaccinationTabBarController.changeVaccinationProgramStatus(previousVaccinationProgramIndicator: self.previousVaccinationProgramIndicator)

          
             
                         PFUser.current()?.saveInBackground {
                                    (success: Bool, error: Error?) in
                                      if (success) {
                                        // The object has been saved.
                                      } else {
                                        print (error?.localizedDescription as Any)
                                      }
                                    
                                }
            
            if !vaccinationTabBarController.save() {
                let alertViewController = self.alertService.alert(title: "Misslyckad uppladdning", message: "Det gick inte att spara ändringen. Vänligen se till att vara uppkopplad till internet.", button1Title: "OK", button2Title: nil, alertType: .error) {
                    
                } completionWithCancel: {
                    
                }
                self.present(alertViewController, animated: true, completion: nil)
            }
            
            self.barChartStackView1!.handleTap(increase: true)
            self.barChartStackViewProgressLabel1.text = String(vaccinationTabBarController.allVaccinations.count)
            
            let allVPVs = Double(vaccinationTabBarController.getAllVaccinationProgramVaccinations().count)
            let takenVPVs = vaccinationTabBarController.getPercentageOfVaccinationProgramTaken() * allVPVs
            self.statisticsWheel3!.handleTap(numerator: takenVPVs, denominator: allVPVs)
        }, completionWithCancel: { () in
            if !sender.isOn {
                sender.setOn(true, animated: true)
                sender.backgroundColor = Theme.secondaryDark
            }
            else {
                sender.setOn(false, animated: true)
                sender.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.3)

            }
        })
        present(alertViewController, animated: true)
        
        
        
        
        
            
    }
}
