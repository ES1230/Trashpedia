package com.kks.trashpedia.member.model.dao;

import java.util.List;

import com.kks.trashpedia.board.model.vo.Board;
import com.kks.trashpedia.board.model.vo.Comment;
import com.kks.trashpedia.board.model.vo.Post;
import com.kks.trashpedia.member.model.vo.Member;

public interface MemberDao {

	int emailCheck(String userEmail);

	int joinMember(Member m);

	Member loginMember(Member m);

	int updateMember(Member m);

	int deleteMember(Member m);

	int idCheck(String userEmail);
	
	// 마이페이지 게시글
	List<Board> pledgeList(int userNo);
	// 댓글

	List<Board> commentList(int userNo);

	String findEmail(String userName, String phone);

	int checkEmail(String userEmail, String phone);
}