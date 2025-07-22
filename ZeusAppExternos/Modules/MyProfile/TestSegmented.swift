//
//  TestSegmented.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 25/09/24.
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
//@IBDesignable
class ZDSSegmentedController: UIView {
    
    //MARK: - Properties
    var stackView: UIStackView = UIStackView()
    var buttonsCollection: [UIButton] = []
    var currentIndexView: UIView = UIView(frame: .zero)
    var grayBackView: UIView = UIView()
    var buttonPadding: CGFloat = 0
    var stackViewSpacing: CGFloat = 0
    
    //MARK: - Callback
    var didTapSegment: ((_ indexValue: Int) -> Void)? = nil
    
    //MARK: - Inspectable Properties
    var currentIndex: Int = 0 {
        didSet {
            setCurrentIndex()
        }
    }
    
    var currentIndexTitleColor: UIColor = .white {
        didSet {
            updateTextColors()
        }
    }
    
    var currentIndexBackgroundColor: UIColor = .systemTeal {
        didSet {
            setCurrentViewBackgroundColor()
        }
    }
    
    var otherIndexTitleColor: UIColor = .gray {
        didSet {
            updateTextColors()
        }
    }
    
    var cornerRadius: CGFloat = 15 {
        didSet {
            setCornerRadius()
        }
    }
    
    var buttonCornerRadius: CGFloat = 10 {
        didSet {
            setButtonCornerRadius()
        }
    }
    
    var borderColor: UIColor = .systemTeal {
        didSet {
            setBorderColor()
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            setBorderWidth()
        }
    }
    
    var numberOfSegments: Int = 2 {
        didSet {
            addSegments()
        }
    }
    
    var segmentsTitle: String = "Segment 1,Segment 2" {
        didSet {
            updateSegmentTitles()
        }
    }
    
    //MARK: - Life cycle
    override init(frame: CGRect) { //From code
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) { //From IB
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCurrentIndex()
    }
    
    //MARK: - Functions
    private func commonInit() {
        backgroundColor = .clear
        
        setupStackView()
        addSegments()
        setCurrentIndexView()
        setCurrentIndex(animated: false)
        
        setCornerRadius()
        setButtonCornerRadius()
        setBorderColor()
        setBorderWidth()
    }
    
    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()
        addSubview(grayBackView)
        grayBackView.backgroundColor = UIColor(hexString: "#EAE9EB")
        addSubview(currentIndexView)
        currentIndexView.layer.cornerRadius = 5
        currentIndexView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        grayBackView.layer.cornerRadius = 5
        grayBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    private func setCurrentIndex(animated: Bool = true) {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                let buttonWidth = frame.width / CGFloat(numberOfSegments)
                
                self.grayBackView.frame = CGRect(x: 0, y: self.stackView.frame.height,width: self.stackView.frame.width, height: 3)
                
                if animated {
                    UIView.animate(withDuration: 0.3) {
                        self.currentIndexView.frame =
                            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                                   y: self.stackView.frame.height,
                               width: buttonWidth,
                               height: 3)
                    }
                } else {
                    self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.stackView.frame.height,
                           width: buttonWidth,
                           height: 3)
                }
                button?.titleLabel?.font = UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.titleLabel?.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }
    
    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }
    
    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = currentIndexBackgroundColor
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        stackView.backgroundColor = .clear
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ]
        )
    }
    
    private func addSegments() {
        //Remove buttons
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        let titles = segmentsTitle.split(separator: ",")
        
        for index in 0 ..< numberOfSegments {
            let button = UIButton()
            button.tag = index

            if let index = titles.indices.contains(index) ? index : nil {
                button.setTitle(String(titles[index]), for: .normal)
            } else {
                button.setTitle("<Segment>", for: .normal)
            }
            
//            button.titleLabel?.font = .systemFont(ofSize: 16)
            
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }
    
    private func updateSegmentTitles() {
        let titles = segmentsTitle.split(separator: ",")
        
        stackView.subviews.enumerated().forEach { (index, view) in
            if let index = titles.indices.contains(index) ? index : nil {
                (view as? UIButton)?.setTitle(String(titles[index]), for: .normal)
            } else {
                (view as? UIButton)?.setTitle("<Segment>", for: .normal)
            }
        }
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = cornerRadius
        }
        
//        currentIndexView.layer.cornerRadius = 0
    }
    
    private func setBorderColor() {
        layer.borderColor = borderColor.cgColor
    }
    
    private func setBorderWidth() {
        layer.borderWidth = borderWidth
    }
    
    //MARK: - IBActions
    @objc func segmentTapped(_ sender: UIButton) {
        segmentTapped(tag: sender.tag)
    }
    
    func segmentTapped(tag: Int) {
        didTapSegment?(tag)
        currentIndex = tag
    }
}
