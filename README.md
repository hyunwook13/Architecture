
# Architecture
아키텍쳐를 공부하기 위한 레포지토리입니다.
## 내가 생각하는 아키텍쳐를 사용하는 이유

> 아키텍쳐의 목표는 시스템이 잘 동작하도록 하는 것이 아니다
> 주된 목표는 시스템의 생명 주기를 지원하는 것이다
> Clean-Architecture 15장

개발은 혼자 하는 일이 아니라 **여러 명이 함께 만드는 협업 작업**이다. 이때 코드는 단순히 동작만 하면 되는 것이 아니라, **누구나 쉽게 읽고, 수정하고, 확장할 수 있는 형태**여야 한다.

  

물론, 보기 좋은 코드라는 점에서는 **Lint나 코드 스타일 가이드** 같은 툴이 더 직접적일 수 있다. 그러나 **아키텍처는 더 깊은 차원**에서 작동한다.

  

내가 아키텍처를 중요하게 생각하는 이유는 다음과 같다:

-   새로운 기능이 추가되거나 수정이 필요할 때,
    
-   기존 코드를 **최소한으로 변경**하고도,
    
-   **안전하게 유지보수**할 수 있도록 해주는 구조이기 때문이다.
    

  

이 목표를 이루기 위해선 단순히 코드가 어디 있는지가 아니라,

**코드가 어떻게 흘러가고**, **어떤 책임을 갖고 있으며**,

**어떻게 확장될 수 있도록 설계되었는지**를 고민해야 한다.

  

즉, 아키텍처는 **시간과 효율을 지키는 개발자들의 전략**이다.

나는 이 전략을 내 것으로 만들기 위해, 직접 구현하고 비교하며 공부하고자 한다.

## 좋은 아키텍쳐란? 

> **좋은 아키텍처란,**  
> 테스트가 편리하고, 읽거나 파악하기 쉬우며,  
> 수정이 필요한 위치가 명확하게 드러나는 구조다.

### 내가 중요하게 생각하는 기준 3가지

#### 1. 변경 위치가 명확해야 한다
- 기능을 수정하거나 버그를 고칠 때,  **어느 부분을 수정해야 하는지 즉시 파악할 수 있는 구조**가 중요하다.
- 이는 곧 기능 단위와 책임 단위로 코드가 **명확히 분리되어 있어야 함**을 의미한다.

#### 2. 테스트가 쉬워야 한다
- 코드를 신뢰하기 위한 가장 확실한 수단은 테스트다.
- **관심사의 분리(SoC)** 를 통해 책임을 나누고,  **의존성을 분리함으로써** 원하는 부분만 선택적으로 테스트할 수 있는 구조가 필요하다.

#### 3. 흐름이 예측 가능해야 한다
- 다른 개발자가 코드를 처음 보더라도,  **기능이 어디서 어떤 방식으로 처리되는지** 예측할 수 있어야 한다.
- 이는 곧 일관된 네이밍, 명확한 디렉터리 구조, 역할 기반 설계에서 비롯된다.


### 전문가가 정의한 좋은 아키텍처의 기준 _(Uncle Bob / AI 요약)_

- **변경에 강하다**: 기능 추가나 수정이 전체 코드에 큰 영향을 주지 않는다  
- **책임이 분리되어 있다**: 각 컴포넌트는 하나의 역할만 수행한다  
- **테스트 가능하다**: UI나 외부 환경에 종속되지 않은 핵심 로직  
- **읽기 쉽고 예측 가능하다**: 구조, 흐름, 네이밍이 직관적이다  
- **확장하기 쉽다**: 기능이 늘어나도 구조가 쉽게 무너지지 않는다

이러한 기준을 바탕으로 앞으로의 프로젝트에 적용하고,  

직접 실험하며 나만의 실천 원칙으로 다듬어갈 계획이다.

---

> 좋은 아키텍처란, **핵심 비즈니스 규칙이 UI, DB, 프레임워크에 의존하지 않고 존재**할 수 있도록 만드는 것이다. - Uncle Bob


