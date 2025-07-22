//
//  MostUsedView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 21/06/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
class MostUsedView: UIView {
    
    lazy var collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var moreItemsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let iconForBtn = UIImage(systemName: "chevron.up")?.withTintColor(.black, renderingMode: .alwaysTemplate)
        btn.setImage(iconForBtn, for: .normal)
        btn.tintColor = UIColor(named: "newOptionsTint")
        btn.addTarget(self, action: #selector(didTapShowMoreItems), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
        cv.register(MyFavoritesCell.self, forCellWithReuseIdentifier: MyFavoritesCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.clipsToBounds = false
        return cv
    }()

    var isAnnouncementsHidden: Bool = false
    var delegate: HomeViewControllerPermission?
    var menuFrameworks: [PermissionMenuModel]?
    var goToFavoriteSelected: ((_ permissionItem: PermissionMenuModel) -> Void)? = nil
    var showModulesMenu: ((_ permissionItem: [PermissionMenuModel]) -> Void)? = nil
    var isLoading: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContraints()
    }
    
    private func setupContraints() {
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(didTapShowMoreItems))
        tap.direction = .up
        self.collectionViewContainer.isUserInteractionEnabled = true
        self.collectionViewContainer.addGestureRecognizer(tap)
        addSubview(moreItemsButton)
        addSubview(collectionViewContainer)
        
        
        collectionViewContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            moreItemsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            moreItemsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreItemsButton.widthAnchor.constraint(equalToConstant: 20),
            moreItemsButton.heightAnchor.constraint(equalToConstant: 15),
            
            collectionViewContainer.topAnchor.constraint(equalTo: topAnchor),
            collectionViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: moreItemsButton.topAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor, constant: 36),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor, constant: -36),
            collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor, constant: 0),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    @objc private func didTapShowMoreItems(){
        guard let menuFrameworks = menuFrameworks else {return}
        showModulesMenu?(menuFrameworks)
    }

    
    
}

extension MostUsedView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAnnouncementsHidden {
            if menuFrameworks?.count ?? 0 >= 9 {
                return 9
            } else {
                return menuFrameworks?.count ?? 0
            }
        }
        if menuFrameworks?.count ?? 0 >= 6 {
            return 6
        } else {
            return menuFrameworks?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoritesCell.identifier, for: indexPath) as? MyFavoritesCell else {
            return UICollectionViewCell()
        }
        //MARK: CHECK
        cell.isLoading = isLoading
        guard let data = menuFrameworks?[indexPath.row] else {return cell}
        cell.configureCell(data: data, badge: 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let permisson = menuFrameworks?[indexPath.row] else {return}
        SessionInfoQueries.shared.updateBadgePriority(idPermission: permisson.idPermission, priority: 4)
        delegate?.updateData()
        goToFavoriteSelected?(permisson)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewHeight = collectionView.frame.height
        let padding: CGFloat = 20 // 16 points on each side
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize / 3 // Three cells in a row
        let height: CGFloat = (collectionView.frame.height - 20) / 3 //
        
        if viewHeight < 200.0 {
            
            if isAnnouncementsHidden {
                let height: CGFloat = (collectionView.frame.height - 20) / 3 //
                return CGSize(width: width, height: height)
            }
            
            let height: CGFloat = (collectionView.frame.height - 20) / 2 //
            return CGSize(width: width, height: height)
        }
        
        if isAnnouncementsHidden {
            return CGSize(width: width, height: height)
        }
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
