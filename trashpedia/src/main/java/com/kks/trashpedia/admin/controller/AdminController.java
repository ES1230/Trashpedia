package com.kks.trashpedia.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.kks.trashpedia.admin.model.service.adminService;
import com.kks.trashpedia.board.model.vo.BigCategory;
import com.kks.trashpedia.board.model.vo.Board;
import com.kks.trashpedia.board.model.vo.Comment;
import com.kks.trashpedia.board.model.vo.SubCategory;
import com.kks.trashpedia.member.model.vo.Member;
import com.kks.trashpedia.point.model.vo.PointHistory;
import com.kks.trashpedia.report.model.service.ReportService;
import com.kks.trashpedia.report.model.vo.Report;
import com.kks.trashpedia.trash.model.vo.Request;
import com.kks.trashpedia.trash.model.vo.Suggestion;
import com.kks.trashpedia.trash.model.vo.Trash;

@RestController
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	private adminService service;
	@Autowired
	private ReportService rService;
	
	// 관리자 로그인
	@GetMapping("/login")
	public ModelAndView adminLogin() {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/adminLogin");
		return mav;
	}
	// 메인페이지
	@GetMapping("")
	public ModelAndView adminMain() {
		int allMemberCount = service.allMemberCount();
		int allBoardCount = service.allBoardCount();
		int newMemberCount = service.newMemberCount();
		int oldMemberCount = service.oldMemberCount();
		int newBoardCount = service.newBoardCount();
		int oldBoardCount = service.oldBoardCount();
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("am", allMemberCount);
		mav.addObject("ab", allBoardCount);
		mav.addObject("nm", newMemberCount);
		mav.addObject("om", oldMemberCount);
		mav.addObject("nb", newBoardCount);
		mav.addObject("ob", oldBoardCount);
		mav.setViewName("admin/adminMain");
		return mav;
	}
	// 메인페이지 맴버 차트
	@GetMapping("/getMemberChartsData")
	public String getMemberChartsData() {
	    List<Member> memberChartData = service.getMemberChartsData();
	    StringBuilder json = new StringBuilder();
	    json.append("[");
	    for (Member data : memberChartData) {
	        json.append("{");
	        int orderDay = Integer.parseInt(data.getOrderDay().substring(data.getOrderDay().length() - 2));
	        json.append("\"orderDay\": ").append(orderDay).append(", ");
	        json.append("\"countMember\": ").append(data.getCountMember());
	        json.append("}, ");
	    }
	    if (!memberChartData.isEmpty()) {
	        json.delete(json.length() - 2, json.length());
	    }
	    json.append("]");
	    return json.toString();
	}
	// 메인페이지 보드 차트
	@GetMapping("/getBoardChartsData")
	public String getBoardChartsData() {
	    List<Board> boardChartData = service.getBoardChartsData();
	    List<Comment> commentChartData = service.getCommentChartsData();
	    StringBuilder json = new StringBuilder();
	    json.append("[");
	    for (Board data : boardChartData) {
	        json.append("{");
	        int orderDay = Integer.parseInt(data.getOrderDay().substring(data.getOrderDay().length() - 2));
	        json.append("\"orderDay\": ").append(orderDay).append(", ");
	        json.append("\"countBoard\": ").append(data.getCountBoard()).append(", ");
	        json.append("\"countComment\": 0");
	        json.append("}, ");
	    }
	    for (Comment data : commentChartData) {
	        json.append("{");
	        int orderDay = Integer.parseInt(data.getOrderDay().substring(data.getOrderDay().length() - 2));
	        json.append("\"orderDay\": ").append(orderDay).append(", ");
	        json.append("\"countBoard\": 0, ");
	        json.append("\"countComment\": ").append(data.getCountComment());
	        json.append("}, ");
	    }
	    if (!boardChartData.isEmpty() || !commentChartData.isEmpty()) {
	        json.delete(json.length() - 2, json.length());
	    }
	    json.append("]");
	    return json.toString();
	}
	
	// 관리자 회원 관리
	@GetMapping("/member")
	public ModelAndView memberManagement() {
		int cam = service.countAllMember();
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("cam",cam);
		mav.setViewName("admin/memberManagement");
		return mav;
	}
	// 관리자 회원 관리 회원 리스트
	@GetMapping("/getMemberList")
	public ResponseEntity<Page<Member>> getMember(
			@PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
			@RequestParam String sort,
			@RequestParam String searchSelect,
			@RequestParam String searchValue) {
		Page<Member> page = service.getMemberList(pageable, sort, searchSelect, searchValue);
		return ResponseEntity.ok(page);
	}
	// 관리자 회원 관리 유저 상세
	@GetMapping("/getMemberListDetail")
	public Member getMemberListDetail(@RequestParam int userNo) {
		return service.getMemberListDetail(userNo);
	}
	// 관리자 회원 관리 유저 상세 페이지
	@GetMapping("/member/detail")
	public ModelAndView memberManagementDetail(@RequestParam int userNo) {
		Member m = service.getMemberDetail(userNo);
		int b = service.memberCountBoard(userNo);
		int c = service.memberCountComment(userNo);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("m",m);
		mav.addObject("b",b);
		mav.addObject("c",c);
		mav.setViewName("admin/memberManagementDetail");
		return mav;
	}
	// 관리자 회원 관리 유저 상세 게시글 리스트
	@GetMapping("/getMemberBoardList")
	public ResponseEntity<Page<Board>> getMemberBoardList(
			@PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
			@RequestParam int userNo,
			@RequestParam String sort,
			@RequestParam String searchSelect,
			@RequestParam String searchValue) {
		Page<Board> page = service.getMemberBoardList(pageable, userNo, sort, searchSelect, searchValue);
		return ResponseEntity.ok(page);
	}
	// 관리자 회원 관리 유저 상세 게시글 상세
	@GetMapping("/getMemberBoardDetail")
	public ResponseEntity<Board> getMemberBoardDetail(@RequestParam int boardNo) {
		Board board = service.getMemberBoardDetail(boardNo);
		return ResponseEntity.ok(board);
	}
	// 관리자 회원 관리 유저 상세 댓글 리스트
	@GetMapping("/getMemberCommentList")
	public ResponseEntity<Page<Board>> getMemberCommentList(@PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable, 
			@RequestParam int userNo,
			@RequestParam String sort,
			@RequestParam String searchSelect,
			@RequestParam String searchValue
			) {
		Page<Board> page = service.getMemberCommentList(pageable, userNo, sort, searchSelect, searchValue);
		return ResponseEntity.ok(page);
	}
	// 관리자 회원 관리 유저 상세 댓글 상세
	@GetMapping("/getCommentDetailData")
	public List<Comment> getCommentDetail(@RequestParam int boardNo, @RequestParam int userNo) {
		return service.getCommentDetail(boardNo, userNo);
	}
	// 관리자 회원 관리 유저 상세 포인트 리스트
	@GetMapping("/getMemberPointList")
	public ResponseEntity<Page<PointHistory>> getMemberPointList(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
	@RequestParam int userNo,
	@RequestParam int page,
	@RequestParam String sort,
	@RequestParam String searchSelect,
	@RequestParam String searchValue) {
		Page<PointHistory> pages = service.getMemberPointList(pageable, page, userNo, sort, searchSelect, searchValue);
		return ResponseEntity.ok(pages);
	}
	// 관리자 회원 관리 유저 상세 신고 리스트
	@GetMapping("/getMemberReportList")
	public ResponseEntity<Page<Report>> getMemberReportList(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
	@RequestParam int userNo,
	@RequestParam int page,
	@RequestParam String sort,
	@RequestParam String searchSelect,
	@RequestParam String searchValue) {
		Page<Report> pages = service.getMemberReportList(pageable, page, userNo, sort, searchSelect, searchValue);
		return ResponseEntity.ok(pages);
	}
	
	// 관리자 게시판 관리
	@GetMapping("/board")
	public ModelAndView boardManagement() {
		List<BigCategory> BigCategoryList = service.BigCategoryList();
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("bcl",BigCategoryList);
		mav.setViewName("admin/boardManagement");
		return mav;
	}
	// 관리자 게시판 관리 서브카테고리 리스트
	@GetMapping("/getSubCategoryList")
	public ResponseEntity<List<SubCategory>> getSubCategoryList(@RequestParam int bigCategoryNo){
		List<SubCategory> list = service.getSubCategoryList(bigCategoryNo);
		return ResponseEntity.ok(list);
	}
	// 관리자 게시판 관리 게시글 리스트
	@GetMapping("/loadBoardListData")
	public ResponseEntity<Page<Board>> loadBoardListData(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
			@RequestParam int page,
			@RequestParam String sort,
			@RequestParam String searchSelect,
			@RequestParam String searchValue){
		Page<Board> pages = service.loadBoardListData(pageable, page, sort, searchSelect, searchValue);
		return ResponseEntity.ok(pages);
	}
	// 관리자 게시판 관리 게시글 리스트
	@GetMapping("/loadCommentListData")
	public ResponseEntity<Page<Board>> loadCommentListData(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
			@RequestParam int page,
			@RequestParam String sort,
			@RequestParam String searchSelect,
			@RequestParam String searchValue){
		Page<Board> pages = service.loadCommentListData(pageable, page, sort, searchSelect, searchValue);
		return ResponseEntity.ok(pages);
	}
	@GetMapping("/trash")
	public ModelAndView trashManagement() {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/trashManagement");
		return mav;
	}
	
	@GetMapping("/getTrashList")
	public ResponseEntity<Page<Trash>> getTrashList(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable,
	@RequestParam int page,
	@RequestParam String sort,
	@RequestParam String searchSelect,
	@RequestParam String searchValue){
		Page<Trash> pages = service.getTrashList(pageable, page);
		return ResponseEntity.ok(pages);
	}
	
	@GetMapping("/loadSuggestionListData")
	public ResponseEntity<Page<Suggestion>> loadSuggestionListData(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable){
		Page<Suggestion> pages = service.loadSuggestionListData(pageable);
		return ResponseEntity.ok(pages);
	}
	
	@GetMapping("/loadRequestListData")
	public ResponseEntity<Page<Request>> loadRequestListData(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable){
		Page<Request> pages = service.loadRequestListData(pageable);
		return ResponseEntity.ok(pages);
	}
	
	@GetMapping("/report")
	public ModelAndView reportManagement(){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/admin/reportManagement");
		return mav;
	}
	
	@GetMapping("/getBoardReportList")
	public ResponseEntity<Page<Report>> getBoardReportList(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable){
		Page<Report> pages = rService.getBoardReportList(pageable);
		return ResponseEntity.ok(pages);
	}
	
	@GetMapping("/getCommentReportList")
	public ResponseEntity<Page<Report>> getCommentReportList(@PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable){
		Page<Report> pages = rService.getCommentReportList(pageable);
		return ResponseEntity.ok(pages);
	}
	
	
	@GetMapping("/{boardId}")
	public String boardId(@PathVariable String boardId) {
		return boardId + "admin";
	}
	
	@GetMapping("/update")
	public String boardUpdate(@RequestParam String boardId) {
		return boardId + "update";
		// localhost:8085/trashpedia/update?boardId=3
		// boardId에 3 값을 가져옴
	}
}
