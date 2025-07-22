//
//  PromoView.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 22/07/24.
//

import Foundation
import UIKit
import UPAXNetworking

var itemsForCarrousel = 3
var secondsAnnouncements = 0
var currentAnnouncementIdx = 0
var timesSettingAnnouncementIdx = 0
protocol PromoViewDelegate: AnyObject {
    func didSelectItem(type: CarrouselModel, idx: Int)
}

class PromoView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var promoDelegate: PromoViewDelegate?
    var isShimmer = false
    var previousOffset: CGFloat = 0.0
    var shouldPauseVideoStreaming = false {
        didSet {
           reloadData()
        }
    }

    var data: [CarrouselModel] = []

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: PromoView.createLayout())
        self.register(PromoViewCell.self, forCellWithReuseIdentifier: PromoViewCell.reuseIdentifier)
        self.register(VideoBannerCell.self, forCellWithReuseIdentifier: VideoBannerCell.reuseIdentifier)
        self.register(LottieViewCell.self, forCellWithReuseIdentifier: LottieViewCell.reuseIdentifier)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = true
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    func reloadLayout() {
        self.collectionViewLayout = PromoView.createLayout()
        self.reloadData()
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(itemsForCarrousel == 1 ? 1.0 : 0.9), heightDimension: .fractionalHeight(1)), subitems: [item])
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 10
            let collectionViewWidth = screenFrame.width - 32.0
            section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
                secondsAnnouncements = 0
                let itemWidth = env.container.contentSize.width * 0.7
                let spacing = CGFloat(10)
                let index = Int(round(offset.x / (itemWidth + spacing)))
                currentAnnouncementIdx = index
                var value: CGFloat = 0.0
                if itemsForCarrousel == 3 {
                    value = (((collectionViewWidth * 0.7) - (10.0 * CGFloat(itemsForCarrousel))) * CGFloat(itemsForCarrousel))
                } else if itemsForCarrousel == 2 {
                    value = (((collectionViewWidth * 0.7) * CGFloat(1.4)))
                }
                print("offset : \(offset.x) mayor que \(value), index = \(index)")
                if offset.x > value {
                    NotificationCenter.default.post(name: NSNotification.Name("GoToStart"), object: nil)
                }
                
            }
            return section
        }
    }
    
    /*func reloadItemsWithData(items: Int) {
        data.removeAll()
        for _ in 0..<items {
            data.append( CarrouselModel(name: "Imagen", color: nil, textColor: nil, image: nil, imageURL: "https://images.inc.com/uploaded_files/image/1920x1080/getty_898700298_2000131816537672530_353744.jpg", banner: nil, bannerType: .Image))
        }
        self.reloadData()
    }*/

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addModel(_ model: CarrouselModel) {
        data.append(model)
        //sortModels()
        reloadData()
    }

    /*private func sortModels() {
        data.sort { (first, second) -> Bool in
            guard let firstBannerType = first.bannerType, let secondBannerType = second.bannerType else {
                return false
            }
            switch (firstBannerType, secondBannerType) {
            case (.Video, .Lottie), (.Video, .Image), (.Lottie, .Image):
                return true
            case (.Lottie, .Video), (.Image, .Video), (.Image, .Lottie):
                return false
            default:
                return false
            }
        }
    }*/

    /*func setBannerVideoUrl(url: String) {
        let video = CarrouselModel(name: "Video", color: nil, textColor: nil, image: nil, imageURL: url, banner: nil, bannerType: .Video)
        addModel(video)
    }

    func setBannerLottie(isResultsValue: Bool) {
        let video = CarrouselModel(name: "Lottie", color: nil, textColor: nil, image: nil, imageURL: nil, banner: nil, bannerType: .Lottie, isResult: isResultsValue)
        addModel(video)
    }*/

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        /*guard let type = data[indexPath.row].type == 1 else {
            return UICollectionViewCell()
        }

        switch type {

        case .Video:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoBannerCell.reuseIdentifier, for: indexPath) as? VideoBannerCell else {
                return UICollectionViewCell()
            }
            cell.configureViewAsVideo(url: data[indexPath.row].imageURL ?? "")
            return cell
        case .Lottie:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LottieViewCell.reuseIdentifier, for: indexPath) as? LottieViewCell else {
                return UICollectionViewCell()
            }

            return cell
        default:
            
        }*/
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoViewCell.reuseIdentifier, for: indexPath) as? PromoViewCell else {
            return UICollectionViewCell()
        }
        if isShimmer {
            cell.image.image = UIImage(named: "shimmerannouncement")
           
            cell.addShimmer()
        } else {
            cell.setImage(url: data[indexPath.row].imageURL ?? "")
            cell.bannerLabel.text = data[indexPath.row].name
            cell.hideShimmer()
        }
      
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        promoDelegate?.didSelectItem(type: data[indexPath.row], idx: indexPath.row)
    }
    
    func addShimmer() {
        isShimmer = true
        self.reloadData()
    }
    
    func removeShimmer() {
        isShimmer = false
        self.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height

        let cellWidth = collectionViewWidth * 0.7
        let cellHeight = collectionViewHeight

        return CGSize(width: cellWidth, height: cellHeight)
    }
}


enum BannersEKT : String {
    case ADN40 = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/adn40.jpg"
    case DEZZER = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/dezzer.jpg"
    case RED_SOCIAL = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/redSocial.jpg"
    case BUEN_FIN = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/buenFin.jpg"
    case MEJORES_PROMOS = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/mejoresPromos.jpg"
    case PRODUCTOS_FINANCIEROS = "https://prod.survey.files.zeusgs.com.mx/HomeMobile/banners/jpeg/somos.jpg"
}

struct CarrouselModel : UNCodable {
    let id: String = UUID().uuidString
    let name: String
    let description: String
    let initDate: String
    let finishDate: String
    let imageURL: String?
    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "idComunicado"
        case name = "nombre"
        case description = "descripcion"
        case initDate = "fechaInicio"
        case finishDate = "fechaFin"
        case imageURL = "ulrPortada"
        case type = "tipoDestacado"
    }
    
    public  func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", serializedName: "idComunicado", requiresEncryption: true),
            .init(property: "name", serializedName: "nombre", requiresEncryption: false),
            .init(property: "description", serializedName: "descripcion", requiresEncryption: false),
            .init(property: "initDate", serializedName: "fechaInicio", requiresEncryption: false),
            .init(property: "finishDate", serializedName: "fechaFin", requiresEncryption: false),
            .init(property: "imageURL", serializedName: "ulrPortada", requiresEncryption: false),
            .init(property: "type", serializedName: "tipoDestacado", requiresEncryption: false)
        ]
    }
  
}

struct BannersItems: Codable {
    let name: String?
    let urlIcon: String?
    let urlLink: String?
    let idBanner: Int?
    let idPermission: Int?
    //let typeLink: LinksItem?
    //let sector: SectorItems?
    
    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case urlIcon = "urlIcono"
        case urlLink
        case idBanner = "idBanner"
        case idPermission = "idPermiso"
        //case typeLink = "tipoLink"
        //case sector
    }
}

enum BannerViewType {
    case Image
    case Video
    case Lottie
}


