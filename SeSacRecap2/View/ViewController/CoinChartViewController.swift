//
//  CoinChartViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit
import SnapKit
import DGCharts
import Charts

// 들어가기에 앞서... 해당뷰는 homeView를 사용하지 않았습니다.
// MVVM 을 하면서 VC 가 View 라면 View를 또 달 필요가 있을까에 의문이 들어 이렇게 해보았습니다.

// MARK: 드디어 전뷰랑 연동이 되었다 ㅠㅠㅠㅠ
// MRAK: 전역적으로 연동할수 있는 법을 모르겠다....

enum CharSection:Int, CaseIterable {
    case high
    case low
    var title: (title:String, supers: String ) {
        switch self{
        case .high:
            return ("고가","신고점")
        case .low:
            return ("저가","신저점")
        }
    }
    var colorBool: Bool {
        switch self{
        case .high:
            return true
        case .low:
            return false
        }
    }
}

struct chartSectionData {
    var normal: String
    var supers: String

    init(normal: String, supers: String) {
        self.normal = normal
        self.supers = supers
    }
}

// 돌아오면 할것 
// 0. 값을 받아올거니까 고정해서 고민 // 값 전달 성공
// 1. 통신테스트 //
// 2. 데이터 뿌려주는 로직 고미
// 3. charView 고민

class CoinChartViewController: BaseViewController {
    let mainCoinView = CoinPriceView()
    let highLowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
    let lineChartView = LineChartView()
    let dateLabel = UILabel()
    
    let viewModel = CoinChartViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView() // 컬렉션뷰세팅
        navigationSetting() // 네비게이션 세팅
        view.backgroundColor = .white
        subscribe() // 구독
        // 차트뷰 세팅
        
    }
    override func configureHierarchy() {
        view.addSubview(mainCoinView)
        view.addSubview(highLowCollectionView)
        view.addSubview(lineChartView)
        view.addSubview(dateLabel)
    }
    override func configureLayout() {
        mainCoinView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        highLowCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(mainCoinView.snp.bottom)
            make.height.equalTo(180)
        }
        lineChartView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(highLowCollectionView.snp.bottom)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lineChartView)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    override func designView() {
        dateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dateLabel.textColor = .darkKey
    }

}

//MARK: 컬렉션뷰 세팅
extension CoinChartViewController {
    func settingCollectionView(){
        highLowCollectionView.dataSource = self
        highLowCollectionView.delegate = self
        highLowCollectionView.register(CoinPriceDetailCollectionViewCell.self, forCellWithReuseIdentifier: CoinPriceDetailCollectionViewCell.reusableIdentifier)
        highLowCollectionView.isScrollEnabled = false
    }
}


// MARK: 컬렉션뷰 딜리게이트 데이타 소스
extension CoinChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionDataOutput.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinPriceDetailCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinPriceDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        cell.price.text = viewModel.collectionDataOutput.value[indexPath.row].normal
        
        cell.superPrice.text = viewModel.collectionDataOutput.value[indexPath.row].supers
        
        cell.priceTitle.text = CharSection.allCases[indexPath.row].title.title
        
        cell.superPriceTitle.text = CharSection.allCases[indexPath.row].title.supers
        
        viewModel.cellTextColorInput.value = indexPath
        
        // MARK: $$$$ 컬러 후에 적용해야해
        if let bool = viewModel.cellectionCellColorBool.value {
            cell.superPriceTitle.textColor = bool ? .red : .blue
            cell.priceTitle.textColor = bool ? .red : .blue
        }
        
        return cell
    }
}


// MARK: 컬렉션뷰 레이아웃
extension CoinChartViewController {
    static func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 4
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: 180) // 셀의 크기
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.scrollDirection = .horizontal
        
        return layout
    }

}
// NavigationSetting
extension CoinChartViewController {
    func navigationSetting(){
        navigationController?.navigationBar.showsLargeContentViewer = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    // MARK: 문제상황
    @objc // MARK: 어떻게 해야할까.
    func likeButtonState(_ sender: UIButton){
        print(#function)
        viewModel.checkedButtonStateInput.value = ()
    }
}

extension CoinChartViewController {
    func subscribe(){
        viewModel.mainCoinInfoOutput.bind {[weak self] coinModel in
            guard let self else {return}
            mainCoinView.viewModel.coinInput.value = coinModel
        }
        viewModel.collectionDataOutput.bind {[weak self] _ in
            guard let self else {return}
            highLowCollectionView.reloadData()
        }
        viewModel.chartDataOutPut.bind {[weak self] doubles in
            guard let self else {return}
            let datas = doubles.enumerated().map { index, value in
                ChartDataEntry(x: Double(index), y: value)
            }
            // MARK: 데이터 세팅
            let line = LineChartDataSet(entries: datas)
            // let lineData = LineChartData(dataSet: line)
            let test = ChartDatasetFactory().makeChartDataset(colorAsset: .myPuPle, entries: datas)
            let test2 = LineChartData(dataSet: test)
            
            settingChart(data:test2)
        }
        viewModel.dateLabelInfoOutput.bind {[weak self] string in
            guard let self else {return}
            dateLabel.text = string
        }
        
        viewModel.firstButtonState.bind { [weak self] result in
            guard let self else {return}
            guard let result else {return}
            
            let button = StarButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.addTarget(self, action: #selector(likeButtonState), for: .touchUpInside)
            button.isSelected = result
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
            viewModel.inputViewdidLoadTrigger.value = ()
        }
        viewModel.errorOutPut.bind {[weak self] message in
            guard let message else {return}
            guard let self else {return}
           showAlert(text: message, message: "")
        }
    }
}

extension CoinChartViewController {
    func settingChart(data: LineChartData){
        // disable grid
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        
        // disable axis annotations
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        // disable legend
        lineChartView.legend.enabled = false
        
        // disable zoom
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = true
        
        // remove artifacts around chart area
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.drawBordersEnabled = false
        
        // 3시간 넘게 짱돌 굴려서 해본 수학
       let dataAver = data.yMax - data.yMin
        lineChartView.leftAxis.axisMinimum = data.yMin - dataAver
        
        // print(Double((data.count) * 2))
        // lineChartView.xAxis.axisMaximum = data.yMin //Double((data.count) * 2)
        print( data.yMax, "@@@", data.yMin, "@@@",data.xMin, "@@@",data.xMax)
        
        lineChartView.minOffset = 0
        lineChartView.data = data
        //  https://stackoverflow.com/questions/59613110/how-to-create-balloon-marker-xib-view-in-ios-charts
        // let marker = marker
        lineChartView.animate(xAxisDuration: 1)
        lineChartView.animate(yAxisDuration: 1)
    }
}

extension CoinChartViewController: ChartViewDelegate {
    
}


/*
 mainCoinView.coinName.text = "코인이름"
 mainCoinView.dateLabel.text = "날짜"
 mainCoinView.persentage.text = "퍼센트"
 mainCoinView.priceLabel.text = "가격"
 */
