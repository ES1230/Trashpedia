INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '관리자');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '씨앗');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '새싹');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '줄기');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '나무');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '열매');
INSERT INTO USER_GRADE VALUES(SEQ_UGNO.NEXTVAL, '숲');

INSERT INTO BIG_CATEGORY VALUES (SEQ_BCNO.NEXTVAL,'커뮤니티');
INSERT INTO BIG_CATEGORY VALUES (SEQ_BCNO.NEXTVAL,'실천하기');
INSERT INTO BIG_CATEGORY VALUES (SEQ_BCNO.NEXTVAL,'정보자료글');

INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,1,'공지게시판');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,1,'일반게시판');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,1,'건의게시판');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,1,'무료나눔게시판');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,2,'실천서약');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,2,'실천인증');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,3,'홍보교육자료');
INSERT INTO SUB_CATEGORY VALUES (SEQ_SCNO.NEXTVAL,3,'제도교육자료');

INSERT INTO TRASH_BIG_CATEGORY VALUES(SEQ_TBCNO.NEXTVAL, '일반쓰레기');
INSERT INTO TRASH_BIG_CATEGORY VALUES(SEQ_TBCNO.NEXTVAL, '음식물쓰레기');
INSERT INTO TRASH_BIG_CATEGORY VALUES(SEQ_TBCNO.NEXTVAL, '대형폐기물');

INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '종이');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '종이팩');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '캔');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '고철');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '비닐');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '유리');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '플라스틱');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '스티로폼');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '필름');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 1, '의류');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '채소');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '과일');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '곡류');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '육류');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '어패류');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '동물의 알');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 2, '기타');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 3, '가구');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 3, '생활용품');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 3, '소형가전');
INSERT INTO TRASH_SUB_CATEGORY VALUES(SEQ_TSCNO.NEXTVAL, 3, '대형가전');

INSERT INTO MEMBER
VALUES (SEQ_MNO.NEXTVAL, 'ADMIN', DEFAULT, 'admin@trashpedia.com', '$2a$10$LG0fKxpMYW3j5HqyGV09/esLgkwg9KZc7/roae/ulqXR9Ow9pMNfO',
'관리자',
'관리자',
'010-1111-2222',
NULL,
NULL,
NULL,
NULL,
SYSDATE,
NULL,
'Y'
);
        
COMMIT;