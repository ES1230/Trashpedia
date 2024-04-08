package com.kks.trashpedia.pledge.model.service;

import java.sql.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.kks.trashpedia.board.model.vo.Attachment;
import com.kks.trashpedia.board.model.vo.Board;
import com.kks.trashpedia.board.model.vo.Comment;
import com.kks.trashpedia.board.model.vo.ImgAttachment;
import com.kks.trashpedia.board.model.vo.Post;
import com.kks.trashpedia.board.model.vo.SubCategory;
import com.kks.trashpedia.member.model.dao.MemberDao;
import com.kks.trashpedia.member.model.vo.Member;
import com.kks.trashpedia.pledge.model.dao.PledgeDao;
import com.kks.trashpedia.pledge.model.vo.Signature;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PledgeServiceImpl implements PledgeService{
	
	private final PledgeDao dao;
	private final MemberDao memberDao;
	
	//게시글 보기
	@Override
	public List<Post> pledgeList(int subCategoryNo) {
		return dao.pledgeList(subCategoryNo);
	}

	//게시글 상세보기
	@Override
	public Post pledgeDetail(int postNo) {
		return dao.pledgeDetail(postNo);
	}
	//게시글 상세-첨부파일
	@Override
	public Attachment pledgeDetailAttach(int boardNo) {
		return dao.pledgeDetailAttach(boardNo);
	}
	//게시글 상세-이미지
	@Override
	public ImgAttachment pledgeDetailImg(int boardNo) {
		return dao.pledgeDetailImg(boardNo);
	}
	
	
	// 처음 조회일 조회
	@Override
	public Date pledgeHitDate(Board b) {
		return dao.pledgeHitDate(b);
	}
	//게시글 조회수 증가
	@Override
	public int increaseCount(Board b) {
		return dao.increaseCount(b);
	}

	
	//게시글 삭제
	@Override
	public int pledgeDeletePost(Post p) {
		return dao.pledgeDeletePost(p);
	}
	@Override
	public int pledgeDeleteBoard(Post p) {
		return  dao.pledgeDeleteBoard(p);
	}


	//카테고리 정보 가져오기
	@Override
	public SubCategory getCategoryNo(Post p) {
		return dao.getCategoryNo(p);
	}

	
	//댓글 조회
	@Override
	public List<Comment> selectCommentList(Board b) {
		return dao.selectCommentList(b);
	}

	//댓글등록
	@Override
	public int insertComment(Comment c) {
		return dao.insertComment(c);
	}

	//댓글수정
	@Override
	public int updateComment(Comment comment) {
		return dao.updateComment(comment);
	}

	//댓글삭제
	@Override
	public int deleteComment(Comment comment) {
		return dao.deleteComment(comment);
	}

	//게시글조회-페이징,검색
	@Override
	public Page<Post> loadListData(Pageable pageable, int page, String sort, String searchSelect, String searchValue, int subCategoryNo) {
		return dao.loadListData(pageable, page, sort, searchSelect, searchValue,subCategoryNo);
	}

	//실천서약 등록
	@Override
	public int insertSignature(Signature signature, Member signatureMember) {
		
		//로그인한 멤버정보 조회
		Member member = memberDao.getMember(signatureMember);

		String signatureMemberPhone = signatureMember.getPhone().replaceAll("-", "");
        String memberPhone = member.getPhone().replaceAll("-", "");

        Signature getSignature = dao.getSignature(signature);
   
        // 입력 정보와 로그인 멤버 정보 비교
        if (signatureMember.getUserName().equals(member.getUserName()) && signatureMemberPhone.equals(memberPhone)) {

        	//이미 서약이 존재하는 경우
            if(getSignature != null) {
            	return 2; 
            }
            return dao.insertSignature(signature);
        } else {
            return 3; // 동일하지 않으면 3 
        }
	}
	
	// 게시글 내 실천서약조회
	@Override
	public List<Signature> selectSignatureList(int pledgeNo) {
		return dao.selectSignatureList(pledgeNo);
	}

	//총 실천서약수
	@Override
	public int countSignature() {
		return dao.countSignature();
	}
	

	
}
