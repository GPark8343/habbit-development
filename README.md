지금 해야 할 거: story detail screen 만들고 sqlite에서 데이터 삭제하는 거 알아보고 
-> https://dev-nam.tistory.com/3
firebase에다가 연결도 해서 게시판 스크린 만들자
달력도 좀 기능 추가하자(날짜 선택해서 시작 도장 찍기)
또 profile 기능도 만들자
다른 구글 계정으로 로그인 해도 리포지토리는 그대로 유지 -> 방안 마련해야 함
썸네일 수정 시 게시물에는 안 바뀜
한 번만 유저 등록(로그인 시 )

이미지 에러 -> 지금 문제는 모든 이미지가 네트워크 안 됨-> 해결


insta screen 계속 똑같은 사진 업데이트되는 거 걍 놨둘까 아님 stream builder할까 고민되네 바꾸자 걍

지금 할 거: insta screen, image_frame, avatar_widget, post와 story 모델 이용해서 게시판 만들고 firebase에 데이터 형식 맞춰서 가즈아 -> sqlite 문제 해결(app 다시 빌드하면 sqlite 데이터 다 사라짐)-> 프로필 채우기-> 달력 도장 찍기 

스토리 지울 때 이것도 같이 해주자 (storage 최적화)
_deleteFile(File file, String filename) {

  }

나중에 할 꺼: 달력 도장 기능 insta screen stream builder로 바꾸기, 디자인 바꾸기, update 기능 만들기, 하루에 한 개만 올릴 수 있게 하기

post에 userinfo 없애고 프로필 편집 가능하게 하기 
storage 데이터 안 쓰는 거를 삭제하지 말고 하루에 한 번 프로필 변경 가능하게 하자

  void _saveStory() {
      if (_titleController.text.isEmpty ||
          _pickedImage == null ||
          _descriptionController.text.isEmpty) {
               Navigator.of(context).pop(); => 빈 스토리는 작성 못하게 해야 함
        return;
      }






.addFolders(
                                      'Title', 'Description', 'Category');
                                      자동으로 바꾸게

배포 시 구글광고 테스트모드 끝나면   admobBannerId = "ca-app-pub-3940256099942544/6300978111"; 이거 admob에 있는 거로 바꾸기+         // AdWidget(ad: banner!) 이거 풀기


지금 하고 있는 건 카테고리 저장 후 스토리 업로드하기 카테고리 보이게 하고 ;
몇일 차인지 표시 + 폴더 파일 시스템 만들기(story처럼 folder 생성 버튼과 스크린 서로 교체)


  void plusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days + 1,
    );/
  }
  void minusOneDay(Folder findedFolder) {
    Folder updatedFolder = findedFolder.copyWith(
      days: findedFolder.days - 1,
    );/
  }
  이거 db에서 업데이트하게 하기
  db_helper활용

달력 도장 기능,  update 기능 만들기, 하루에 한 개만 올릴 수 있게 하기, 리워드 지급하기(60일 간격으로), folder에서 스토리 자동으로 포스트 업로드 온오프 기능 만들기, 디자인 바꾸기(안녕 나는 습관 조교 해빗이야 얼마 안 남았어 좀만 힘내 거기서 포기할거야 우리 할머니가 그거보다 빠르겠다 잘했다 증표를 줄게 60일이 지났다고 안심해선 안 돼 끝까지 가자 드디어 올리는 구나 하루를 건너뛰었어 하지만 한 번만 찬스를 줄게 어허 포기했구나 다른 사람의 게시물을 봐봐 다시 시작해보는 건 어때?)

화면 팝아웃할 때 스크린 다시 렌더링해서 정보 다시 불러오기

    int allDifferenceTypeOfDay =
        365 * yearDifference + 30 * monthDifference + dayDifference;
        //몇 월이냐에 따라 일수가 다를 수 있음 이거 고쳐애 함


{지금 고민인게 days는 그냥 폴더 만든 날짜로부터 몇일이냐고 체크 됐는지 안 됐는지 확인할 방법이 필요
+
폴더에 따라 도장 달라야 함}
이거 내일 하기

{Text('folder를 먼저 추가해주세요') error 발견
marker 디자인 바꾸기
addmarker 이상하게 됨 folder랑 story 전부 다 삭제하고 다시 test
리워드 지급}

{Text('folder를 먼저 추가해주세요') error 발견
marker 디자인 바꾸기
addmarker 이상하게 됨 folder랑 story 전부 다 삭제하고 다시 test,
60일 연속으로 할 껀지 아님 그냥 60개 올리는 건지 훈장 구분, 레벨업 시스템 마련,
배포하기 전에 쓸 데 없는 디자인 빼기}


빈칸으로 제출하면 안된다고 경고문 주기

MediaQuery.of(context).size.height=752px
MediaQuery.of(context).size.width=360px

만약에 디바이스 바뀌면 어케 하냐
로컬 db에 있는 정보 다 날라가고 구글 계정에 올라간 포스트만 남음 이게 문제네
60일 채우면 firebase에 전부 업로드 자동 저장
