//
//  SeriesViewController.swift
//  LocationEKT
//
//  Created by ARIEL DIAZ on 24/11/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusCoreInterceptor
import ZeusCoreDesignSystem
import ZeusUtils

enum TypeSerie {
    case standard
    case fibonacci
    case natural
    
}

let standarSerie: [String] = ["1","3","5","8","13","21","33","?","tacita"]
let fibonacciSerie: [String] = ["1","2","3","5","8","13","21","34","55","?","inf","tacita"]
let naturalSerie: [String] = ["1","2","3","4","5","6","7","8","9","0","inf","tacita"]
let infImage = UIImage(named: "ic_inf", in: .local, compatibleWith: nil)!
let tacitaImage = UIImage(named: "ic_little_cup", in: .local, compatibleWith: nil)!
let imageDic: [String: UIImage] = ["inf": infImage, "tacita": tacitaImage]

class PokerSeriesViewController: BaseViewController {

    @IBOutlet weak var viewForHeader: UIView!
    
    // MARK: Attributes
    var scrollView: UIScrollView!
    var collectionViews: [UICollectionView] = []
    var layout: UICollectionViewFlowLayout!
    
    var reuseIDCell: String = "collectionCell"
    var refreshCon: UIRefreshControl? = nil
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    let numberOfItemsInSection: Int = 9
    var typeSerie: TypeSerie = .standard
    var viewForParallax: TypeSerieParallax!
    var enabledInteractiveScroll = true
    var didLayot: Bool = false
    fileprivate var widthPerItem: CGFloat {
        let paddingSpace = sectionInsets.left * CGFloat(numberOfItemsInSection + 1)
        let availableWidth = view.frame.width - paddingSpace
        return availableWidth / (1.2*CGFloat(self.numberOfItemsInSection))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didLayot {
            setUpParallax()
            setCollectionView()
        }
    }
    
    override func backMethod() {
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    override func viewDidLoad() {
        self.udnColor = UDNSkin.global.color
        titleString = "Planning Poker"
        udnColor = .zeusPrimaryColor
        super.viewDidLoad()
  
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func backAction() {
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailSelectedViewController,
            let indexPath = sender as? IndexPath {
            detailViewController.serieItem = indexPath.item
            switch indexPath.section {
            case 0: detailViewController.typeSerie = .standard
            case 1: detailViewController.typeSerie = .fibonacci
            default: detailViewController.typeSerie = .natural
            }
        }
    }
    
    func setCollectionView() {
        let yPosition: CGFloat = (self.navigationController?.navigationBar.globalFrame?.maxY ?? 0) + viewForHeader.frame.height
        
        (0 ..< 3).forEach {
            layout = UICollectionViewFlowLayout()
            let collectionViewFrame = CGRect(x: view.frame.width*CGFloat($0), y: 0, width: view.frame.width, height: view.frame.height - yPosition - 60)
            layout.scrollDirection = .vertical
            let paddingSpace = sectionInsets.left * 4.0
            let availableWidth = collectionViewFrame.width - paddingSpace
            let widthPerItem = availableWidth / 3.0
            let availableHeight = collectionViewFrame.height - 60
            let heightPerItem = availableHeight / 3.0
            
            layout.itemSize = CGSize(width: widthPerItem, height: heightPerItem)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.headerReferenceSize = CGSize(width: 0, height: 0)
            layout.sectionInset = sectionInsets
            
            let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
            collectionView.register(UINib(nibName: "SeriesCellCollectionViewCell", bundle: .local), forCellWithReuseIdentifier: reuseIDCell)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.tag = $0
            collectionView.makeViewWith(features: [.color(.clear)])
            collectionViews.append(collectionView)
        }
        
        let heightForScroll: CGFloat = view.frame.height - yPosition
        scrollView = UIScrollView(frame: CGRect(x: 0, y: yPosition, width: view.frame.width, height: heightForScroll))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        
        collectionViews.forEach {
            scrollView.contentSize = CGSize(width: CGFloat(collectionViews.count)*view.frame.width, height: heightForScroll)
            scrollView.addSubview($0)
            
        }
    }
    
    private func setUpParallax() {
        self.didLayot = true
        viewForParallax = UIView.fromNib()
        viewForParallax.frame = viewForHeader.bounds
        viewForParallax.indicatorView.backgroundColor = .orangePlanningPoker
        viewForHeader.addSubview(viewForParallax)
        viewForParallax.seriesButtons.forEach {
            $0.addTarget(self, action: #selector(seriesButtons(_:)), for: .touchUpInside)
        }
    }
    
    @objc func seriesButtons(_ sender: ZDSButtonAlt) {
        let offset = CGPoint(x: scrollView.frame.width*CGFloat(sender.tag), y: 0)
        enabledInteractiveScroll = false
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(offset, animated: false)
            
        }, completion: { _ in
            self.enabledInteractiveScroll = true
            self.scrollViewDidScroll(self.scrollView)
            
        })
    }
    
}

extension PokerSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViews[0]: return standarSerie.count
        case collectionViews[1]: return fibonacciSerie.count
        default:                 return naturalSerie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCell, for: indexPath) as! SeriesCellCollectionViewCell
        cell.label.textColor = .orangePlanningPoker
        switch collectionView {
        case collectionViews[0]:
            let color: UIColor = indexPath.item%2 == 0 ? .orangePlanningPoker : .orangePlanningPoker2
            cell.containerView.makeViewWith(features: [.rounded, .bordered(color, 2)])
            if let image = imageDic[standarSerie[indexPath.item]] {
                cell.image.tintColor = color
                cell.image.image = image
                cell.label.isHidden = true
                
            } else {
                cell.label.text = standarSerie[indexPath.item]
                cell.label.textColor = color
                
            }
        case collectionViews[1]:
            let color: UIColor = indexPath.item%2 == 0 ? .grayPlanningPoker : .orangePlanningPoker
            cell.containerView.makeViewWith(features: [.rounded, .bordered(color, 2)])
            if let image = imageDic[fibonacciSerie[indexPath.item]] {
                cell.image.tintColor = color
                cell.image.image = image
                cell.label.isHidden = true
                
            } else {
                cell.label.text = fibonacciSerie[indexPath.item]
                cell.label.textColor = color
                
            }
        default:
            let color: UIColor = indexPath.item%2 == 0 ? .orangePlanningPoker2 : .grayPlanningPoker2
            cell.containerView.makeViewWith(features: [.rounded, .bordered(color, 2)])
            if let image = imageDic[naturalSerie[indexPath.item]] {
                cell.image.tintColor = color
                cell.image.image = image
                cell.label.isHidden = true
                
            } else {
                cell.label.text = naturalSerie[indexPath.item]
                cell.label.textColor = color
                
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSelectedSegue", sender: IndexPath(item: indexPath.item, section: collectionView.tag))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView, enabledInteractiveScroll {
            let xOffset: CGFloat = scrollView.contentOffset.x
            let percentage: CGFloat = xOffset/(3*scrollView.frame.width)
            viewForParallax.setInteractiveOffset(percentage: percentage)
            
        }
    }
    
}

public class PlanningPokerItem: ZCInterceptorItem {
    
    public static var moduleName: String {
        return ZCIExternalZeusKeys.planningPoker.rawValue
    }
    
    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        let storyboard = UIStoryboard(name: "PlanningPoker", bundle: .local)
        let vc = storyboard.instantiateViewController(withIdentifier: "planningPokerRootVC")
        return vc
    }
}

public class PlanningFlows {

    public static func registerActions() {
        ZCInterceptor.shared.registerFlow(withNavigatorItem: PlanningPokerItem.self)
    }
}

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
