//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit
import AVKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController, /*ProximityContentManagerDelegate, */UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var ControlsView: UIView!
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 2016, identifier: "Estimotes")
    
    var playerViewController = AVPlayerViewController()
    var OverlayView = UIView()
    //    var playerView = AVPlayer()
    var A1Item:AVPlayerItem?
    var A2Item:AVPlayerItem?
    var B1Item:AVPlayerItem?
    var B2Item:AVPlayerItem?
    var C1Item:AVPlayerItem?
    var C2Item:AVPlayerItem?
    var MT01Item:AVPlayerItem?
    var MT02Item:AVPlayerItem?
    var A01Item, A02Item,B01Item,B02Item,C01Item,C02Item,C03Item,D01Item,D02Item,N01Item, MT03Item: AVPlayerItem?
    
    var prevItem:AVPlayerItem?
     let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet var btnOutlet: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var BuildingBtn: UIButton!
    @IBOutlet var tableViewB: UITableView!
    @IBOutlet weak var FloorBtn: UIButton!
    @IBOutlet weak var TableViewFloor: UITableView!
    
    @IBOutlet weak var ScanningOnOff: UISwitch!
    
    //Control Items
    @IBOutlet weak var PauseBtn: UIButton!
    @IBOutlet weak var ReplayBtn: UIButton!
    @IBOutlet weak var PlayBtn: UIButton!
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var StopBtn: UIButton!
    var imageItem: UIImage = UIImage()
    
    
    let Buildings:[String] =  ["AMS CAD CAFM", "Pencil Works"]
    var list = ["Workspace A","Workspace B", "Restroom","Network Room", "Dan Room","Sector G3"]
    let pencilworksSpaces:[String] = ["Canteen","Lobby","Elevator", "Conference Room"]
    
    let BuildingInfo:[String:[String:[String]]] = ["AMS CAD CAFM":["F1":["Front Desk","Brad's Room","Training Room"],"F2":["Workspace A","Workspace B", "Restroom","Network Room", "Dan Room","Sector G3"]], "Pencil Works":["F1":["Canteen","Lobby","Elevator", "Conference Room"]]]
    
    
    
    
    
    
    //let NodeMap = ["AMS CAD CAFM":["F1":["O1","O2","O3"]]]
    
    
    var BuildingReference: String = ""
    var FloorReference: String = ""
    
    let cellIdentifier: String = "cell"
    
    var numberOfBuildings:Int = 0
    var numberOfFloors: Int = 0
    var numberOfSites: Int = 0
    
    
    var FromSite:String = "Sector G3"
    var toSite:String = ""
    
    var isBeacon = false
    
    var playerView = AVQueuePlayer()
    var AVQueueItem = AVQueuePlayer()
    
    var ReplayPlayer = AVQueuePlayer()
    
    @IBOutlet var videoView: UIWebView!
    @IBOutlet weak var EntranceView: UIView!
    
    
    
    let MatterportSites : [String] = [(Bundle.main.path(forResource: "MT01", ofType: "mp4")!)  ,
                                      ( Bundle.main.path(forResource: "MT02", ofType: "mp4")!)  ,
                                      (Bundle.main.path(forResource: "MT03", ofType: "mp4")!)  ]
    
    //    let PathSet : [String] = [( Bundle.main.path(forResource: "A01", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "A02", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "B01", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "B02", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "C01", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "C02", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "C03", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "D01", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "D02", ofType: "mp4")!) ,
    //                              ( Bundle.main.path(forResource: "N01", ofType: "mp4")!) ]
    
    
    let videoSet : [String] = [( Bundle.main.path(forResource: "A1", ofType: "mov")!) ,
                               ( Bundle.main.path(forResource: "A2", ofType: "mov")!) ,
                               ( Bundle.main.path(forResource: "B1", ofType: "mov")!) ,
                               ( Bundle.main.path(forResource: "B2", ofType: "mov")!) ,
                               ( Bundle.main.path(forResource: "C1", ofType: "mov")!) ,
                               ( Bundle.main.path(forResource: "C2", ofType: "mov")!) ]
    
    let RoomInfo:[String:[String:String]] = ["A1":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A2":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A3":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A4":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A5":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A6":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "A7":["Building":"AMS CAD CAFM","Floor":"F2"],
                                             "O1":["Building":"AMS CAD CAFM","Floor":"F1"],
                                             "O2":["Building":"AMS CAD CAFM","Floor":"F1"],
                                             "O3":["Building":"AMS CAD CAFM","Floor":"F1"],
                                             "B2":["Building":"Pencil Works","Floor":"F1"]]
    
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var beaconAssign:[String:String] = ["Lemon":"Workspace A", "Brown":"Dan Room", "Pink":"Sector G3", "blueberry":"Workspace B","Restroom":"Restroom","candy2":"Network Room","mint":"Canteen"]
    var oneBtnArray:[String:String] = ["Lemon":"Dan Room","Brown":"Sector G3", "Pink":"Main Entrance"]
    var twoBtnArray:[String:String] = ["Lemon":"Sector G3","Brown":"Main Entrance","Pink":"Dan Room"]
    
    
    
    var closestbeaconAssign:[NSNumber:String] = [2001:"Workspace A", 1001:"Dan Room", 3001:"Sector G3", 24254:"Workspace B",12703:"Restroom",55670:"Network Room",37700:"North Entrance"]
    
    var proximityContentManager: ProximityContentManager!
    
    
    //PathFinder
    let adjacencyList = AdjacencyList<String>()
    let adjacencyList2 = AdjacencyList<String>()
    
    var NodeAssign:[NSNumber:String] = [2001:"A1", 1001:"A7", 3001:"A6", 24254:"A2",12703:"A3",55670:"A4",37700:"B2"]
    var EndNodeAssign:[String:String] = ["Workspace A":"A1", "Dan Room":"A7", "Sector G3":"A6", "Workspace B":"A2","Restroom":"A3","Network Room":"A4","Canteen":"B2","Front Desk":"O1","Brad's Room":"O2","Training Room":"O3"]
    
    var ExitNodes = ["AMS CAD CAFM":["F1":["O1"],"F2":["A1"]]]
    
    
    var StartNode: String = ""
    var EndNode: String = ""
    
    var StartBuilding = ""
    var StartFloor = ""
    var EndBuilding = ""
    var EndFloor = ""
    var diffBuildings = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print ("hello")
        tableView.delegate = self
        tableView.dataSource = self
        tableViewB.delegate = self
        tableViewB.delegate = self
        TableViewFloor.delegate = self
        TableViewFloor.delegate = self
        
        
        // CL
        //UnCOMMENT START
       
        locationManager.delegate = self
       
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            locationManager.requestWhenInUseAuthorization()
        }
        
        if !ScanningOnOff.isOn{
            label.text = "Auto Scanning is turned Off"
        }
        
