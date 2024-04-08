package com.kks.trashpedia.common.controller;

import java.io.IOException;
import java.net.MalformedURLException;

import org.springframework.core.io.UrlResource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.kks.trashpedia.board.model.vo.Attachment;
import com.kks.trashpedia.board.model.vo.Board;
import com.kks.trashpedia.board.model.vo.ImgAttachment;
import com.kks.trashpedia.board.model.vo.Post;
import com.kks.trashpedia.board.model.vo.SubCategory;
import com.kks.trashpedia.common.FileStore;
import com.kks.trashpedia.common.service.CommonService;
import com.kks.trashpedia.pledge.model.service.PledgeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class CommonController {
	
	private final CommonService service;
	private final PledgeService pService;
	private final FileStore fileStore;
	
	//에러페이지 이동
	@GetMapping("/errorPage")
	public ModelAndView errorPage() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/errorPage/errorPage");
		return mv;
	}
	
	//카테고리 정보 가지고오기
	@GetMapping("/write")
	public ModelAndView getCategory(SubCategory subcate, int type, HttpServletRequest request) {
		
		String nextUrl = request.getHeader("referer");
		request.getSession().setAttribute("nextUrl", nextUrl);
		
		ModelAndView mv = new ModelAndView();
		SubCategory category = service.getSubCategory(subcate);
		mv.addObject("category",category);
		mv.addObject("type",type);
		mv.setViewName("common/boardInsert");
		return mv;
	}
	
	//게시글 등록
	@PostMapping("/write")
	public ModelAndView insertBoard(
			SubCategory subcategory, 
			Post p, 
			Board b,
			RedirectAttributes ra, 
			HttpSession session,
			@RequestParam("thumbnail") MultipartFile thumbnailImage,
			@RequestParam("upfile") MultipartFile upfile,
			@RequestParam int type
			) throws IOException {
		ModelAndView mv = new ModelAndView();
		
		//session에 담긴 마지막 url가지고오기
		String nextUrl = (String) session.getAttribute("nextUrl");
		
		// post 등록
		int postNo = service.createPost(p);

		b.setPostNo(postNo);
		b.setSubCategoryNo(subcategory.getSubCategoryNo());
		
		// board 등록
		if (postNo > 0) {
			int boardNo = service.createBoard(b);
			if (boardNo > 0) { 		
				// 첨부파일, 이미지 파일 저장
				Attachment attachment = fileStore.storeFile(upfile);
				ImgAttachment image = fileStore.storeImage(thumbnailImage);

				if (attachment != null) {
					attachment.setRefBno(boardNo);
					attachment.setFileType(type);
				}
				if (image != null) {
					image.setRefBno(boardNo);
					image.setImgType(type);
				}
				service.insertFiles(attachment, image);
				ra.addFlashAttribute("alert", "게시글이 작성되었습니다.");
			} else {
				ra.addFlashAttribute("alert", "게시글 작성에 실패하셨습니다.");
			}
		} else {
			ra.addFlashAttribute("alert", "게시글 작성에 실패하셨습니다.");
		}
		mv.setViewName("redirect:"+nextUrl);
		if (nextUrl == null) {
			mv.setViewName("redirect:/");
		}
		return mv;
	}

	// 이미지출력
	@ResponseBody
	@GetMapping("/image/{filename}")
	public UrlResource showImage(@PathVariable String filename) throws MalformedURLException {
		UrlResource url = new UrlResource("file:" + fileStore.getFullPath2(filename));
	    return url;
	}
	
	//게시글수정 페이지이동
	@GetMapping("/update")
	public ModelAndView updatePostPage(@RequestParam int type,SubCategory subcate, Board b, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		SubCategory category = service.getSubCategory(subcate);
		Post post = service.getPost(b.getPostNo());
		
		// 수정누르기 전 마지막 url담기
		String nextUrl = request.getHeader("referer");
		request.getSession().setAttribute("nextUrl", nextUrl);
		
		//이미지,첨부파일,카테고리
		ImgAttachment img = pService.pledgeDetailImg(post.getBoardNo());
		Attachment attachment = pService.pledgeDetailAttach(post.getBoardNo());
		
		mv.addObject("category",category);
		mv.addObject("board",b);
		mv.addObject("img",img);
		mv.addObject("attachment",attachment);
		mv.addObject("post",post);
		mv.addObject("type",type);
		mv.setViewName("common/boardInsert");
		
		return mv;
	}
	
	//게시글 수정
	@PostMapping("/update")
	public ModelAndView updatePost( 
			Post p,
			@RequestParam("thumbnail") MultipartFile thumbnailImage,
			@RequestParam("upfile") MultipartFile upfile,
			@RequestParam int type,
			@RequestParam String deleteImg,
			@RequestParam String deleteFile,
			RedirectAttributes ra, 
			HttpSession session,
			ModelAndView mv
			) throws IOException {
		
		int result = service.updatePost(p, deleteImg, deleteFile, upfile, thumbnailImage,type);
		
		//session에 담긴 마지막 url가지고오기
		String nextUrl = (String) session.getAttribute("nextUrl");
	    
		if (result > 0) {
			ra.addFlashAttribute("alert", "게시글이 수정되었습니다.");
		} else {
			ra.addFlashAttribute("alert", "게시글 수정에 실패했습니다.");
		}

		mv.setViewName("redirect:"+nextUrl);

		if (nextUrl == null) {
			mv.setViewName("redirect:/");
		}
		
		return mv;
	}
	
	// 목록으로 돌아가기
	@GetMapping("/returnList")
	public ModelAndView returnList( SubCategory subcategory, ModelAndView mv, RedirectAttributes ra, HttpSession session ) {

	    String nextUrl = (String) session.getAttribute("lastUrl");

	    mv.setViewName("redirect:/");

	    if (nextUrl != null) {
	        // 첫 번째 path segment만 추출
	        UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(nextUrl);
	        String firstPathSegment = builder.build().getPathSegments().get(0);

	        mv.setViewName("redirect:" + "/" + firstPathSegment
	        		+ "/list?bigCategoryNo=" + subcategory.getBigCategoryNo()
	                + "&subCategoryNo=" + subcategory.getSubCategoryNo());
	    }
	    return mv;
	}
}