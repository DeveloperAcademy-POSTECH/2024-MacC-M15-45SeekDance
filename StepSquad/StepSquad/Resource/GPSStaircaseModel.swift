//
//  StaircaseModel.swift
//  StepSquad
//
//  Created by Groo on 2/20/25.
//

import Foundation

enum KoreanProvince: String, Codable {
    case gangwon = "강원"
    case gyeonggi = "수도권"
    case gyeongnam = "부산/울산/경남"
    case gyeongbuk = "대구/경북"
    case jeonnam = "광주/전남"
    case jeonbuk = "전북"
    case jeju = "제주"
    case chungnam = "대전/충남"
    case chungbuk = "충북"
}

class GPSStaircase: Codable, Identifiable {
    let id: String // 영문명 TODO: 계단 이미지도 id와 동일하게 설정
    let name: String // 계단명
    let title: String // 계단의 부제
    let description: String // 설명
    let province: KoreanProvince // 해당 지역
    let steps: Int // 계단 개수
    let latitude: Double // 위도
    let longitude: Double // 경도
    let verificationLocation: String // 인증 위치 TODO: 인증 위치 파일명은 "[id]_location"
    let reward: String // 획득 재료 TODO: 리워드 이미지 파일명은 "[id]_reward"로 설정
    let achievementId: String // id의 맨 앞글자를 소문자로 만듬
    
    init(id: String, name: String, title: String, description: String, province: KoreanProvince, steps: Int, gpsLocation: (latitude: Double, longitude: Double), verificationLocation: String, reward: String) {
        self.id = id
        self.name = name
        self.title = title
        self.description = description
        self.province = province
        self.steps = steps
        self.latitude = gpsLocation.latitude
        self.longitude = gpsLocation.longitude
        self.verificationLocation = verificationLocation
        self.reward = reward
        self.achievementId = id.prefix(1).lowercased() + id.suffix(id.count - 1)
    }
}

