#  주제 MODEL1 JSP 게시판 

## 구현 기능

- 게시글 CRUD (작성, 읽기, 수정, 삭제)
- 필터링 기능 (날짜, 검색어)
- 단일 파일 업로드, 다운로드, 삭제
- 댓글 작성 기능

## ERD
![Copy of eb_study_week1](https://github.com/proamateur92/eb-study-1week/assets/68406448/137282cd-7ad8-4bad-a5d7-2e5bf323f81b)

## 미구현 기능

- 다중 파일 업로드

		MultipartRequest라는 객체를 사용했는데, 단일 파일 업로드, 다운로드 기능만 제공한다고 합니다.
		Model1 패턴에서 다른 방법을 찾지 못해 구현하지 못했습니다.
  
- 수정 페이지에서 파일을 삭제하고 수정할 수 있는 기능
  
		파일의 삭제 버튼을 누르면 delete_flag를 Y로 바꿔주었습니다.
		수정 취소라면 delete_flag="N" 처리. 수정 확인이라면 delete_flag="Y"인 파일 삭제.
		추가 업로드 파일이 있다면 업로드 후 DB 저장 처리.

		그러나, 페이지를 종료하는 등 버튼을 클릭하지 않은 상황에서는 flag를 바꾸었다면 flag를 다시 바꿀 방법을 모르겠습니다.
		예를 들어, 수정 페이지에서 파일 삭제를 누르고 페이지를 종료. 수정 페이지에서 파일 업로드하고 확인을 누르지 않은 경우는 상관없음.
  
- transaction 미사용

		트랜잭션의 중요성은 알고 있고 이번에 프로젝트에서도 적용해야 할 필요성을 알고 있었습니다.
		예를 들어 글을 작성할 때 파일 첨부도 함께 한다면 게시글 id를 파일 테이블이 foreign key로 사용하므로 게시글 insert 작업이 우선시 되어야 합니다.
		그 이후 정상적으로 insert 되었다면 파일 정보도 파일 테이블에 insert해야 하는데 이때 에러가 난다면 전부 rollback 처리를 해야합니다.
		model1 패턴에서는 jsp페이지 하나로 mvc패턴을 모두 구현하기 때문에 애너테이션을 사용하지 않고 어떻게 트랜잭션을 구현해야 할지 모르겠습니다.



# 사전 준비

## JDK 11 설치

## Docker Desktop 설치
https://www.docker.com/products/docker-desktop/

## Apache Tomcat 설치
https://tomcat.apache.org/download-90.cgi

## Docker Compose 실행 - MySql
``` 
cd help
docker-compose up -d
```
