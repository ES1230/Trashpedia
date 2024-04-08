package com.kks.trashpedia.trash.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kks.trashpedia.GetClientIpAddress;
import com.kks.trashpedia.board.model.service.BoardService;
import com.kks.trashpedia.board.model.vo.ImgAttachment;
import com.kks.trashpedia.common.FileStore;
import com.kks.trashpedia.common.service.CommonService;
import com.kks.trashpedia.trash.model.service.TrashService;
import com.kks.trashpedia.trash.model.vo.Request;
import com.kks.trashpedia.trash.model.vo.Trash;
import com.kks.trashpedia.trash.model.vo.TrashBigCategory;
import com.kks.trashpedia.trash.model.vo.TrashHits;
import com.kks.trashpedia.trash.model.vo.TrashPost;
import com.kks.trashpedia.trash.model.vo.TrashSubCategory;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/trash")
@RequiredArgsConstructor
public class TrashController {
	
	private final TrashService service;
	private final FileStore fileStore;
	private final CommonService commonService;
	private final BoardService boardService;
	

	// 쓰레기사전 페이지 이동
	@GetMapping("/list")
	public ModelAndView showEncyclopediaPage() {
		ModelAndView modelAndView = new ModelAndView();
		
		//최근 업데이트된 쓰레기
		List<TrashPost> trashList = service.getRecentlyTrashList(); 
		
		//인기쓰레기
		List<TrashPost> popularList = service.getPopularList();
		
		modelAndView.addObject("trashList", trashList);
		modelAndView.addObject("popularList", popularList);
		modelAndView.setViewName("encyclopedia/trashEncyclopedia");
		return modelAndView;
	}

	//헤더 검색팝업창 인기쓰레기
	@GetMapping("/popularlist")
	public List<TrashPost> popularList() {
		List<TrashPost> popularList = service.getPopularList();
		return popularList;
	}
	
	
	//쓰레기 상세페이지이동
	@GetMapping("/detail")
	public ModelAndView trashDetail(TrashHits trashHits, int trashNo, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		
		String ip = GetClientIpAddress.getClientIpAddress(request);
		trashHits.setUserIp(ip);
		service.upCount(trashHits);
		
		Trash trash = service.trashDetail(trashNo);
		List<TrashPost> similarList = service.getSimilarList(trashNo);
		modelAndView.addObject("similarList", similarList);
		modelAndView.addObject("trash", trash);
		modelAndView.addObject("type", "read");
		modelAndView.setViewName("encyclopedia/trashEncyclopediaDetail");
		return modelAndView;
	}
	
	@GetMapping("/allList")
	public ModelAndView allTrashList(@RequestParam Map<String,Object> map) {
		ModelAndView mav = new ModelAndView();
		
		List<TrashBigCategory> bigCategoryList = service.getAllBigCategoryList();
		List<TrashSubCategory> subCategoryList = service.getAllSubCategoryList();
		List<Trash> trash = service.getAllTrashList(map);
		
		mav.addObject("bigCategory",bigCategoryList);
		mav.addObject("subCategory",subCategoryList);
		mav.addObject("trash",trash);
		
		mav.setViewName("encyclopedia/trashEncyclopediaResult");
		return mav;
	}
	
	@GetMapping("/write")
	public ModelAndView writeTrashPage() {
		ModelAndView mav = new ModelAndView("encyclopedia/trashEncyclopediaDetail");
		
		List<TrashBigCategory> bigCategoryList = service.getAllBigCategoryList();
		mav.addObject("type","insert");
		mav.addObject("bigCategory", bigCategoryList);
		return mav;
	}
	
	@GetMapping("/getSubcategoryList")
	public ResponseEntity<List<TrashSubCategory>> getSubcategoryList(int bigCategoryNo) {
		List<TrashSubCategory> list = service.getSubCategoryList(bigCategoryNo);
		return ResponseEntity.ok(list);
	}
	
	@PostMapping("/write")
	public ModelAndView writeTrash(TrashSubCategory tsc, TrashPost tp, int userNo, HttpSession session, @RequestParam("thumbnail") MultipartFile thumbnailImage) {
		ModelAndView mav = new ModelAndView("redirect:/admin/trash");
		int trashNo = service.writeTrash(tp, tsc, userNo);
		if (trashNo > 0) {
			ImgAttachment image;
			try {
				image = fileStore.storeImage(thumbnailImage);
				if (image != null) {
					image.setRefBno(trashNo);
					image.setImgType(2);
				}
				int result = commonService.insertFiles(image);
				if(result <= 0) {
					session.setAttribute("alert", "게시글 작성에 실패했습니다. 다시 시도해주세요");
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			session.setAttribute("alert", "게시글 작성에 실패했습니다. 다시 시도해주세요");
		}
		return mav;
	};
	
	@GetMapping("/delete/{trashNo}")
	public int deleteTrash(@PathVariable int trashNo) {
		return service.deleteTrash(trashNo);
	}
	
	@GetMapping("/undelete/{trashNo}")
	public int undeleteTrash(@PathVariable int trashNo) {
		return service.undeleteTrash(trashNo);
	}

	@GetMapping("/update/{trashNo}")
	public ModelAndView updateTrashPage(@PathVariable int trashNo) {
		ModelAndView mav = new ModelAndView("encyclopedia/trashEncyclopediaDetail");
		mav.addObject("trash", service.trashDetail(trashNo));
		mav.addObject("bigCategory", service.getAllBigCategoryList());
		mav.addObject("img", boardService.getImageUrl(trashNo, 2));
		mav.addObject("type","update");
		return mav;
	}
	
	@PostMapping("/update/{trashNo}")
	public ModelAndView updateTrash(
			@PathVariable int trashNo,
			@RequestParam("thumbnail") MultipartFile thumbnailImage,
			@RequestParam String deleteImg,
			HttpSession session,
			TrashPost trashPost,
			Trash trash
			) throws IOException {
		ModelAndView mav = new ModelAndView("redirect:/admin/trash");
		int result = service.updateTrashPost(trash, trashPost);
		if (result > 0) {
			ImgAttachment image;
			try {
				image = fileStore.storeImage(thumbnailImage);
				if (image != null) {
					commonService.deleteImage(trashNo);
					image.setRefBno(trashNo);
					image.setImgType(2);
					result = commonService.insertFiles(image);
				}
				if(result <= 0) {
					session.setAttribute("alert", "수정에 실패했습니다. 다시 시도해주세요.");
				} else {
					session.setAttribute("alert", "수정에 성공했습니다.");
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			session.setAttribute("alert", "수정에 실패했습니다. 다시 시도해주세요.");
		}
		return mav;
	}
	
	@PostMapping("/request/write")
	public int writeRequest(Request r) {
		return service.writeRequest(r);
	}
	
	@GetMapping("/request/{requestNo}")
	public Request getRequest(@PathVariable int requestNo){
		return service.getRequest(requestNo);
	}
	
	@GetMapping("/request/update")
	public int processingRequest(Request request) {
		return service.processingRequest(request);
	}
}