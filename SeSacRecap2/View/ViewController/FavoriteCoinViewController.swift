//
//  FavoriteCoinViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import Kingfisher


// 0번 렘에서 저장된 즐겨찾기들을 가져오기 ok
// 1번 통신 어떻게 오는지 테스트 ok
// 2번 이번엔 뷰가쓸 모델과 뷰모델과 다른 뷰모델들을 연계해보자

final class FavoriteCoinViewController: HomeBaseViewController<CollectionHomeView> {
    let viewModel = FavoriteCoinViewModel()
    var disPatchQueItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("@@@@@@@",#function)
        subscribe()
        settingNavigation()
        
    }
    
    override func delegateDatasource() {
        homeView.collectionCoinView.delegate = self
        homeView.collectionCoinView.dataSource = self
        
        // MARK: Drag And Drop
        homeView.collectionCoinView.dragDelegate = self
        homeView.collectionCoinView.dropDelegate = self
        homeView.collectionCoinView.dragInteractionEnabled = true
    }
    deinit{
        print("왜 즐찾",self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        viewModel.viewWillTrigger.value = nil
//        viewModel.maximViewWillTrigger.value = nil
//        viewModel.errorOutput.value = nil
        // 이렇게 해보았지만 역시.... 안됨
        // 이건 말이 될것 같은ㄷ
        //viewModel.viewWillTrigger.unBind()
        //viewModel.maximViewWillTrigger.unBind()
        //viewModel.errorOutput.unBind()
        disPatchQueItem?.cancel()
    }
}

extension FavoriteCoinViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.succesOutPut.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
            return UICollectionViewCell()
        }
        viewModel.indexPathInput.value = indexPath.item
        
        cell.coinInfoView.viewModel.inputModel.value = viewModel.coinInModelOutPut.value
        
        cell.coinPriceChangeView.coinViewModel.coinPriceModel.value = viewModel.coinPriceModelOutPut.value
        
        cell.coinPriceChangeView.coinViewModel.alimentCase.value = .right
        cell.backgroundColor = .white
        cell.setupShadow(true)
        cell.layer.cornerRadius = 12
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.nextIndexPathInput.value = indexPath.item
    }
}