//        self.proximityContentManager = ProximityContentManager(
//            beaconIDs: [
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 2001), //lemon 2
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 3001), //pink
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 1001),  //brown
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 12703), //lemon 1
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 37700), //Candy 2
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 24254),//blue
//                //                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2016, minor: 55670)//mint
//            ],
//            beaconContentFactory: CachingContentFactory(beaconContentFactory: BeaconDetailsCloudFactory()))
//        self.proximityContentManager.delegate = self
//        self.proximityContentManager.startContentUpdates()
        //UNCOMMENT END
    }
    
    
    
    
    
//    func proximityContentManager(_ proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {
//        self.activityIndicator?.stopAnimating()
//        self.activityIndicator?.removeFromSuperview()
//        
//        if let beaconDetails = content as? BeaconDetails {
//            self.view.backgroundColor = beaconDetails.backgroundColor
//            self.label.text = "You're near \(beaconAssign[beaconDetails.beaconName]! as String)!"
//            FromSite = (beaconAssign[beaconDetails.beaconName]! as String)
//            
//        } else {
//            self.view.backgroundColor = BeaconDetails.neutralColor
//            self.label.text = "No beacons in range."
//            FromSite = "Workspace A"
//        }
//    }
    
    //self.label.text = "You're near Sector G3!"
    
    
    @IBAction func ScanOnOffAction(_ sender: UISwitch) {
        
        if ScanningOnOff.isOn{
            locationManager.startRangingBeacons(in: region)
            activityIndicator.startAnimating()
        }else{
            locationManager.stopRangingBeacons(in: region)
            activityIndicator.stopAnimating()
            label.text = "Auto Scanning is turned Off"
        }
        
    }
    
    var FoundMyLocation: Bool  = false
    
    @IBAction func FindMyLocationAction(_ sender: UIButton) {
        StartNode = ""
        FromSite = ""
        StartBuilding = ""
        StartFloor = ""
        FoundMyLocation = true
        locationManager.startRangingBeacons(in: region)
        
       
    }
    
    
    //LocationManager
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{$0.proximity != .unknown}
        if knownBeacons.count>0{
            let closestBeacon = knownBeacons[0] as CLBeacon
            // print("\(closestBeacon.major)     \(closestBeacon.minor)")
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            
            // self.view.backgroundColor = beaconDetails.backgroundColor
            //                self.label.text = "You're near \(closestbeaconAssign[closestBeacon.minor]! as String)!"
            StartNode = (NodeAssign[closestBeacon.minor]! as String) //PathFinder
            FromSite = (closestbeaconAssign[closestBeacon.minor]! as String)
            StartBuilding = (RoomInfo[StartNode]?["Building"]! as! String)
            StartFloor = (RoomInfo[StartNode]?["Floor"]! as! String)
            
           
            self.label.text = "You're near \(closestbeaconAssign[closestBeacon.minor]! as String)!"
            //            StartNode = "A6"
            //            FromSite = "Sector G3"
            //            StartBuilding = "AMS CAD CAFM"
            //            StartFloor = "F2"
            
            if FoundMyLocation == true &&  StartNode != "" && FromSite != "" && StartFloor != "" && StartBuilding != "" {
                locationManager.stopRangingBeacons(in: region)
                FoundMyLocation = false
            }
            
            if (StartNode == "B2" && (diffBuildings == true)){
                bgImage.removeFromSuperview()
                playerViewController.showsPlaybackControls = false
                TagCount = 4
                EntranceView.isHidden = true
                let alert3 = UIAlertController(title: "Alert", message:"You've arrived at North Entrance in PencilWorks Site, Please click Continue to view path", preferredStyle: .alert)
                alert3.addAction(UIAlertAction(title: "Continue", style: .default) { (UIAlertAction) -> Void in
                    var AVPlayerItemsArray:[AVPlayerItem] = []
                    AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "MT04", ofType: "mp4")!)))
                    self.AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
                    self.playerView = self.AVQueueItem
                    self.playerViewController.player = self.playerView
                    self.present(self.playerViewController, animated: true) {
                        self.playerViewController.player?.play()
                    }
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
                    //                    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
                })
                self.present(alert3, animated: true){}
                
            }
            
        }else {
            self.view.backgroundColor = BeaconDetails.neutralColor
            self.label.text = "No beacons in range."
            FromSite = "Workspace A"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            //print(list.count)
            numberOfBuildings = BuildingInfo.count
            return numberOfBuildings
        }else if tableView.tag == 2{
            
            if BuildingReference != "" {
                numberOfFloors = (BuildingInfo[BuildingReference]?.count)!
            }
            return numberOfFloors
        }else if tableView.tag == 3{
            if BuildingReference !=  "" && FloorReference != ""{
                numberOfSites = (BuildingInfo[BuildingReference]?[FloorReference]?.count)!
            }
            return numberOfSites
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        
        if tableView.tag == 1 {
            cell.textLabel?.text = Array(BuildingInfo.keys)[indexPath.row]
        }else if tableView.tag == 2 {
            cell.textLabel?.text = Array(BuildingInfo[BuildingReference]!.keys)[indexPath.row]
        }else if tableView.tag == 3 {
            cell.textLabel?.text = BuildingInfo[BuildingReference]?[FloorReference]?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.tag == 1{
            let cell = self.tableViewB.cellForRow(at: indexPath)
            BuildingReference = (cell?.textLabel?.text)!
            self.BuildingBtn.setTitle(cell?.textLabel?.text, for: UIControlState())
            tableViewB.isHidden = true
            btnOutlet.titleLabel?.text = ("Select")
            
            self.TableViewFloor.reloadData()
        }else if tableView.tag == 2{
            let cell = self.TableViewFloor.cellForRow(at: indexPath)
            FloorReference = (cell?.textLabel?.text)!
            self.FloorBtn.setTitle(cell?.textLabel?.text, for: UIControlState())
            TableViewFloor.isHidden = true
            btnOutlet.titleLabel?.text = ("Select")
            
            
            self.tableView.reloadData()
        }
            
            //tableView.reloadData()
        else if tableView.tag == 3{
            let cell = self.tableView.cellForRow(at: indexPath)
            self.btnOutlet.setTitle(cell?.textLabel?.text, for: UIControlState())
            tableView.isHidden = true
        }
        
        
        
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        tableView.isHidden = false
        tableViewB.isHidden = true
        btnOutlet.titleLabel?.text = ("Select")
        
    }
    @IBAction func BuildingBtnAction(_ sender: UIButton) {
        tableViewB.isHidden = false
        tableView.isHidden = true
        
    }
    @IBAction func FloorBtnAction(_ sender: UIButton) {
        
        tableView.isHidden = true
        tableViewB.isHidden = true
        TableViewFloor.isHidden = false
    }
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        //        A01Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[0]))
        //        A02Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[1]))
        //        B01Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[2]))
        //        B02Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[3]))
        //        C01Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[4]))
        //        C02Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[5]))
        //        C03Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[6]))
        //        D01Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[7]))
        //        D02Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[8]))
        //        N01Item = AVPlayerItem(url:URL(fileURLWithPath: PathSet[9]))
        //        MT01Item = AVPlayerItem(url:URL(fileURLWithPath: MatterportSites[0]))
        //        MT02Item = AVPlayerItem(url:URL(fileURLWithPath: MatterportSites[1]))
        //        MT03Item = AVPlayerItem(url:URL(fileURLWithPath: MatterportSites[2]))
        //
        //        B2Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[3]))
        //
        //
        //        //print(FromSite+"  to  "+(btnOutlet.titleLabel?.text)!)
        //
        //       self.toSite = (btnOutlet.titleLabel?.text)!
        //
        //
        //        // 1
        //        if FromSite == "Workspace A" {
        //            if list.contains(toSite){
        //            if toSite == "Workspace B"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [A01Item!])
        //            }else if  toSite == "Restroom"{
        //            AVQueueItem = AVQueuePlayer(items: [A01Item!,B01Item!])
        //            }else if  toSite == "Network Room"{
        //                AVQueueItem = AVQueuePlayer(items: [A01Item!,B01Item!,N01Item!])
        //            }else if  toSite == "Dan Room"{
        //                AVQueueItem = AVQueuePlayer(items: [A01Item!,B01Item!,C01Item!,C02Item!])
        //            }else if  toSite == "Sector G3"{
        //                AVQueueItem = AVQueuePlayer(items: [A01Item!,B01Item!,C01Item!,D01Item!])
        //            }
        //            playEvent(AVQueueItem)
        //            }else{
        //                if toSite == "Canteen"{
        //                    AVQueueItem = AVQueuePlayer(items: [A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                }else if toSite == "Lobby"{
        //                    AVQueueItem = AVQueuePlayer(items: [A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                }else{
        //                    let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                    alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                    self.present(alert3, animated: true){}
        //                }
        //            }
        //        }// 2
        //        else if FromSite == "Workspace B" {
        //            if list.contains(toSite){
        //            if toSite == "Workspace A"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [A02Item!])
        //            }else if  toSite == "Restroom"{
        //                AVQueueItem = AVQueuePlayer(items: [B01Item!])
        //            }else if  toSite == "Network Room"{
        //                AVQueueItem = AVQueuePlayer(items: [B01Item!,N01Item!])
        //            }else if  toSite == "Dan Room"{
        //                AVQueueItem = AVQueuePlayer(items: [B01Item!,C01Item!,C02Item!])
        //            }else if  toSite == "Sector G3"{
        //                AVQueueItem = AVQueuePlayer(items: [B01Item!,C01Item!,D01Item!])
        //            }
        //            playEvent(AVQueueItem)
        //        }else{
        //            if toSite == "Canteen"{
        //                AVQueueItem = AVQueuePlayer(items: [A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else if toSite == "Lobby"{
        //                AVQueueItem = AVQueuePlayer(items: [A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else{
        //                let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                self.present(alert3, animated: true){}
        //                }
        //        }// 3
        //        }else if FromSite == "Restroom" {
        //            if list.contains(toSite){
        //            if toSite == "Workspace A"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //            }else if  toSite == "Workspace B"{
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!])
        //            }else if  toSite == "Network Room"{
        //                AVQueueItem = AVQueuePlayer(items: [N01Item!])
        //            }else if  toSite == "Dan Room"{
        //                AVQueueItem = AVQueuePlayer(items: [C01Item!,C02Item!])
        //            }else if  toSite == "Sector G3"{
        //                AVQueueItem = AVQueuePlayer(items: [C01Item!,D01Item!])
        //            }
        //            playEvent(AVQueueItem)
        //            }else{
        //                 if toSite == "Canteen"{
        //                    AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                }else if toSite == "Lobby"{
        //                    AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                 }else{
        //                    let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                    alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                    self.present(alert3, animated: true){}
        //                }
        //            } // 4
        //        }else if FromSite == "Network Room" {
        //            if list.contains(toSite){
        //            if toSite == "Workspace A"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //            }else if  toSite == "Workspace B"{
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!])
        //            }else if  toSite == "Restroom"{
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!])
        //            }else if  toSite == "Dan Room"{
        //                AVQueueItem = AVQueuePlayer(items: [C02Item!])
        //            }else if  toSite == "Sector G3"{
        //                AVQueueItem = AVQueuePlayer(items: [C01Item!,D01Item!])
        //            }
        //            playEvent(AVQueueItem)
        //        }else{
        //            if toSite == "Canteen"{
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else if toSite == "Lobby"{
        //                AVQueueItem = AVQueuePlayer(items: [B02Item!,A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else{
        //                let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                self.present(alert3, animated: true){}
        //                }
        //        }
        //        // 5
        //        }else if FromSite == "Dan Room" {
        //            if list.contains(toSite){
        //            if toSite == "Workspace A"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [B2Item!,B02Item!,A02Item!])
        //            }else if  toSite == "Workspace B"{
        //                AVQueueItem = AVQueuePlayer(items: [B2Item!,B02Item!])
        //            }else if  toSite == "Restroom"{
        //                AVQueueItem = AVQueuePlayer(items: [B2Item!,B02Item!])
        //            }else if  toSite == "Network Room"{
        //                AVQueueItem = AVQueuePlayer(items: [B2Item!])
        //            }else if  toSite == "Sector G3"{
        //                AVQueueItem = AVQueuePlayer(items: [C03Item!,D01Item!])
        //            }
        //                playEvent(AVQueueItem) }else{
        //                if toSite == "Canteen"{
        //                    AVQueueItem = AVQueuePlayer(items: [B2Item!,B02Item!,A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                }else if toSite == "Lobby"{
        //                    AVQueueItem = AVQueuePlayer(items: [B2Item!,B02Item!,A02Item!])
        //                    playEventTwo(AVQueueItem)
        //                }else{
        //                    let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                    alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                    self.present(alert3, animated: true){}
        //                }
        //            } // 6
        //        }else if FromSite == "Sector G3" {
        //            if toSite == "Workspace A"
        //            {
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,B02Item!,A02Item!])
        //                playEvent(AVQueueItem)
        //            }else if  toSite == "Workspace B"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,B02Item!])
        //                playEvent(AVQueueItem)
        //            }else if  toSite == "Restroom"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,B02Item!])
        //                playEvent(AVQueueItem)
        //            }else if  toSite == "Network Room"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!])
        //                playEvent(AVQueueItem)
        //            }else if  toSite == "Dan Room"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,C02Item!])
        //                playEvent(AVQueueItem)
        //            }else if toSite == "Canteen"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,B02Item!,A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else if toSite == "Lobby"{
        //                AVQueueItem = AVQueuePlayer(items: [D02Item!,B02Item!,A02Item!])
        //                playEventTwo(AVQueueItem)
        //            }else{
        //                let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                self.present(alert3, animated: true){}
        //            }
        //
        //        } else if FromSite == "Canteen"{
        //            if list.contains(toSite){
        //                if toSite == "Workspace B"
        //                {
        //                    AVQueueItem = AVQueuePlayer(items: [MT03Item!])
        //                }else if  toSite == "Restroom"{
        //                    AVQueueItem = AVQueuePlayer(items: [MT03Item!])
        //                }else if  toSite == "Network Room"{
        //                    AVQueueItem = AVQueuePlayer(items: [MT03Item!])
        //                }else if  toSite == "Dan Room"{
        //                    AVQueueItem = AVQueuePlayer(items: [MT03Item!])
        //                }else if  toSite == "Sector G3"{
        //                    AVQueueItem = AVQueuePlayer(items: [MT03Item!])
        //                }
        //                playEventTwo(AVQueueItem)
        //            }else{
        //                    let alert3 = UIAlertController(title: "Not Found", message:"Path to this space has not been added, Please select other.", preferredStyle: .alert)
        //                    alert3.addAction(UIAlertAction(title: "Close", style: .default) { (UIAlertAction) -> Void in self})
        //                    self.present(alert3, animated: true){}
        
    }
    //    func playEvent(_ QueueItem: AVQueuePlayer){
    //        playerView = QueueItem
    //        playerViewController.player = playerView
    //        self.present(playerViewController, animated: true) {
    //            self.playerViewController.player?.play()
    //        }
    //
    //
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
    //    }
    //
    //    func playEventTwo(_ QueueItem: AVQueuePlayer){
    //        playerView = QueueItem
    //        playerViewController.player = playerView
    //        self.present(playerViewController, animated: true) {
    //            self.playerViewController.player?.play()
    //        }
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlayingTwo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
    //
    //    }
    
    
    @IBAction func ShowPathAction(_ sender: UIButton) {
        
        A1Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[0]))
        A2Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[1]))
        B1Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[2]))
        B2Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[3]))
        C1Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[4]))
        C2Item = AVPlayerItem(url:URL(fileURLWithPath: videoSet[5]))
        
        AVQueueItem = AVQueuePlayer(items: [A1Item!,B1Item!,B2Item!,C1Item!,C2Item!,A2Item!])
        playerView = AVQueueItem
        playerViewController.player = playerView
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
    }
    
    
    
    
    
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //PathFinder
    //    func depthFirstSearch(from start: Vertex<String>, to end: Vertex<String>, graph: AdjacencyList<String>) -> Stack<Vertex<String>> { // 1
    //        var visited = Set<Vertex<String>>() // 2
    //        var stack = Stack<Vertex<String>>() // 3
    //        stack.push(start)
    //        visited.insert(start)
    //        outer: while let vertex = stack.peek(), vertex != end { // 1
    //        guard let neighbors = graph.edges(from: vertex), neighbors.count > 0 else { // 2
    //                print("backtrack from \(vertex)")
    //                stack.pop()
    //                continue
    //            }
    //
    //            for edge in neighbors { // 3
    //                if !visited.contains(edge.destination) {
    //                    visited.insert(edge.destination)
    //                    stack.push(edge.destination)
    //                    print(stack.description)
    //                    continue outer
    //                }
    //            }
    //            print("backtrack from \(vertex)") // 4
    //            stack.pop()
    //        }
    //    return stack // 4
    //    }
    //
    @IBAction func TestButtonAction(_ sender: UIButton) {
        //        //PathFinder
        //        StartNode = "A6"
        //        FromSite = "Sector G3"
        //        StartBuilding = "AMS CAD CAFM"
        //        StartFloor = "F2"
        PlayingAction()
        //        self.EndNode = EndNodeAssign[(btnOutlet.titleLabel?.text)!]!
        //        self.toSite = (btnOutlet.titleLabel?.text)!
        //
        //        self.EndBuilding =  (RoomInfo[EndNode]?["Building"]!)!
        //        self.EndFloor =  (RoomInfo[EndNode]?["Floor"]!)!
        //        //PathFinder
        //
        //        let A1 = adjacencyList.createVertex(data: "A1")
        //        let A2 = adjacencyList.createVertex(data: "A2")
        //        let A3 = adjacencyList.createVertex(data: "A3")
        //        let A4 = adjacencyList.createVertex(data: "A4")
        //        let A5 = adjacencyList.createVertex(data: "A5")
        //        let A6 = adjacencyList.createVertex(data: "A6")
        //        let A7 = adjacencyList.createVertex(data: "A7")
        //
        //        let O1 = adjacencyList.createVertex(data: "O1")
        //        let O2 = adjacencyList.createVertex(data: "O2")
        //        let O3 = adjacencyList.createVertex(data: "O3")
        //
        //        adjacencyList.add(.undirected, from: A1, to: A2,weight: 1)
        //        adjacencyList.add(.undirected, from: A2, to: A1,weight: 1)
        //        adjacencyList.add(.undirected, from: A2, to: A3,weight: 1)
        //        adjacencyList.add(.undirected, from: A2, to: A4,weight: 1)
        //        adjacencyList.add(.undirected, from: A2, to: A5,weight: 1)
        //        adjacencyList.add(.undirected, from: A3, to: A2,weight: 1)
        //        adjacencyList.add(.undirected, from: A4, to: A2,weight: 1)
        //        adjacencyList.add(.undirected, from: A5, to: A2,weight: 1)
        //        adjacencyList.add(.undirected, from: A5, to: A6,weight: 1)
        //        adjacencyList.add(.undirected, from: A5, to: A7,weight: 1)
        //        adjacencyList.add(.undirected, from: A7, to: A5,weight: 1)
        //        adjacencyList.add(.undirected, from: A6, to: A5,weight: 1)
        //        adjacencyList.add(.undirected, from: A7, to: A5,weight: 1)
        //        adjacencyList.add(.undirected, from: A6, to: A5,weight: 1)
        //
        //        adjacencyList2.add(.undirected, from: A1, to: O1,weight: 1)
        //        adjacencyList2.add(.undirected, from: O1, to: O2,weight: 1)
        //        adjacencyList2.add(.undirected, from: O1, to: O3,weight: 1)
        //
        //        if StartBuilding == EndBuilding{
        //            if StartFloor == EndFloor{
        //                let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
        //                let EndNodeVertex = adjacencyList.createVertex(data: EndNode)
        //
        //                var pathArray:[String] = []
        //
        //                if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
        //                    for edge in edges {
        //                        pathArray.append("\(edge.source)-\(edge.destination)")
        //                    }
        //                }
        //                print("Start Node   \(StartNode)   End Node    \(EndNode)    Start Building: \(StartBuilding)        End Building: \(EndBuilding)    \n StartFloor: \(StartFloor)     End Floor: \(EndFloor)     ")
        //
        //
        //                var AVPlayerItemsArray:[AVPlayerItem] = []
        //                for each in pathArray{
        //                    print(each)
        //                    AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
        //                }
        //
        //                AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
        //                self.playerView = AVQueueItem
        //
        //                playerViewController.showsPlaybackControls = true
        //
        //                playerViewController.player = self.playerView
        //
        //
        //                //NotificationCenter.default.addObserver(self, selector: #selector(stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        //                //                        addContentOverlayView()
        //                self.present(playerViewController, animated: true) {
        //                    self.playerViewController.player?.play()
        //                }
        //
        //                ControlsView.isHidden = false
        //                ControlsNormal()
        //                playerViewController.view.addSubview(ControlsView)
        //
        //                //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        //            } else { /// todo Work
        //
        //                let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
        //                let EndNodeVertex = adjacencyList.createVertex(data: (ExitNodes[StartBuilding]?[StartFloor]?[0])!)
        //
        //                var pathArray:[String] = []
        //
        //                if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
        //                    for edge in edges {
        //                        pathArray.append("\(edge.source)-\(edge.destination)")
        //                    }
        //                }
        //                print("Start Node   \(StartNode)   End Node    \(EndNode)    Start Building: \(StartBuilding)        End Building: \(EndBuilding)    \n StartFloor: \(StartFloor)     End Floor: \(EndFloor)     ")
        //
        //
        //                var AVPlayerItemsArray:[AVPlayerItem] = []
        //                for each in pathArray{
        //                    print(each)
        //                    AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
        //                }
        //
        //                AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
        //                playerView = AVQueueItem
        //                playerViewController.player = playerView
        //                self.present(playerViewController, animated: true) {
        //                    self.playerViewController.player?.play()
        //                }
        //                NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlayingTwo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        //
        //
        //
        //
        //            }
        //        }else{
        //            //            EntranceView.isHidden = false
        //            let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
        //            let EndNodeVertex = adjacencyList.createVertex(data: (ExitNodes[StartBuilding]?[StartFloor]?[0])!)
        //
        //            var pathArray:[String] = []
        //
        //            if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
        //                for edge in edges {
        //                    pathArray.append("\(edge.source)-\(edge.destination)")
        //                }
        //            }
        //            print("Start Node   \(StartNode)   End Node    \(EndNode)    Start Building: \(StartBuilding)        End Building: \(EndBuilding)    \n StartFloor: \(StartFloor)     End Floor: \(EndFloor)     ")
        //
        //
        //            var AVPlayerItemsArray:[AVPlayerItem] = []
        //            for each in pathArray{
        //                print(each)
        //                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
        //            }
        //
        //            AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
        //            playerView = AVQueueItem
        //            playerViewController.player = playerView
        //            self.present(playerViewController, animated: true) {
        //                self.playerViewController.player?.play()
        //            }
        //            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlayingBuilding(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        //        }
    }
    
    //var AVPlayerItemsArray:[AVPlayerItem] = []
    var ReplayVideosArray:[String] = []
    
    @IBAction func PlayingAction() {
        print("Playing Action Called")
        
        playerViewController.showsPlaybackControls = false
        
        
        
        bgImage.removeFromSuperview()
        ReplayVideosArray.removeAll()
        //To Be removed
        
        //        StartNode = "A6"
        //        FromSite = "Sector G3"
        //        StartBuilding = "AMS CAD CAFM"
        //        StartFloor = "F2"
        
        
        //PathFinder
//        if StartBuilding != "" && EndBuilding != "" && StartFloor != "" && EndFloor != ""
//            && StartNode != "" && EndNodeAssign[(btnOutlet.titleLabel?.text)!]! != "" {
        self.EndNode = EndNodeAssign[(btnOutlet.titleLabel?.text)!]!
        self.toSite = (btnOutlet.titleLabel?.text)!
        
        EndBuilding =  (RoomInfo[EndNode]?["Building"]!)!
        EndFloor =  (RoomInfo[EndNode]?["Floor"]!)!
        //PathFinder
        print("From : \(FromSite) , To: \(toSite)\n SB: \(StartBuilding) , EB: \(EndBuilding),   SF: \(StartFloor),  EF: \(EndFloor)")
        let A1 = adjacencyList.createVertex(data: "A1")
        let A2 = adjacencyList.createVertex(data: "A2")
        let A3 = adjacencyList.createVertex(data: "A3")
        let A4 = adjacencyList.createVertex(data: "A4")
        let A5 = adjacencyList.createVertex(data: "A5")
        let A6 = adjacencyList.createVertex(data: "A6")
        let A7 = adjacencyList.createVertex(data: "A7")
        
        let O1 = adjacencyList.createVertex(data: "O1")
        let O2 = adjacencyList.createVertex(data: "O2")
        let O3 = adjacencyList.createVertex(data: "O3")
        
        adjacencyList.add(.undirected, from: A1, to: A2,weight: 1)
        adjacencyList.add(.undirected, from: A2, to: A1,weight: 1)
        adjacencyList.add(.undirected, from: A2, to: A3,weight: 1)
        adjacencyList.add(.undirected, from: A2, to: A4,weight: 1)
        adjacencyList.add(.undirected, from: A2, to: A5,weight: 1)
        adjacencyList.add(.undirected, from: A3, to: A2,weight: 1)
        adjacencyList.add(.undirected, from: A4, to: A2,weight: 1)
        adjacencyList.add(.undirected, from: A5, to: A2,weight: 1)
        adjacencyList.add(.undirected, from: A5, to: A6,weight: 1)
        adjacencyList.add(.undirected, from: A5, to: A7,weight: 1)
        adjacencyList.add(.undirected, from: A7, to: A5,weight: 1)
        adjacencyList.add(.undirected, from: A6, to: A5,weight: 1)
        adjacencyList.add(.undirected, from: A7, to: A5,weight: 1)
        adjacencyList.add(.undirected, from: A6, to: A5,weight: 1)
        
        adjacencyList2.add(.undirected, from: A1, to: O1,weight: 1)
        adjacencyList2.add(.undirected, from: O1, to: O2,weight: 1)
        adjacencyList2.add(.undirected, from: O1, to: O3,weight: 1)
       
    playerViewController.showsPlaybackControls = false
        
        if StartBuilding == EndBuilding{
            if StartFloor == EndFloor{
                TagCount = 0
                let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
                let EndNodeVertex = adjacencyList.createVertex(data: EndNode)
                
                var pathArray:[String] = []
                
                if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
                    for edge in edges {
                        pathArray.append("\(edge.source)-\(edge.destination)")
                    }
                }
                
                var AVPlayerItemsArray:[AVPlayerItem] = []
                for each in pathArray{
                    
                    AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
                    ReplayVideosArray.append(each)
                    
                }
                
                AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
                self.playerView = AVQueueItem
                playerViewController.player = self.playerView
                
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
                
                
                //Controls View
                ControlsView.isHidden = false
                PauseBtn.isHidden = false
                StopBtn.isHidden = false
                playerViewController.view.addSubview(ControlsView)
                NotificationCenter.default.addObserver(self, selector: #selector(stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
                
            } else { /// todo Work
                TagCount = 1
                let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
                let EndNodeVertex = adjacencyList.createVertex(data: (ExitNodes[StartBuilding]?[StartFloor]?[0])!)
                
                var pathArray:[String] = []
                
                if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
                    for edge in edges {
                        pathArray.append("\(edge.source)-\(edge.destination)")
                    }
                }
                print("Start Node   \(StartNode)   End Node    \(EndNode)    Start Building: \(StartBuilding)        End Building: \(EndBuilding)    \n StartFloor: \(StartFloor)     End Floor: \(EndFloor)     ")
                
          
                
                var AVPlayerItemsArray:[AVPlayerItem] = []
                for each in pathArray{
                    print(each)
                    AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
                    ReplayVideosArray.append(each)
                }
                
                AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
                playerView = AVQueueItem
                playerViewController.player = playerView
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
                
                //Controls View
                ControlsView.isHidden = false
                PauseBtn.isHidden = false
                StopBtn.isHidden = false
                playerViewController.view.addSubview(ControlsView)
                
                NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlayingTwo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
                
                
                
                
            }
        }else{
            
            TagCount = 3
            //            EntranceView.isHidden = false
            let StartNodeVertex = adjacencyList.createVertex(data: StartNode)
            let EndNodeVertex = adjacencyList.createVertex(data: (ExitNodes[StartBuilding]?[StartFloor]?[0])!)
            
            var pathArray:[String] = []
            
            if let edges = adjacencyList.breadthFirstSearch(from: StartNodeVertex as Vertex, to: EndNodeVertex) {
                for edge in edges {
                    pathArray.append("\(edge.source)-\(edge.destination)")
                }
            }
            print("Start Node   \(StartNode)   End Node    \(EndNode)    Start Building: \(StartBuilding)        End Building: \(EndBuilding)    \n StartFloor: \(StartFloor)     End Floor: \(EndFloor)     ")
            
            
            var AVPlayerItemsArray:[AVPlayerItem] = []
            for each in pathArray{
                print(each)
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
                ReplayVideosArray.append(each)
            }
            
            AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
            playerView = AVQueueItem
            playerViewController.player = playerView
            self.present(playerViewController, animated: true) {
                self.playerViewController.player?.play()
            }
            
            //Controls View
            ControlsView.isHidden = false
            PauseBtn.isHidden = false
            StopBtn.isHidden = false
            playerViewController.view.addSubview(ControlsView)
            
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlayingBuilding(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        }
        
//        }else{
//            print("Not Selected")
//        }
        
        
        
    }
    var bgImage :UIImageView = UIImageView()
    
    var TagCount:Int = 0
    
    func playerDidFinishPlaying(_ note: Notification){
        print("Video Finished")
        
        // self.playerView
        //         self.playerViewController.dismiss(animated: true, completion: nil)
        
        
        if self.StartBuilding != self.EndBuilding || diffBuildings == true{
            EntranceView.isHidden = true
            self.diffBuildings = false
        }
    }
    func playerDidFinishPlayingTwo(_ note: Notification){
        bgImage.removeFromSuperview()
        ReplayVideosArray.removeAll()
        TagCount = 2
        
        playerViewController.showsPlaybackControls = false
        
        let A1 = adjacencyList.createVertex(data: "A1")
        let O1 = adjacencyList.createVertex(data: "O1")
        let O2 = adjacencyList.createVertex(data: "O2")
        let O3 = adjacencyList.createVertex(data: "O3")
        adjacencyList2.add(.undirected, from: A1, to: O1,weight: 1)
        adjacencyList2.add(.undirected, from: O1, to: O2,weight: 1)
        adjacencyList2.add(.undirected, from: O1, to: O3,weight: 1)
        print("Video Finished")
        self.playerViewController.dismiss(animated: true, completion: nil)
        
        
        let alert3 = UIAlertController(title: "Alert", message:"You arrived to the exit in this Floor, Please click 'Continue' to view path towards \(self.toSite) in next Floor.", preferredStyle: .alert)
        alert3.addAction(UIAlertAction(title: "Continue", style: .default) {
            (UIAlertAction) -> Void in
            
            var AVPlayerItemsArray:[AVPlayerItem] = []
            
            print("TO SITE IS : \(self.toSite)")
            if (self.toSite == "Front Desk" ){
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "A1-O1", ofType: "mp4")!)))
            }else if (self.toSite == "Brad's Room" ){
                
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "A1-O1", ofType: "mp4")!)))
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "O1-O2", ofType: "mp4")!)))
            }else if (self.toSite == "Training Room" ){
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "A1-O1", ofType: "mp4")!)))
                AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "O1-O3", ofType: "mp4")!)))
            }
            
            
            self.AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
            self.playerView = self.AVQueueItem
            self.playerViewController.player = self.playerView
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.player?.play()
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
            
            //            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        })
        //Controls View
        self.ControlsView.isHidden = false
        self.PauseBtn.isHidden = false
        self.StopBtn.isHidden = false
        self.playerViewController.view.addSubview(self.ControlsView)
        
        
        self.present(alert3, animated: true){}
    }
    
    @IBAction func NEAction(_ sender: UIButton) {
        
        bgImage.removeFromSuperview()
        ReplayVideosArray.removeAll()
        var AVPlayerItemsArray:[AVPlayerItem] = []
        playerViewController.showsPlaybackControls = false
        AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "MT04", ofType: "mp4")!)))
        ReplayVideosArray.append("MT04")
        
        self.AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
        self.playerView = self.AVQueueItem
        self.playerViewController.player = self.playerView
        self.present(self.playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        
        //Controls View
        ControlsView.isHidden = false
        PauseBtn.isHidden = false
        StopBtn.isHidden = false
        playerViewController.view.addSubview(ControlsView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        //
        
    }
    @IBAction func SEAction(_ sender: UIButton) {
        
        bgImage.removeFromSuperview()
        ReplayVideosArray.removeAll()
        
        var AVPlayerItemsArray:[AVPlayerItem] = []
        playerViewController.showsPlaybackControls = false
        AVPlayerItemsArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "MT01", ofType: "mp4")!)))
        ReplayVideosArray.append("MT01")
        
        self.AVQueueItem = AVQueuePlayer(items: AVPlayerItemsArray)
        self.playerView = self.AVQueueItem
        self.playerViewController.player = self.playerView
        self.present(self.playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        
        //Controls View
        ControlsView.isHidden = false
        PauseBtn.isHidden = false
        StopBtn.isHidden = false
        playerViewController.view.addSubview(ControlsView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        //
    }
    
    func playerDidFinishPlayingBuilding(_ note: Notification){
        
        TagCount = 5
        bgImage.removeFromSuperview()
        ReplayVideosArray.removeAll()
        playerViewController.showsPlaybackControls = false
        self.playerViewController.dismiss(animated: true, completion: nil)
        
        
        let alert3 = UIAlertController(title: "Note", message:"You arrived at the exit in this building, Please select from the options available to view path towards destination, or click continue when you arrive at an entrance in \(self.EndBuilding) building (After your location appears).", preferredStyle: .alert)
        alert3.addAction(UIAlertAction(title: "OK", style: .default) {
            (UIAlertAction) -> Void in
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
        })
        self.present(alert3, animated: true){self.EntranceView.isHidden = false
            self.diffBuildings = true}
    }
    
    
    @IBAction func PauseVideo(_ sender: UIButton) {
        
        playerViewController.player?.pause()
        StopBtn.isHidden = false
        PlayBtn.isHidden = false
        PauseBtn.isHidden = true
        ReplayBtn.isHidden = true
        CloseBtn.isHidden = true
    }
    
    @IBAction func PlayVideoAction(_ sender: UIButton) {
        playerViewController.player?.play()
        PlayBtn.isHidden = true
        PauseBtn.isHidden = false
        StopBtn.isHidden = false
        ReplayBtn.isHidden = true
        CloseBtn.isHidden = true
    }
    
    @IBAction func StopAction(_ sender: UIButton) {
        playerViewController.player?.pause()
        StopBtn.isHidden = true
        PlayBtn.isHidden = true
        PauseBtn.isHidden = true
        ReplayBtn.isHidden = false
        CloseBtn.isHidden = false
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
        self.playerViewController.dismiss(animated: true, completion: nil)
        playerViewController.player = nil
        ControlsView.removeFromSuperview()
        bgImage.removeFromSuperview()
        ControlsView.isHidden = true
        StopBtn.isHidden = true
        PlayBtn.isHidden = true
        PauseBtn.isHidden = true
        ReplayBtn.isHidden = true
        CloseBtn.isHidden = true
    }
    
    @IBAction func ReplayVideoAction(_ sender: UIButton) {
        
        //        print("From : \(FromSite) , To: \(toSite)\n SB: \(StartBuilding) , EB: \(EndBuilding),   SF: \(StartFloor),  EF: \(EndFloor)")
        playerViewController.showsPlaybackControls = false
        ControlsView.isHidden = false
        StopBtn.isHidden = false
        PlayBtn.isHidden = true
        PauseBtn.isHidden = false
        ReplayBtn.isHidden = true
        CloseBtn.isHidden = true
        
        bgImage.removeFromSuperview()
        OverlayView.isHidden = true
        var replayArray : [AVPlayerItem] = []
        
        print("Count of Videos: \(ReplayVideosArray.count)")
        // print(TagCount)
        if TagCount == 2{
            ReplayVideosArray.removeAll()
            if (toSite == "Front Desk" ){
                ReplayVideosArray.append("A1-O1")
            }else if (toSite == "Brad's Room" ){
                
                ReplayVideosArray.append("A1-O1")
                ReplayVideosArray.append("O1-O2")
                
                print("Success Lopp")
            }else if (toSite == "Training Room" ){
                ReplayVideosArray.append("A1-O1")
                ReplayVideosArray.append("O1-O3")
            }
        }else if TagCount == 4{
            //  MT04
            ReplayVideosArray.removeAll()
            ReplayVideosArray.append("MT04")
        }
        //print(ReplayVideosArray.count)
        
        for each in ReplayVideosArray{
            print(each)
            replayArray.append(AVPlayerItem(url: URL(fileURLWithPath:Bundle.main.path(forResource: "\(each)", ofType: "mp4")!)))
            
           
        }
        
       // imageItem = getLastFrame(from: replayArray.last!)!
        ReplayPlayer = AVQueuePlayer(items: replayArray)
        playerView = ReplayPlayer
        
        playerViewController.player = playerView
        playerViewController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerView.items().last)
    }
    
    
    func openComments() {
        //Open the comment View/VC
    }
    
    func stopedPlaying() {
        print("STopped Playying Called")
        self.playerViewController.showsPlaybackControls = false
        
        
        
          let imageItem: UIImage =  getLastFrame(from: (playerViewController.player?.currentItem)!)!

       
       
        
            bgImage = UIImageView(image: imageItem)
             bgImage.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height )
            print("No Last Frame? \(bgImage)")
        
        
            playerViewController.view.addSubview(bgImage)
           // bgImage.bounds = view.frame.insetBy(dx: 15, dy: 0)
//        bgImage.layoutMargins = UIEdgeInsetsMake(0, 0, 50, 0);
        
        // addContentOverlayView()
        playerViewController.view.addSubview(ControlsView)
        ControlsView.isHidden = false
        StopBtn.isHidden = true
        PlayBtn.isHidden = true
        PauseBtn.isHidden = true
        ReplayBtn.isHidden = false
        CloseBtn.isHidden = false
        
        OverlayView.isHidden = false
    }
    
    // To Get Last Frame
    func getLastFrame(from item: AVPlayerItem) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: item.asset)
        
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        
        let composition = AVVideoComposition(propertiesOf: item.asset)
        let time = CMTimeMakeWithSeconds(item.asset.duration.seconds, composition.frameDuration.timescale)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    
    
    
    
    
    
}
