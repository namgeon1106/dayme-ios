//
//  HomeChecklistCardList.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit

#if DEBUG
#Preview(traits: .fixedLayout(width: 375, height: 295)) {
    let cardList = HomeChecklistCardList()
    // cardList.items = mockChecklistDateItem
    return cardList
}
#endif

final class HomeChecklistCardList: UICollectionView {
    
    weak var cardDelegate: HomeChecklistCardRowDelegate?
    
    var items: [ChecklistDateItem] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                backgroundView = items.count == 0 ? emptyView : nil
                reloadData()
            }
        }
    }
    
    let spacing: CGFloat = 16
    
    // MARK: UI properties
    
    private let emptyView = HomeChecklistEmptyView()
    
    
    // MARK: Lifecycles
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        collectionViewLayout = createLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    private func setup() {
        backgroundColor = .clear
        dataSource = self
        register(HomeChecklistCard.self)
        register(HomeAllChecklistCard.self)
        isPagingEnabled = false
        showsHorizontalScrollIndicator = false
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let halfSpacing: CGFloat = spacing / 2
        // 1. Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: halfSpacing, bottom: 5, trailing: halfSpacing) // 셀 간격
        
        // 2. Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 3. Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // 페이징 스크롤
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: halfSpacing, bottom: 0, trailing: halfSpacing) // 섹션 여백
        
        // 4. Layout
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

// MARK: - UICollectionViewDataSource

extension HomeChecklistCardList: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count > 0 ? items.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 { // 전체 체크리스트
            let cell: HomeAllChecklistCard = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = cardDelegate
            cell.bind(all: items)
            return cell
        } else { // 주요목표별 체크리스트
            let cell: HomeChecklistCard = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = cardDelegate
            cell.bind(item: items[indexPath.item - 1])
            return cell
        }
    }
    
    
}