extension FavoriteCoinViewController {
    func subscribe(){
        viewModel.errorOutput.bind { [weak self] error in
            guard let error else {return}
            guard let self else {return}

            disPatchQueItem?.cancel()
            
            disPatchQueItem = DispatchWorkItem {
                [weak self] in
                guard let self else {return}
                showAlert(error: error)
                viewModel.viewWillTrigger.value = ()
            }
            if let disPatchQueItem{
            DispatchQueue.main.asyncAfter(deadline: .now() + 40 , execute: disPatchQueItem)
            }
        }
        viewModel.succesOutPut.bind {[weak self] sucsess in
            guard let self else {return}
            guard let sucsess else {return}
            homeView.collectionCoinView.reloadData()
            
            disPatchQueItem?.cancel()
            
            disPatchQueItem = DispatchWorkItem {
                [weak self] in
                guard let self else {return}
                showAlert(text: "업데이트!", message: "최신화!")
                viewModel.viewWillTrigger.value = ()
            }
            if let disPatchQueItem{
            DispatchQueue.main.asyncAfter(deadline: .now() + 10 , execute: disPatchQueItem)
            }
            
        }
        viewModel.nextCoinOutPut.bind { [weak self] coinModel in
            guard let self else {return}
            guard let coinModel else {return}
            let vc = CoinChartViewController()
            vc.viewModel.coinInfoInput.value = coinModel
            vc.viewModel.inputViewdidLoadTrigger.bind {[weak self] _ in
                guard self != nil else {return}
                // **&&**
                //viewModel.viewWillTrigger.value = ()
                //homeView.collectionCoinView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension FavoriteCoinViewController {
    func settingNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NavigationTitleSection.Favorite.title
        let rightBarButton = UserButton(image: UIImage(named: "tab_user_inactive"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: 죄송합니다 이방법밖에는 더이상..... ㅠㅠ
extension FavoriteCoinViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillTrigger.value = ()
    }
}

// MARK: Drag, Drop
// 이걸 사용하게 되면 UItextField 에서
// becomeFirstResponder ->  resignFirstResponder 로 됨 즉 셀이동시 키보드 내려감.
extension FavoriteCoinViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 1. 여기까지만 해도 뜬다 근데 NSItemProvider란 무엇일까?
        // 신성한 변역기님의 답변은 아이템 공급자라고 한다.
        // 애플문서에는 이렇게 적혀있다
        /*
         끌어서 놓기 또는 복사하여 붙여넣기 활동 중 또는 호스트 앱에서 앱 확장으로 프로세스 간에 데이터나 파일을 전달하기 위한 항목 공급자입니다.
         */
        // 정말 이해가 쉽게 적어놓았다
        // 그래서 찾아보니 대략적인 내용은 이러했다.
        // 앱 간 혹은 앱 내에서 데이터를 전달하는 방법을 추상화 한것.
        // 마치 IPhone7 인가 그때 있었던 액션 터치? 느낌이다.
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension FavoriteCoinViewController: UICollectionViewDropDelegate {
    // 코드가 상당히 어지럽다 하나 하나 이해라도 해보자...
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // 드롭한 목적지 위치를 저장해놓을 변수
        var destinetionIndexPath: IndexPath
        
        // 만약 아이템을 놓을려는 곳이 명시적(목적지)이라면
        if let indexpath = coordinator.destinationIndexPath {
            // 목저지 인덱스 변수에 인덱스패스를 전달합니다.
            destinetionIndexPath = indexpath
        } else { // 명시적인 위치가 아니라면, 마지막 아이템 위치를 목적지로 설정합니다.
            // 컬렉션뷰. 넘버 Of Items 가 섹션 0 즉 섹션0 의 모든 아이탬 개수를 반환
            let row = collectionView.numberOfItems(inSection: 0)
             // 모든 아이템 -1 즉 0,1,2,3,4 순이니 -1을 하여 마지막 위치에 전달
            destinetionIndexPath = IndexPath(item: row - 1 , section: 0)
        }
        
        // 현재 .move 가 아닌 상태라면
        // 코디네이터 가 제안.운영 이 무브가 아니라면 그만
        guard coordinator.proposal.operation == .move else { return }
        
        // 또다른 무브 메서드로 필요한 것만 옮김
        move(coordinator: coordinator, destinationIndexPath: destinetionIndexPath, collectionView: collectionView)
    }
    private func move(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        // 드래그된 아이템 첫번째 아이템 즉 드래그된 아이템과
        guard let sourceItem = coordinator.items.first,
              // 원래의 아이템의 원본위치 이 있을때만 작동
              let sourceIndexPath = sourceItem.sourceIndexPath else {
            return
        }
        
        collectionView.performBatchUpdates {
            [weak self] in
            guard let self else {return}
            // 데이터 모델을 업데이트하는 새로운 메서드로 이동
            move(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        } completion: { [weak self] finish in
            // 배치 업데이트가 완료가 되었다면!
            guard self != nil else {return}
            
            print("끝",finish)
            // 코디네이터 애니메이션 드롭 메서드를 호출시켜 위치로 이동해 보이게 함.
            coordinator.drop(sourceItem.dragItem, toItemAt: destinationIndexPath)
        }
        // MARK: 애니메이션 효과를 주는 코디네이터 드롭은 performBatch업뎃 후에 수행해야함
    }
    
    // MARK: 아이템을 실제로 옮기는 메서드
    private func move(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        // 데이터 모델에서 현재 아이템들의 리스트를 가져 옵니다. 없으면 그만
        guard var data = viewModel.succesOutPut.value else {return}
        // 이동할 아이템을 배열에서 가져옵니다. 소스 즉 드래그된 인데스패스의 아이템을 이용
        let sourceItem = data[sourceIndexPath.item]
        // UI 관련은 화가 백 Main 쓰레드에게 하라고합니다.
        DispatchQueue.main.async {
            [weak self] in
            guard let self else {return}
            // 원본 배열을 복사한 곳에 일단 해당 위치 제거합니다.
            data.remove(at: sourceIndexPath.item)
            // 해당 위치에 드래그된 아이템을 삭제당한 친구위치에 넣어줍니다.
            data.insert(sourceItem, at: destinationIndexPath.item)
            
            let indexPaths = data.enumerated() // 배열의 인덱스 생성
                .map(\.offset) // 인덱스만
                .map{
                    IndexPath(row: $0, section: 0) // 인덱스 패스에 응하는 배열생성
                }
            // 애니메이션을 사용하지 않습니다. -> 해보니까 애니메이션 주면 부자연스러움
            UIView.performWithoutAnimation {
                [weak self] in
                guard let self else {return}
                viewModel.succesOutPut.value = data
                // 해당 인덱스 패스 아이템을 리로드 합니다.
                homeView.collectionCoinView.reloadItems(at: indexPaths)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // 콜렉션뷰가 드래그를 활성화 했나요?
        guard collectionView.hasActiveDrag else {
            // 안했군요 그럼 동작하면 안되요~ .금지!
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        // 드래그를 활성화 하셨군요 그럼 이동해주세요 ! 대상 인덱스 경로에!
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

/*
 //        ReloadViewModel.shared.outputLoadView.bind {
 //            [weak self] void in
 //            guard let void else {return}
 //            guard let self else {return}
 //            viewModel.viewWillTrigger.value = ()
 //        }
 */
extension FavoriteCoinViewController {
    func testerAreat(){
        /*
        let indexPaths = data.enumerated()
            .map(\.offset)
            .map{
                IndexPath(row: $0, section: 0)
            }
        */
        // 이게 도대체 뭔말일까 한번 하나하나 해보자
        // 일단 연세 혹은 나이가 어린순으로 두어보자
        let data = ["Hue","Jack","Bran","Den"] // 휴잭 맨스
        let sourceDataIndexPath = IndexPath(item: 0, section: 0) // 휴님
        let destinationIndexPath = IndexPath(item: 3, section: 0) // Den님
        var modify = data
        let itemMove = modify.remove(at: sourceDataIndexPath.item) // 휴님이 나오셨어! ["Jack","Bran","Den"]
        modify.insert(itemMove, at: destinationIndexPath.item ) // 덴님 자리에 들어갔어! ["Jack","Bran","Den","Hue"]
        // 자 이제 위의 끝판왕을 다시 볼까? 이넘레이트는 알잖아

        let enumResults = modify.enumerated() // [0 "Jack",1 "Bran",2 "Den",3 "Hue"] // 튜블 배열이됨
        let indexes = enumResults.map(\.offset) // [0, 1, 2, 3] 인덱스만 추출
        let indexPaths = indexes.map {
            IndexPath(row: $0, section: 0) // [[0, 0], [0, 1], [0, 2], [0, 3]]
        }// IndexPath에 대응하는 배열이 생성
        
        
        
    }
}