let gpsStaircases: [GPSStaircase] = [
    GPSStaircase( // TODO: 추후 삭제
        id: "Test1",
        name: "초량 이바구길 168 계단",
        title: "역사가 오래된 초량의 이바구 길",
        description: "이바구길을 이바구를 떨며 걸어올라가 볼까나?",
        province: .gyeongnam,
        steps: 168,
        gpsLocation: (35.117143, 129.035298),
        verificationLocation: "인증 장소 예시",
        reward: "국밥 육수"),
    GPSStaircase(
        id: "Busan168",
        name: "초량 이바구길 168 계단",
        title: "이바구 떨며 오르세요",
        description: "부산의 경사로를 몸소 느껴보자",
        province: .gyeongnam,
        steps: 168,
        gpsLocation: (35.117143, 129.035298),
        verificationLocation: "계단 아래 지점",
        reward: "국밥 육수"),
    GPSStaircase(
        id: "Busan40",
        name: "부산 40 계단",
        title: "피난민의 역사가 깃든",
        description: "원조 만남의 광장",
        province: .gyeongnam,
        steps: 40,
        gpsLocation: (35.103911, 129.034629),
        verificationLocation: "조각상 앞",
        reward: "다대기"),
    GPSStaircase(
        id: "GacheonVillage",
        name: "남해군 가천마을 다랑이논",
        title: "남해가 한 눈에 들어오는",
        description: "계단식 논도 계단이라고 일단 정했어요",
        province: .gyeongnam,
        steps: 108,
        gpsLocation: (34.726835, 127.896276),
        verificationLocation: "다랭이마을 전망대",
        reward: "통통한 멸치"),
    GPSStaircase(
        id: "JehwangMountain",
        name: "진해 제황산 1년 계단",
        title: "모노레일 이용객, 기선제압하자!",
        description: "모노레일 말고 계단을 이용해서 나의 기세를 보여주자",
        province: .gyeongnam,
        steps: 365,
        gpsLocation: (35.149216, 128.661541),
        verificationLocation: "모노레일 옆 계단 입구",
        reward: "버찌"),
    GPSStaircase(
        id: "SogeumMountain",
        name: "원주 소금산 출렁다리 578 계단",
        title: "출렁다리로 가기 위한 관문",
        description: "출렁다리 건너기전에 건너야만 해요",
        province: .gangwon,
        steps: 578,
        gpsLocation: (37.367791, 127.825207),
        verificationLocation: "1-2 매표소",
        reward: "십년(된) 감수"),
    GPSStaircase(
        id: "Ojukheon",
        name: "강릉 오죽헌 계단",
        title: "심사임당과 율곡이이의 홈 스윗 홈",
        description: "심사임당과 율곡이이의 고향이라던대?",
        province: .gangwon,
        steps: 17,
        gpsLocation: (37.779131, 128.879658),
        verificationLocation: "매표소",
        reward: "5만 5천원"),
    GPSStaircase(
        id: "HwaamCave",
        name: "정선 화암동굴 365 계단",
        title: "걸어서 동굴 속으로",
        description: "동굴로 가보자",
        province: .gangwon,
        steps: 365,
        gpsLocation: (37.351108, 128.79053),
        verificationLocation: "매표소",
        reward: "곤드레"),
    GPSStaircase(
        id: "Gatbawi",
        name: "팔공산 갓바위 1365 계단",
        title: "소원을 이뤄주는",
        description: "건강도 챙기고 소원도 빌어보세요!",
        province: .gyeongbuk,
        steps: 1365,
        gpsLocation: (35.977617, 128.733097),
        verificationLocation: "관암사 계단 입구",
        reward: "갓바위 돌가루"),
    GPSStaircase(
        id: "31HeritageTrail",
        name: "3.1만세 운동길 계단",
        title: "대한 독립 만세!",
        description: "3.1운동의 역사가 깃들어 있는 멋진 계단",
        province: .gyeongbuk,
        steps: 90,
        gpsLocation: (35.867500, 128.586135),
        verificationLocation: "", // TODO: 수정 필요
        reward: "태극기"),
    GPSStaircase(
        id: "SpaceWalk",
        name: "포항 스페이스 워크",
        title: "쫄보력 테스트를 해보세요",
        description: "바다가 한눈에 보이는 스페이스 워크!",
        province: .gyeongbuk,
        steps: 717,
        gpsLocation: (36.065128, 129.390362),
        verificationLocation: "계단 바로 앞",
        reward: "포항산 철분"),
    GPSStaircase(
        id: "Cheongungyo-Baegungyo",
        name: "불국사 계단",
        title: "여기는 오르지 말고 구경만!",
        description: "아주 높으신 분들만 걸을 수 있는 계단이라네. 우리는 다른 계단으로 걷자.",
        province: .gyeongbuk,
        steps: 34,
        gpsLocation: (35.789713, 129.332154),
        verificationLocation: "계단 아래 지점",
        reward: "해탈"),
    GPSStaircase(
        id: "Postech78",
        name: "포항공대 78계단",
        title: "모든 것이 시작된 곳",
        description: "계단사랑단은 여기서 시작되었어요",
        province: .gyeongbuk,
        steps: 78,
        gpsLocation: (36.01481, 129.321583),
        verificationLocation: "계단 중앙 지점",
        reward: "노벨 제발(please)상"),
    GPSStaircase(
        id: "PostechLibrary",
        name: "포항공대 창업자의 길 계단",
        title: "창업자가 되고 싶다면!",
        description: "계단사랑단은 여기서도 시작하려고 했어요",
        province: .gyeongbuk,
        steps: 0, // TODO: 수정 필요
        gpsLocation: (36.012276, 129.32505),
        verificationLocation: "계단 아래 지점",
        reward: "창업 계획서 양식.hwp"),
    GPSStaircase(
        id: "SeongsanIlchulbong",
        name: "성산일출봉",
        title: "일출이 아름다운",
        description: "제주도에 왔다면 성산 일출을 보러가자!",
        province: .jeju,
        steps: 976, // TODO: 수정 필요
        gpsLocation: (33.462336, 126.936886),
        verificationLocation: "매표소",
        reward: "한라봉"),
    GPSStaircase(
        id: "YeongjuMountain",
        name: "영주산 둘레길 천국의 계단",
        title: "천국의 계단이 있어요",
        description: "제주 여행 중 뭔가를 많이 먹었다면 필수로 방문하세요",
        province: .jeju,
        steps: 724,
        gpsLocation: (33.405684, 126.806024),
        verificationLocation: "입구 주차장",
        reward: "돌하르방"),
    GPSStaircase(
        id: "JeonilBuilding",
        name: "전일빌딩 245 계단",
        title: "한국 민주화운동의 흔적",
        description: "광주의 삶과 역사가 깃든, 245에 518의 진실 깃든 계단",
        province: .jeonnam,
        steps: 63,
        gpsLocation: (35.148407, 126.918694),
        verificationLocation: "", // TODO: 수정 필요
        reward: "무등산 수박"),
    GPSStaircase(
        id: "BalsanVillage",
        name: "청춘발산마을 벽화 108 계단",
        title: "뒤집은 밥그릇 모양의 마을",
        description: "오래된 동네를 예쁘게 꾸며 둔 계단 명소!",
        province: .jeonnam,
        steps: 108,
        gpsLocation: (35.159700, 126.891696),
        verificationLocation: "계단 입구",
        reward: "뒤집어 놓은 밥그릇"),
    GPSStaircase(
        id: "ChunhyangThemePark",
        name: "남원 춘향 테마 파크 계단",
        title: "에스컬레이터 말고 계단",
        description: "춘향이의 힘을 빌려 계단 사랑력을 뽐내보세요",
        province: .jeonnam,
        steps: 100,
        gpsLocation: (35.402639, 127.386723),
        verificationLocation: "계단 현판 앞",
        reward: "춘향골 사과"),
    GPSStaircase(
        id: "Yeonggwang365",
        name: "영광 365 계단",
        title: "1년 365일 건강하자!",
        description: "이 계단의 비밀 사실! 사실 365개가 아닙니다.",
        province: .jeonnam,
        steps: 365,
        gpsLocation: (35.361538, 126.394593),
        verificationLocation: "계단 현판 앞",
        reward: "굴비"),
    GPSStaircase(
        id: "SangdoStation",
        name: "7호선 상도역 앞 멍청한 계단",
        title: "기묘한 6칸짜리 계단",
        description: "목적을 알 수 없는 계단! 목적이 있을수도?",
        province: .gyeonggi,
        steps: 6,
        gpsLocation: (37.503328, 126.947441),
        verificationLocation: "2번 출구 밖",
        reward: "7호선 종이 티켓"),
    GPSStaircase(
        id: "NamsanPark",
        name: "남산 삼순이 계단",
        title: "90년대생까지는 다 아는",
        description: "방송에서 이 계단을 많이 본 나이라면, 무릎을 조심하세요.",
        province: .gyeonggi,
        steps: 61,
        gpsLocation: (37.554509, 126.981684),
        verificationLocation: "계단 아래 지점",
        reward: "양푼이비빔밥"),
    GPSStaircase(
        id: "EwhaCampusComplex ",
        name: "이화여대 ECC 계단",
        title: "이화여대 관광명소",
        description: "엘베 대신 계단을 이용해보며 건강한 대학생이 되어보자",
        province: .gyeonggi,
        steps: 180,
        gpsLocation: (37.561451, 126.946778),
        verificationLocation: "계단 중앙 지점",
        reward: "배꽃"),
    GPSStaircase(
        id: "PangyoFootbridge",
        name: "판교 뜬금없는 육교 계단",
        title: "판교 나폴리탄 괴담!?",
        description: "판교에는 육교가 아닌 육교가 있어요",
        province: .gyeonggi,
        steps: 42,
        gpsLocation: (37.398326, 127.10985),
        verificationLocation: "", // TODO: 수정 필요
        reward: "판교 사투리 사전"),
    GPSStaircase(
        id: "MuryangGongdeok",
        name: "천안 각원사 무량공덕계단",
        title: "동양 최대 청동좌불상!",
        description: "엄청난 규모의 불상과 엄청난 칸 수의 계단!",
        province: .chungnam,
        steps: 203,
        gpsLocation: (36.835126, 127.19683),
        verificationLocation: "불상 앞",
        reward: "호두"),
]