## MVC
### 일반적인 MVC 구조
![](https://camo.githubusercontent.com/663229d7d1577ed7c24eef04a902a723770eb75438d5d697a0db7d29dc71ea0e/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f323030302f312a45394135664f7253723079566d63374b6c79354336412e706e67)
MVC
* Model
* View
* Controller


View -> Controller -> Model -> Noti to View -> Get Data from Model

### 장점

| 항목               | 설명 |
|--------------------|------|
| 역할 분리의 시작점 | Model, View, Controller의 책임을 나누는 첫 구조로 개념적 이해가 쉬움 |
| 빠른 개발 가능     | View와 Controller가 직접 연결되어 있어 작은 프로젝트에선 빠른 UI 반응 구현 가능 |
| 단순한 구조에 적합 | 복잡한 설계 없이 기능 구현 중심의 앱을 빠르게 만들기 유리 |
| 초기 학습 부담 적음 | 아키텍처 초입에서 접근하기 쉬운 구조 (코드 흐름이 눈에 보임) |


### 단점

| 항목                   | 설명 |
|------------------------|------|
| **양방향 의존성**       | Model, View, Controller가 서로 참조하면서 **강결합** 구조로 변질되기 쉬움 |
| **유지보수 어려움**     | 하나의 변경이 다른 모든 컴포넌트에 영향을 줄 수 있음|
| **테스트 어려움**       | 각 컴포넌트가 서로 연결되어 있어 단위 테스트 작성이 어려움 |
| **디버깅 복잡도 증가**  | 상태 변화의 흐름이 복잡하게 얽혀 있어 버그 추적이 힘들어짐 |
| **규모 확장 어려움**    | 구조가 커지면 모듈 간 책임이 흐려지고 유지 비용이 증가함 |

---
MVC 각각의 요소가 강하게 의존하고 있어 독립성이 좋지 않다. 
애플은 이를 해결하기 위한 자체의 MVC를 제시한다.
또한 빠른 앱 개발과 간단한 구조를 제공하기 위해 `UIViewController`를 중심으로 한 Apple MVC를 도입했다.


### Apple MVC
![](https://camo.githubusercontent.com/9104b26b403abd0bd2bfedad49d85e170f9f6d3af294de1a92da0c27aab3386d/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313230302f312a6330614761444e583431717536653845344f456777512e706e67)

사용자 입력 -> View -> (send action) Controller -> Model -> Controller -> View Update 순으로 진행된다.

View와 Controller를 분리시켜 독립성을 높히려던 의도와 다르게 실제 아키텍쳐는 아래와 같은 다이어그램과 같이 흐름을 갖게 되었다.


### 실제 Apple MVC 다이어그램
![](https://camo.githubusercontent.com/cd5847debf1f3d932c42971b52c6e860aecb1364f8a25367cbb909fbb12cd81d/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a506b576a4455306a71474a4f42393732634d73726e412e706e67)


###  장점

| 항목                | 설명 |
|---------------------|------|
| 빠른 생산성         | `UIViewController` 하나로 UI와 로직을 빠르게 구현 가능 |
| 학습 용이성         | iOS 입문자가 쉽게 사용할 수 있는 구조 |
| Apple API 최적화    | IBOutlet, IBAction, Target-Action 구조와 자연스럽게 호환 |
| 자료 접근성         | 공식 문서, 튜토리얼, 커뮤니티 예제가 풍부함 |
| 소규모 앱에 적합    | 구조가 단순하므로 MVP나 프로토타이핑에 유리 |

###  단점

| 항목                | 설명 |
|---------------------|------|
| ViewController 비대화 | UI, 이벤트, 로직, 네트워크까지 모두 한 클래스에 집중됨 |
| 테스트 어려움       | 로직과 UI가 결합되어 단위 테스트 작성이 어려움 |
| 재사용성 낮음       | ViewController가 너무 많은 걸 알아서 다른 곳에 재사용 어려움 |
| 확장성 부족         | 앱이 커질수록 유지보수가 급격히 어려워짐 |
| 책임 분리 불명확    | SRP(Single Responsibility Principle)를 어기기 쉬움 |

### 정리 

Apple의 MVC는 View와 Controller를 사실상 UIViewController에 통합한 구조로,

**작고 단순한 앱에서는 적은 학습 비용으로 빠르게 개발할 수 있어 초기 생산성이 높다.**

  

하지만 이 구조는 **View와 Controller 간 독립성이 낮고**,

UIViewController가 **UI 렌더링, 사용자 입력 처리, Model 조작, 네트워크 요청**까지 모두 떠맡게 되면서

**재사용성, 테스트 효율, 유지보수성 측면에서 한계를 드러낸다.**

  

결과적으로 프로젝트 규모가 커질수록

**ViewController 하나에 수백~수천 줄의 코드가 몰리는 Massive ViewController 현상**이 발생하고,

앱 전체의 구조적 생산성도 급격히 저하된다.

## MVP 
![](https://camo.githubusercontent.com/808f617f783a055a48d4f57a224d0765d21bcb271edbd011e2dfcd0d35fc5734/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a684b5543504548673654447a3667744f6c6e465977512e706e67)
MVP
* Model
* View
* Presenter


**MVC에서는 ViewController가 View와 Controller 역할을 동시에 맡아 비대해지고, 테스트와 유지보수가 어려워진 문제를 해결하기 위해 제시된 아키텍쳐**

UI 로직과 비즈니스 로직을 명확히 분리하려고,

**Presenter가 View와 Model 사이를 조정하고 View는 dumb하게 유지하는 MVP가 등장함.**


### 장점

| 항목                | 설명 |
|---------------------|------|
| 책임 분리           | View와 Presenter가 명확히 분리되어 역할이 깔끔함 |
| 테스트 용이성       | Presenter는 View에 의존하지 않고 interface로만 연결되어 단위 테스트에 적합 |
| 유지보수 편리성     | UI 로직과 비즈니스 로직이 분리되어 수정 시 영향 범위가 작음 |
| UI 로직 재사용성    | Presenter는 플랫폼에 독립적이라 여러 View에서 재사용 가능 |
| 구조적 일관성       | View는 dumb하게, Presenter가 주도적으로 로직을 처리하는 구조로 통일감 있음 |

### 단점

| 항목                | 설명 |
|---------------------|------|
| 초기 구조 설계 부담 | Interface 설계와 역할 분리에 시간과 고민이 필요함 |
| 작은 화면에도 과함  | 단순한 화면에 Presenter까지 두면 오히려 복잡해짐 |
| Presenter 비대화    | UI 로직과 비즈니스 로직이 섞이며 Presenter가 또다시 비대해질 수 있음 |
| View와의 연결 번거로움 | View 인터페이스를 일일이 구현해야 하므로 반복 코드가 많아짐 |
| 데이터 바인딩 부재   | MVVM과 달리 양방향 데이터 바인딩이 없어 UI 업데이트를 수동 처리해야 함 |

### 정리 
UI 로직은 Presenter로 분리하고, View는 Interface를 통해 Presenter에 이벤트만 전달함으로써

**책임을 명확히 분리하고 테스트 가능성을 높이는 구조적 대안을 제공한다.**

  

다만, MVP는 View를 추상화하기 위한 **interface 설계와 수동 연결 작업이 필요**해

**작은 화면이나 단순한 기능에도 오버헤드가 발생할 수 있다는 단점**
View와 Presenter가 1:1 대응해야만 하는 단점이 존재

## MVVM 
![enter image description here](https://learn.microsoft.com/ko-kr/dotnet/architecture/maui/media/mvvm-pattern.png)
MVVM
* View
* Model
* ViewModel

MVP는 Controller의 비대화를 해결했지만, **UI 상태 관리와 반복적인 연결 코드의 부담**을 해결하지 못했다.

MVVM은 **상태 중심 설계와 바인딩 구조**로 이러한 문제를 근본적으로 줄이기 위해 등장했다.


### 장점

| 항목               | 설명 |
|--------------------|------|
| UI와 로직의 철저한 분리 | View는 상태를 보여주고, ViewModel은 로직과 상태를 관리함 |
| 테스트 용이성        | ViewModel은 UI에 의존하지 않기 때문에 단위 테스트가 쉬움 |
| 상태 기반 설계       | 이벤트가 아닌 상태로 UI를 구성할 수 있어 선언적 UI 설계에 유리 |
| 선언형 UI와 궁합 좋음 | SwiftUI, Jetpack Compose 등과 잘 어울림 |
| 재사용성            | ViewModel은 여러 View에서 재사용 가능 (로직 재활용 가능) |


### 단점

| 항목               | 설명 |
|--------------------|------|
| 초기 설계 복잡성     | 상태, 입력, 출력 등을 어디까지 ViewModel에 넣을지 경계가 모호할 수 있음 |
| ViewModel 비대화 위험 | ViewModel이 모든 상태를 품다 보면 다시 비대해질 가능성이 있음 |
| 바인딩 비용          | UIKit 등 바인딩 자동화가 없는 환경에선 수동 구현 필요 (Rx/Combine 없으면 번거로움) |
| 과도한 추상화        | 지나치게 구조화하려다 오히려 코드가 복잡하고 추적하기 어려워질 수 있음 |

### 정리
MVVM은 MVP의 **반복적이고 수동적인 View 연결**과 Presenter가 직접 View를 조작하던 구조를

상태 중심으로 전환해, ViewModel은 “상태만” 책임지고 View는 바인딩으로 반응하게 함으로써

Presenter의 비대화 문제를 구조적으로 해결했다.

허나 여전히 ViewModel 자체가 비대해질 수 있다는 문제가 존재한다.
## VIPER
![](https://ckl-website-static.s3.amazonaws.com/wp-content/uploads/2016/04/Viper-Module.png.webp)
VIPER
* View
* Interactor
* Presenter
* Entity
* Router

기존에 존재하던 ViewModel, Controller, Presenter의 역할을 더 잘게 쪼개놓은 아키텍쳐, 클린 아키텍쳐의 계층 원칙을 iOS 식으로 번역한 형태

View는 화면을 표현, Presenter는 화면에서 필요한 처리를 맡아서 관리, 
화면에서 화면 전환이 필요하다면 Router, 비즈니스 로직이 필요하다면 Interactor를 호출하고, Interacter는 Entity를 호출하여 데이터를 업데이트함
### 장점 
| 항목 | 설명 |
|-----------|------|
| **역할 분리 (SRP)** | View, Presenter, Interactor 등의 책임이 명확하게 분리되어 유지보수가 쉬움 |
| **테스트 용이성** | Presenter, Interactor는 View에 의존하지 않기 때문에 단위 테스트가 쉽고 안정적임 |
| **모듈화와 재사용성** | 기능 단위로 구조화되어 각각의 모듈을 재사용하거나 확장하기 용이함 |
| **Clean Architecture 적용 가능** | VIPER는 클린 아키텍처 원칙을 실현하기 쉬운 구조를 제공함 |
| **라우팅 책임 분리** | 화면 전환(Router)을 따로 분리하여 ViewController가 간결해짐 |
### 단점 
| 항목 | 설명 |
|-----------|------|
| **구조 복잡도** | 하나의 기능(화면)마다 5개 이상의 파일이 필요해 오히려 복잡해짐 |
| **보일러플레이트 코드 증가** | 프로토콜, 클래스, 연결 코드 등 반복적인 코드가 많아짐 |
| **초기 진입장벽** | 구조와 연결 관계를 처음부터 이해하고 설정하기 어려움 |
| **오버엔지니어링 우려** | 간단한 기능에도 과하게 나누면 개발 속도가 떨어짐 |
| **유연성 부족** | 모든 계층이 정형화되어 있어, 빠르게 프로토타입을 만들기 어려움 |

### 정리 
기존에 있던 패턴들에서 존재하던 문제점을 Router를 통해 비교적 더 줄일 수 있었다 
허나 당연히 하나의 존재에서 한번에 수행하던 기능들을 쪼개니, 파일과 코드 수가 더욱 많아진다는 단점이 존재한다.
 
## Clean-Architecture
![](https://blog.kakaocdn.net/dna/m5RA5/btqFJq0t1fp/AAAAAAAAAAAAAAAAAAAAAAZoB_p3HXOJZHDau7lZMGJYpDbdECRBJDDRqSHWRi7H/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1753973999&allow_ip=&allow_referer=&signature=hw7PCy652K%2BVoEH%2FRedCOR%2BV294%3D)
- 도메인 중심 아키텍처 (Domain-Centric Architecture)
- 계층마다 책임 분리:
    - UI / Presentation
    - Interface Adapter (Controller, Presenter, Gateway)
    - Application Business Rule (UseCase)
    - Enterprise Business Rule (Entity)

안쪽 계층에서는 외부의 계층이 모르도록, 뿐만 아니라 영향을 받지 않도록 설계를 하는 아키텍쳐 ( 의존성 방향이 안쪽으로 )

각 계층에서는 한 계층 위까지만 정보를 알 수 있음
ex) 프레임워크와 드라이버 계층에 속하는 DB는 그 계층의 위인 인터페이스 적용 계층(초록색)까지만 알 수 있음

만약 내부 계층에서 외부 계층을 호출해야한다면 (그냥 호출 하면 안됨)
![](https://blog.kakaocdn.net/dna/0O3SF/btqFMHzuzRV/AAAAAAAAAAAAAAAAAAAAAKlZ1ixUgBoW-smjDFkHXlvxMJKoISOQQyz42SSPToCv/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1753973999&allow_ip=&allow_referer=&signature=Me4yQ%2Bi3Zlw3DrVX5RHpVLLry8g%3D)
위 이미지처럼 Output Port 인터페이스를 만들어 해결

### 장단점
* VIPER와 유사하지만 아래와 같은 차이점이 존재  

| 항목 | VIPER | Clean Architecture |
|-----------|------|-----|
|구조 고정 | View/Interactor/Presenter 등 고정 | 유동적 계층 조합 가능 |
| 적용 범위 | 화면 중심 | 도메인 중심 |
| 라우팅 방식 | Router 고정 포함 | 선택적 (필요 시만) |
| 의존 방향 | 일부 양방향 존재 | 항상 안쪽으로만 의존 |
| 확장성 | 낮음 | 높음 |
| 추상화 수준 | 낮음 (구현이 많음) | 높음 (의존성 역전 강조) |

### 정리
 Clean Architecture는 **중·대형 규모 앱**, **도메인 로직 중심의 서비스**, **테스트가 중요한 서비스**에서 빛을 발함.
작고 단순한 프로젝트에서는 오히려 **불필요한 복잡성**을 초래할 수 있으므로, **"상황에 맞게 유연하게"** 적용하는 게 핵심.
## RIBs
RIBs
* Router
* Interacter
* Builder

### **도메인 중심 아키텍처 (Domain-Centric Architecture)**

 

RIBs는 **도메인 중심 아키텍처**에 가깝다.

한 화면(View)이 아니라 **도메인 단위로 RIB을 구성**하기 때문에,

기능 중심으로 코드를 모듈화하고 **복잡한 상태 관리와 유즈케이스**를 분리하기 용이하다.

### **계층마다 책임 분리**


| Clean Architecture 계층 | RIBs 매핑 | 설명 |
|-------------------------|------------|------|
| **UI / Presentation**   | ViewController, Presentable | 유저 인터페이스와 직접 연결된 부분. 험블 객체로 간주됨. |
| **Interface Adapter**   | Presenter (Protocol), Router | 뷰와 비즈니스 로직 연결, 화면 전환 등 외부와의 어댑터 역할 |
| **Application Business Rule (UseCase)** | Interactor | 유즈케이스의 핵심. 앱 로직 담당 |
| **Enterprise Business Rule (Entity)** | Entity (별도 구조화 가능) | 비즈니스 핵심 모델. RIBs 자체에선 강제하진 않음 |



## **✅ 장단점**
| 항목 | VIPER | RIBs (Clean Arch 기반) |
|-----------|--------|---------------------|
| **구조 고정** | View/Interactor/Presenter 등 고정 | RIB (Router, Interactor, Builder) 중심 |
| **적용 범위** | 화면 중심 | 도메인 중심 (한 RIB = 하나의 도메인) |
| **라우팅 방식** | Router 포함 | Router 강제 + Attach/Detach 명시적 |
| **의존 방향** | 일부 양방향 존재 | 항상 안쪽(Interactor)으로만 의존 |
| **확장성** | 낮음 | 매우 높음 (독립적 모듈화 가능) |
| **추상화 수준** | 낮음 | 높음 (의존성 역전, 인터페이스 기반) |

## **정리**

  

RIBs는 **도메인 중심 아키텍처를 기반으로 설계된 구조**이며,

특히 다음 조건에서 강력한 장점을 가진다:

-   **중·대형 앱 구조**
    
-   **다수의 독립된 도메인 (ex: 피드, 채팅, 설정)**
    
-   **테스트 가능한 구조가 필요한 상황**
    
-   **상태 관리, 라우팅 흐름이 복잡한 앱**
    

  

반대로, 작은 앱이나 MVP급 서비스에서는

**불필요한 추상화와 구조적 복잡성**을 초래할 수 있으므로

**“필요할 때 선택적으로 적용”** 하는 게 핵심이다.

## TCA


