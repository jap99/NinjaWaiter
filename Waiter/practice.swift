//class AppData {
//    
//    
//    var storyboard: UIStoryboard!
//    var appDelegate: AppDelegate!
//    var versions: [Version] = []
//    var newsArray = [News]()
//    var featuredNews: News?
//    
//    var mapArray = [MapDict]()
//    var dropDownDataArray: [String] = []
//    var postMessageArrray = [PostMessage]()
//    var filterArrray = [PostMessage]()
//    var postMessageLoadCount = 0
//    
//    static let sharedInstance: AppData = {
//        
//        let instance = AppData()
//        instance.getVersionsData(completionHandler: {(status) in })
//        instance.getNewsData(completionHandler: {(status) in })
//        instance.getPartyData(completionHandler: {(status) in })
//        return instance
//        
//        //        if AppData.sharedInstance == nil {
//        //
//        //            let instance = AppData()
//        //            instance.getVersionsData(completionHandler: {(status) in })
//        //            return instance
//        //
//        //        } else {
//        //            return sharedInstance
//        //        }
//        
//    }()
//    
//    
//    func getVersionsData(completionHandler: @escaping (_ status: Bool) -> Void) {
//        
//        let _ = Database.database().reference().child("versions").observe(.value, with: { (snapshot: DataSnapshot) in
//            
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                
//                for snap in snapshot {
//                    
//                    if let versionDict = snap.value as? Dictionary<String, AnyObject> {
//                        
//                        AppData.sharedInstance.versions.append(Version(versionName: "", versionData: versionDict))
//                        
//                    }
//                }
//                completionHandler(true)
//            } else {
//                completionHandler(false)
//            }
//        })
//    }
//    
//    
//    
//    func getNewsData(completionHandler: @escaping (_ status: Bool) -> Void) {
//        let _ = Database.database().reference().child("news").observe(.value, with: { (snapshot: DataSnapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                AppData.sharedInstance.newsArray = [News]()
//                for snap in snapshot {
//                    if snap.key == "articles" {
//                        if let articles = snap.children.allObjects as? [DataSnapshot] {
//                            for article in articles {
//                                if let articleDict = article.value as? Dictionary<String, AnyObject> {
//                                    let news = News()
//                                    
//                                    news.index = Int(article.key)!
//                                    
//                                    if let title = articleDict["title-lbl"] as? String { news.title = title }
//                                    if let subTitle = articleDict["subtitle-lbl"] as? String { news.headerSubtitle = subTitle }
//                                    if let headerDate = articleDict["date-lbl"] as? String { news.date = headerDate }
//                                    if let featuredText = articleDict["feature-lbl"] as? String { news.featuredText = featuredText }
//                                    if let headerImageUrl = articleDict["image"] as? String { news.imgUrl = headerImageUrl }
//                                    
//                                    if let paragraphs = articleDict["paragraphs"]  as? [Any] {
//                                        for paragraph in paragraphs {
//                                            if let p = paragraph as? [String: AnyObject] {
//                                                var txt: String?
//                                                var img: String?
//                                                var showLine: Bool = false
//                                                var link: String?
//                                                
//                                                if let tempTxt = p["text"] as? String { txt = tempTxt }
//                                                if let tempImg = p["img"] as? String { img = tempImg }
//                                                if let tempLine = p["line"] as? Bool { showLine = tempLine }
//                                                if let tempLink = p["link"] as? String { link = tempLink }
//                                                
//                                                news.paragraphArray.append(Paragraph(txt: txt, imageUrl: img, showLine: showLine, link: link))
//                                            }
//                                        }
//                                        AppData.sharedInstance.newsArray.append(news)
//                                    }
//                                }
//                            }
//                            AppData.sharedInstance.newsArray = AppData.sharedInstance.newsArray.sorted(by: {$0.index > $1.index})
//                        }
//                        
//                    }
//                    if snap.key == "featured" {
//                        if let featuredDict = snap.value as? Dictionary<String, AnyObject> {
//                            if let articleUID = featuredDict["articleUID"] as? Int {
//                                
//                                if let news = AppData.sharedInstance.newsArray.filter({ $0.index == articleUID }).first{
//                                    AppData.sharedInstance.featuredNews = news
//                                }
//                            }
//                        }
//                    }
//                }
//                completionHandler(true)
//            }
//            completionHandler(false)
//        })
//    }
//    
//    
//    
//    func getPartyData(completionHandler: @escaping (_ status: Bool) -> Void) {
//        let _ = Database.database().reference().child("maps").observe(.value, with: { (snapshot: DataSnapshot) in
//            
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                
//                AppData.sharedInstance.mapArray = [MapDict]()
//                
//                for snap in snapshot {
//                    let indexKey = snap.key
//                    if let mapData = snap.value as? [String: String] {
//                        
//                        for (key, value) in mapData {
//                            let mapDict = MapDict(key: key, value: value)
//                            mapDict.index = indexKey
//                            AppData.sharedInstance.mapArray.append(mapDict)
//                            AppData.sharedInstance.dropDownDataArray.append(key)
//                        }
//                    }
//                }
//                AppData.sharedInstance.loadPostMessages(completionHandler: completionHandler)
//            } else {
//                completionHandler(false)
//            }
//        })
//    }
//    
//    
//    func loadPostMessages(completionHandler: @escaping (_ status: Bool) -> Void) {
//        AppData.sharedInstance.postMessageArrray = [PostMessage]()
//        
//        for i in 0...2 {
//            AppData.sharedInstance.loadDataFor(postType: i, completionHandler: completionHandler)
//        }
//    }
//    
//    func loadDataFor(postType: Int, completionHandler: @escaping (_ status: Bool) -> Void) {
//        let timeStamp = Int(Date().addingTimeInterval(0).timeIntervalSince1970)
//        
//        let _ = Database.database().reference().child("post").child("\(postType)").queryOrderedByValue().queryStarting(atValue: timeStamp).observe(.value, with: { (snapshot: DataSnapshot) in
//            AppData.sharedInstance.postMessageLoadCount =  AppData.sharedInstance.postMessageLoadCount+1
//            
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    let dateString = snap.key
//                    
//                    if let dataObj = snap.value as? [String: AnyObject] {
//                        let postMessage = PostMessage()
//                        postMessage.level = dataObj["level"] as! String
//                        postMessage.mapIndex = dataObj["map"] as! String
//                        postMessage.mic = dataObj["mic"] as! Bool
//                        postMessage.msg = dataObj["msg"] as! String
//                        postMessage.userName = dataObj["username"] as! String
//                        postMessage.date = dateString
//                        postMessage.step = postType.description
//                        
//                        outerLoop: for mapDict in self.mapArray {
//                            if dataObj["map"] as! String == mapDict.index {
//                                postMessage.mapImage = mapDict.value
//                                
//                                break outerLoop;
//                            }
//                        }
//                        AppData.sharedInstance.postMessageArrray.append(postMessage)
//                    }
//                }
//                
//                if postType == 1 {
//                    AppData.sharedInstance.postMessageArrray = self.postMessageArrray.sorted(by: {$0.date > $1.date})
//                    AppData.sharedInstance.filterArrray = AppData.sharedInstance.postMessageArrray.filter({$0.step == "1"})
//                }
//            }
//            if AppData.sharedInstance.postMessageLoadCount == 3 {
//                completionHandler(true)
//            }
//        })
//    }
//}
