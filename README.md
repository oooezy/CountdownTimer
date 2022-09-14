# ⏰ 타이머 : Countdown Timer
![Badge](https://img.shields.io/badge/language-swift5.6-blue) 
![Badge](https://img.shields.io/badge/platform-iOS14+-yellow) 
![Badge](https://img.shields.io/badge/version-1.2.2-green)


<img width="30%" src = "https://user-images.githubusercontent.com/95845594/190113982-88b7b956-1ec3-4301-bbcd-bfb34ff2f848.gif">

---
## Countdown Timer App
- **설명**  : 심플하고 단순한 무료 타이머 앱으로, 원하는 시간만큼 타이머를 설정하여 낭비되는 시간들을 효율적으로 관리할 수 있습니다.
- **기간**  : 22.04.02 ~ 22.04.10
- **팀원**  : 이은지 (기획 / 디자인 / 개발 / 배포)
- **상태**  : App Store 배포 완료
- [🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/countdown-timer-%ED%83%80%EC%9D%B4%EB%A8%B8/id1617318596)


---
## 사용기술 및 라이브러리

- `Swift 5`, `RxSwift`, `Xcode 13`
- `Delegate Pattern`, `CAShapeLayer`, `CALayer`, `Animation`, `UserDefaults`, `UIPickerView`, `CocoaPods`, `UITest`, `Fastlane`, `SnapKit`, `Then`
- Code-based UI (No Storyboard)
- **MVVM 아키텍처** 적용
- 라이트 모드 / 다크모드 설정 구현
- Code Refactoring 과정을 통하여 효율적인 코드 작성
- **UI Test** 작성
- Fastlane 이용하여 **배포 자동화**
- **SnapKit** / **Then** 라이브러리 적용

---
## **앱을 만든 의도**

처음 iOS 공부를 시작할 때, 강의를 보고 하나 둘씩 따라해보는 식으로 공부를 했습니다. 간단한 기능 부터 조금 더 복잡한 기능까지, 10여가지가 넘는 기능들을 구현하다보니 ‘이제 나만의 앱을 만들어볼 수 있겠다!’라는 자신감이 생겼고, 바로 기획과 디자인을 시작하였습니다. 만들어보고 싶은 어플은 많았지만, 페이지수가 많고 기능이 많은 어플을 처음부터 욕심내어 만들게 되면, 개발 도중 지치게 될 확률이 높아서 빠른 성취감을 얻기 위해 **가장 간단하고 심플한 앱**을 생각했습니다. 그래서 첫 번째로 만들게 된 앱이 ‘**Countdown Timer**’ 앱 입니다.

이렇게 단순한 이유로 어플을 개발했지만, 비교적 복잡하지 않은 구조다 보니 새로운 **아키텍처나** **프레임워크**를 직접 적용해보며 더욱 더 쉽게 익혀볼 수 있었습니다. 앱을 배포한 후, 원하던 기능(다크모드, 알람설정)을 추가해 나가며 유지보수를 진행했고, 지금도 주변사람들의 피드백을 받으며 보완해나가고 있는 중입니다.

---
## **앱을 만들며 어려웠던 점**


### **1. 스토리보드 vs Code**

앱을 처음 만들며 스토리보드를 사용할지, 아니면 Code로만 UI를 구현할지 고민했습니다. 결국 저는 후자를 선택했고, 그 이유는 코드로 먼저 UI 개발을 해보면 추후에 스토리보드로 앱을 만들 때 훨씬 이해하기 쉬울거라는 생각이 들었기 때문입니다. 저는 직접 앱을 만들며 Swift에 대해 익히는게 가장 큰 목표었기에, 스토리보드가 아닌 코드로 구현했고, 예상대로 Swift에 익숙해지는데 많은 도움이 되었던 것 같습니다.

### **2. 중복되거나 반복되는 코드**

코드로 UI를 구현하다보니 반복되는 코드도 많고, 길이가 길어져서 고민이 많았습니다. 이를 해결하기 위해 자주 쓰거나 반복되는 코드들은 따로 Extension 으로 작성 후, 재사용할 수 있도록 구현하였습니다. 이 과정을 통해  앞으로 어떻게 코드를 작성해야 하는지 감을 잡게 되었고, 리팩토링과정이 왜 필요한지 깨닫게 되었습니다.

```swift
extension UILabel {
    func setLabelUI(text: String, type: UIFont.RobotoType, size: Int) {
        let label = self
        label.text = text
        label.font = UIFont.Roboto(type: type, size: CGFloat(size))
        label.textColor = UIColor.fontColor
    }
}
```

### **3. 앱 자체적으로 라이트모드 / 다크모드 구현**

내 핸드폰 모드와 상관없이 타이머 어플 자체에서 **사용자가 원하는 모드**를 **스위치를 통해 설정**하고, 이를 **어플 전체에 적용**시키길 원했습니다.

이를 구현하기 위해 우선 사용자가 설정 페이지에서 모드 스위치의 상태를 바꾸면UserDefault에 정보를 저장한 후, 앱을 다시 구동시킬 때 UserDefault 의 값을 불러와 생명주기에 적용시켰습니다.

```swift
@objc func modeSwitchChanged(_ sender: UISwitch) {
        if let window = UIApplication.shared.windows.first { // 앱 전체를 의미
            if #available(iOS 14.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
								// 스위치 상태가 켜져있으면 dark mode, 아니면 light mode
                defaults.set(modeSwitch.isOn, forKey: "darkModeState") // 변경된 스위치 값의 상태 저장
            } else {
                window.overrideUserInterfaceStyle = .light
                defaults.set(false, forKey: "darkModeState") // 변경된 스위치 값의 상태 저장
            }
        }
    }
```

```swift
override func viewDidLoad() {
...

settingVC.modeSwitch.isOn = defaults.bool(forKey: "darkModeState") 
// UserDefault에 저장되어 있는 값에 따라 스위치의 상태 바꾸기

...
}
```

### **4. 타이머 메모리 해제**

타이머를 종료하지 않고 바로 메인 페이지로 돌아가는 경우, 기존의 타이머가 사라지지 않고 계속 작동하는 오류가 발생했습니다. 이를 해결하기 위해 기존 타이머를 **메모리에서 해제**시켜주는 코드를 추가했습니다. 

```swift
/* TimerViewController */
override func viewWillDisappear(_ animated: Bool) {
    viewModel.cancelTimer()
    super.viewWillDisappear(animated)
}

/* ViewModel */
// 타이머를 새로 시작할 때도 혹시 남아있을 수 있는 타이머를 메모리에서 해제시켜준 후, 시작
func start() {
        cancelTimer()
        state = .started
        runTimer()
   }
```

### **5. 타이머가 시작 된 후, 1초의 delay**

타이머 시작 버튼을 누르면 `runTimer()` 가 실행되고, 0이 될 때까지 1초마다 `timeLabel`이 업데이트 되어야 합니다. 하지만 아래 코드만 작성했을 때, 타이머가 시작한 직후 `timeLabel` 이 업데이트 되는데 1초정도 딜레이되는 상황이 발생했습니다.

```swift
func runTimer() {
    Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { Int(self.duration) - ($0 + 1) }
        .take(until: { $0 == 0 }, behavior: .inclusive)
        .subscribe(onNext: { value in
						self.remainDuration = value
            let time = self.secondsToString(seconds: value)
            self.delegate?.timerUpdate(timeRemaining: time)
        }, onCompleted: {
            self.delegate?.timerDidFinish()
        })
        .disposed(by: disposeBag)
}
```

위 문제를 해결하기 위해서 Timer VIew가 열리면 유저가 선택한 만큼의 시간을 `timeLabel` 에 미리 적용시킨 후, 타이머가 `timeLabel` 을 업데이트하도록 설정하여 해결했습니다. 

```swift
/* TimerViewController */
override func viewDidLoad() {
	timeLabel.text = viewModel.secondsToString(seconds: Int(**duration**))
}
```

### 6. UITest 적용하기

```swift
let staticText = app.staticTexts("타이머 시작")
staticText.tap() 

let alarmButton = app.buttons["alarm Button"]
alarmbuttonButton.tap()
```

UITest를 적용하던 중에, 같은 버튼타입인데 아래처럼 다른 형식으로 입력되어지는 것을 보고, `app.buttons["startButton"]` 으로 바꿔보았더니 에러가 발생했습니다. 중복되는 버튼 이름이 있어서 에러가 발생하는 것 같아 `startButton` 에 `accessibilityIdentifier` 을 적용해주고 테스트코드 또한 수정해주었더니 정상적으로 작동하는 것을 확인할 수 있었습니다.

```swift
private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setStateButtonUI(buttonTitle: "타이머 시작")
        startButton.accessibilityIdentifier = "startButton"
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return startButton
    }()
```

```swift
let startButton = app.buttons.matching(identifier: "startButton").element
        startButton.tap()
```

이 오류를 해결하면서 `AccessibilityLabel`, ********`Accessibility identifier` 의 차이점과  중요성에 대해 알게 되었습니다.  👉 [해당 이슈 블로그](https://medium.com/@leeeeunz/swift-uitest%EB%A5%BC-%EC%A0%81%EC%9A%A9%ED%95%B4%EB%B3%B4%EC%9E%90-2-xcuiapplication-xcuelement-xcuelementquery-accessibilitylabel-31fc70a9cc10)

---
## **기획부터 배포까지의 과정**

기획부터 배포까지 혼자 진행하다보니 어려웠던 부분들이 꽤 많이 있었습니다. 오로지 구글과 Stackoverflow, 오픈카톡 등에 질문해가며 문제를 해결해 나갈 수 밖에 없는 과정에서 ‘팀원이 있었다면 더 효율적으로 해결해 나갈 수 있을 텐데’, ‘더 다양한 의견들을 들어보고 진행해나가면 좋을텐데’ 라는 아쉬움이 남았습니다.

하지만, 일단 배포까지 목표로 한 이상 혼자서라도 해내야 했고, 수많은 에러들을 거치며 앱 스토어에 올라갈 수 있게 되었습니다. 혼자라서 어려웠고, 혼자라서 편했던 점도 있었지만 어느 과정에서든 배움은 있을 수 밖에 없기에 좋은 경험이었다고 생각합니다. 무엇보다 앱 스토어에 저의 앱이 게시된 날, 너무 뿌듯했고, 제가 오래전부터 막연하게 꿈꿔오던 걸 이뤘다고 생각하니 큰 성취감을 느낄 수 있었습니다. 작지만 큰 목표를 이루었고, 또 다음 목표를 이룰 수 있다는 용기를 얻었던 것 같았습니다.

---
## **단순한 앱 제작이 아닌 실제 배포를 통하여 배운 점**

실제 배포를 해서 너무 기뻣지만, 한편으로 내가 만든 서비스가 전세계 사람들에게 공유된다고 생각하니 적지 않은 부담감 또한 있었던 것 같습니다. 제가 가장 먼저 할 수 있는 건 주변 사람들의 피드백을 받고 앱을 수정하고 보완해 나가는 일이었기 때문에 친구들과 가족들에게 앱에 대해 평가를 요청하고 의견을 수렴해 꾸준히 업데이트를 진행할 예정입니다.

----
## 🛠 업데이트

### 1차 업데이트 (2022.04.22)

- 설정 페이지 (알림 설정 / 다크모드) 추가

### 2차 업데이트 (2022.06.06)

- 버그 수정 (MVVM 아키텍처 적용)

### 3차 업데이트 (2022.06.19)

- RxSwift 적용
- UITest 적용

### 4차 업데이트 (2022.09.06)

- 일시정지 기능 추가
- SnapKit / Then 라이브러리 적용
    

---
## 📱 Screen

### **Light theme**
<img width="1847" alt="screen2" src="https://user-images.githubusercontent.com/95845594/188556576-802f5e12-3f80-4c72-bca2-7510db88f9d0.png">

### **Dark theme**
<img width="1449" alt="screen3" src="https://user-images.githubusercontent.com/95845594/188556013-15e12fd6-6444-4b58-a7af-97bd2fa03fa2.png">
